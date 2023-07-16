TERMUX_PKG_HOMEPAGE=https://github.com/kpet/clvk
TERMUX_PKG_DESCRIPTION="Experimental implementation of OpenCL on Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=86eaa5b1b4752d05b6e0f03d830e49835fee6ac2
_COMMIT_DATE=20230711
_COMMIT_TIME=203113
TERMUX_PKG_VERSION="0.0.20230711.203113g86eaa5b1"
TERMUX_PKG_SRCURL=git+https://github.com/kpet/clvk
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, vulkan-loader-android"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_SUGGESTS="ocl-icd"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

# https://github.com/kpet/clvk/blob/main/CMakeLists.txt

# Upstream prefers building with Khronos Vulkan Loader
# We use NDK stub to properly test if it works on Android
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_NATIVE_TOOL_DIR=${TERMUX_PKG_HOSTBUILD_DIR}/bin
-DCLVK_VULKAN_IMPLEMENTATION=custom
-DVulkan_INCLUDE_DIRS=${TERMUX_PREFIX}/include
"

# Explicitly enable build tests to check undefined symbols even when
# its default
#
# [1877/1888] Linking CXX executable api_tests
# FAILED: api_tests
# ...
# libOpenCL.so: error: undefined reference to 'vkGetPhysicalDeviceFeatures2'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCLVK_BUILD_TESTS=ON"

# Use CLVK_CLSPV_ONLINE_COMPILER=ON to combine clspv with clvk
# May look into separate clspv if clvk libOpenCL.so can find from PATH
# instead of setting CLVK_CLSPV_BIN
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCLVK_CLSPV_ONLINE_COMPILER=ON"

# clvk currently does not have proper versioning nor releases
# Use dates and commits as versioning for now
termux_pkg_auto_update() {
	local latest_commit=$(curl -s https://api.github.com/repos/kpet/clvk/commits | jq .[].sha | head -1 | sed -e 's|\"||g')
	if [[ -z "${latest_commit}" ]]; then
		echo "WARN: Unable to get latest commit from upstream. Try again later." >&2
		return 0
	fi

	if [[ "${latest_commit}" == "${_COMMIT}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return 0
	fi

	local latest_commit_date_tz=$(curl -s "https://api.github.com/repos/kpet/clvk/commits/${latest_commit}" | jq .commit.committer.date | sed -e 's|\"||g')
	if [[ -z "${latest_commit_date_tz}" ]]; then
		termux_error_exit "ERROR: Unable to get latest commit date info"
	fi

	local latest_commit_date=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\1|' -e 's|\-||g')
	local latest_commit_time=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\2|' -e 's|\:||g')

	# https://github.com/termux/termux-packages/issues/11827
	# really fix it by including longer date time info into versioning
	# always check this in case upstream change the version format
	local latest_version="0.0.${latest_commit_date}.${latest_commit_time}g${latest_commit:0:8}"

	local current_date_epoch=$(date "+%s")
	local _COMMIT_DATE_epoch=$(date -d "${_COMMIT_DATE}" "+%s")
	local current_date_diff=$(((current_date_epoch-_COMMIT_DATE_epoch)/(60*60*24)))
	if [[ "${current_date_diff}" -lt 7 ]]; then
		echo "INFO: Queuing updates after 7 days since last push, currently its ${current_date_diff}"
		return 0
	fi

	if ! dpkg --compare-versions "${latest_version}" gt "${TERMUX_PKG_VERSION}"; then
		termux_error_exit "ERROR: Resulting latest version is not counted as update to the current version (${latest_version} < ${TERMUX_PKG_VERSION})"
	fi

	# unlikely to happen
	if [[ "${latest_commit_date}" -lt "${_COMMIT_DATE}" ]]; then
		termux_error_exit "ERROR: Upstream is older than current package version. Please report to upstream."
	elif [[ "${latest_commit_date}" -eq "${_COMMIT_DATE}" ]] && [[ "${latest_commit_time}" -lt "${_COMMIT_TIME}" ]]; then
		termux_error_exit "ERROR: Upstream is older than current package version. Please report to upstream."
	fi

	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" \
		-e "s|^_COMMIT=.*|_COMMIT=${latest_commit}|" \
		-e "s|^_COMMIT_DATE=.*|_COMMIT_DATE=${latest_commit_date}|" \
		-e "s|^_COMMIT_TIME=.*|_COMMIT_TIME=${latest_commit_time}|"

	# maybe save a few ms as we already done version check
	termux_pkg_upgrade_version "${latest_version}" --skip-version-check
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "${_COMMIT}"
	git submodule update --init --recursive
	./external/clspv/utils/fetch_sources.py --deps llvm
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}/external/clspv/third_party/llvm/llvm" \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS=clang
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-j "${TERMUX_MAKE_PROCESSES}" \
		llvm-tblgen clang-tblgen
}

termux_step_pre_configure() {
	local _libvulkan=vulkan
	if [[ "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
		_libvulkan="$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/28/libvulkan.so"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARIES=${_libvulkan}"

	export CFLAGS+=" -flto=thin"
	export CXXFLAGS+=" -flto=thin"

	# from packages/libllvm/build.sh
	export _LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	export _LLVM_TARGET_ARCH
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		_LLVM_TARGET_ARCH=ARM
	elif [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		_LLVM_TARGET_ARCH=AArch64
	elif [[ "${TERMUX_ARCH}" == "i686" ]] || [[ "${TERMUX_ARCH}" == "x86_64" ]]; then
		_LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: ${TERMUX_ARCH}"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=${_LLVM_TARGET_ARCH}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGETS_TO_BUILD=${_LLVM_TARGET_ARCH}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=${_LLVM_DEFAULT_TARGET_TRIPLE}"

	# TERMUX_DEBUG_BUILD doesnt really have somewhere in between
	#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_BUILD_TYPE=RelWithDebInfo"
	#export STRIP=:
}

termux_step_make_install() {
	# clvk does not have proper install rule yet
	install -Dm644 "${TERMUX_PKG_BUILDDIR}/libOpenCL.so" "${TERMUX_PREFIX}/lib/clvk/libOpenCL.so"

	echo "${TERMUX_PREFIX}/lib/clvk/libOpenCL.so" > "${TERMUX_PKG_TMPDIR}/clvk.icd"
	install -Dm644 "${TERMUX_PKG_TMPDIR}/clvk.icd" "${TERMUX_PREFIX}/etc/OpenCL/vendors/clvk.icd"
}
