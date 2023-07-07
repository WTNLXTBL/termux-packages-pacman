TERMUX_PKG_HOMEPAGE=https://tinygo.org
TERMUX_PKG_DESCRIPTION="Go compiler for microcontrollers, WASM, CLI tools"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/tinygo-org/tinygo
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libc++, tinygo-common"
TERMUX_PKG_RECOMMENDS="binaryen"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

_LLVM_OPTION="
-DGENERATOR_IS_MULTI_CONFIG=ON
-DLLVM_TABLEGEN=${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-tblgen
-DCLANG_TABLEGEN=${TERMUX_PKG_HOSTBUILD_DIR}/bin/clang-tblgen
"

_LLVM_EXTRA_BUILD_TARGETS="
lib/libLLVMFuzzerCLI.a
lib/libLLVMFuzzMutate.a
lib/libLLVMFileCheck.a
lib/libLLVMInterfaceStub.a
lib/libLLVMMIRParser.a
lib/libLLVMDWARFLinker.a
lib/libLLVMFrontendOpenACC.a
lib/libLLVMObjCopy.a
lib/libLLVMObjectYAML.a
lib/libLLVMDebugInfoGSYM.a
lib/libLLVMDWP.a
lib/libLLVMJITLink.a
lib/libLLVMOrcJIT.a
lib/libLLVMLineEditor.a
lib/libLLVMXRay.a
"

termux_step_post_get_source() {
	# https://github.com/espressif/llvm-project
	make llvm-source GO=:
}

termux_step_host_build() {
	termux_setup_golang
	termux_setup_cmake
	termux_setup_ninja

	pushd "${TERMUX_PKG_SRCDIR}"
	make "${TERMUX_PKG_HOSTBUILD_DIR}" \
		LLVM_BUILDDIR="${TERMUX_PKG_HOSTBUILD_DIR}"

	# build whatever llvm-config think is missing
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-j "${TERMUX_MAKE_PROCESSES}" \
		${_LLVM_EXTRA_BUILD_TARGETS}

	echo "========== llvm-config =========="
	file "${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config"
	"${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config" --cppflags
	"${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config" --ldflags --libs --system-libs
	echo "========== llvm-config =========="

	make build/release \
		LLVM_BUILDDIR="${TERMUX_PKG_HOSTBUILD_DIR}" \
		CLANG="${TERMUX_PKG_HOSTBUILD_DIR}/bin/clang" \
		LLVM_AR="${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-ar" \
		LLVM_NM="${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-nm" \
		USE_SYSTEM_BINARYEN=1
	popd
}

termux_step_pre_configure() {
	# https://github.com/termux/termux-packages/issues/16358
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		echo "WARN: ld.lld wrapper is not working for on-device builds. Skipping."
		return
	fi

	local _WRAPPER_BIN=${TERMUX_PKG_BUILDDIR}/_wrapper/bin
	mkdir -p "${_WRAPPER_BIN}"
	ln -fs "${TERMUX_STANDALONE_TOOLCHAIN}/bin/lld" "${_WRAPPER_BIN}/ld.lld"
	cat <<- EOF > "${_WRAPPER_BIN}/ld.lld.sh"
	#!/bin/bash
	tmpfile=\$(mktemp)
	python ${TERMUX_PKG_BUILDER_DIR}/fix-rpath.py -rpath=${TERMUX_PREFIX}/lib \$@ > \${tmpfile}
	args=\$(cat \${tmpfile})
	rm -f \${tmpfile}
	${_WRAPPER_BIN}/ld.lld \${args}
	EOF
	chmod +x "${_WRAPPER_BIN}/ld.lld.sh"
	rm -f "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
	ln -fs "${_WRAPPER_BIN}/ld.lld.sh" "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
}

termux_step_make() {
	termux_setup_golang
	termux_setup_cmake
	termux_setup_ninja

	# from packages/libllvm/build.sh
	local _LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	local _LLVM_TARGET_ARCH
	case "${TERMUX_ARCH}" in
		aarch64) _LLVM_TARGET_ARCH=AArch64 ;;
		arm) _LLVM_TARGET_ARCH=ARM ;;
		i686|x86_64) _LLVM_TARGET_ARCH=X86 ;;
		*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac

	_LLVM_OPTION+=" -DLLVM_TARGET_ARCH=${_LLVM_TARGET_ARCH}"
	_LLVM_OPTION+=" -DLLVM_HOST_TRIPLE=${_LLVM_DEFAULT_TARGET_TRIPLE}"

	make llvm-build LLVM_OPTION="$(echo ${_LLVM_OPTION})"

	ninja \
		-C llvm-build \
		-j "${TERMUX_MAKE_PROCESSES}" \
		${_LLVM_EXTRA_BUILD_TARGETS}

	# replace Android llvm-config with wrapper around host build
	cat <<- EOF > llvm-build/bin/llvm-config
	#!/bin/bash
	${TERMUX_PKG_HOSTBUILD_DIR}/bin/llvm-config "\$@" | \
	sed \
	-e "s|${TERMUX_PKG_HOSTBUILD_DIR}|${TERMUX_PKG_SRCDIR}/llvm-build|g" \
	-e "s|-lrt|-lc|g"
	EOF

	make tinygo
	mkdir -p build/release/tinygo/bin
	cp -fv build/tinygo build/release/tinygo/bin

	# skip make gen-device, done in host build
	# skip make wasi-libc, NDK doesnt support wasm32-unknown-wasi
	# skip make binaryen

	# check excessive runpath entries
	local tinygo_readelf=$(readelf -dW build/release/tinygo/bin/tinygo)
	local tinygo_runpath=$(echo "${tinygo_readelf}" | grep RUNPATH | sed -e "s|.*\[\(.*\)\]|\1|")
	if [[ "${tinygo_runpath}" != "${TERMUX_PREFIX}/lib" ]]; then
		termux_error_exit <<- EOL
		Excessive RUNPATH found. Check readelf output below:
		${tinygo_readelf}
		EOL
	fi
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/lib/tinygo"
	cp -fr "${TERMUX_PKG_SRCDIR}/build/release/tinygo" "${TERMUX_PREFIX}/lib"
	ln -sv "../lib/tinygo/bin/tinygo" "${TERMUX_PREFIX}/bin/tinygo"
}
