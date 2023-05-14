TERMUX_PKG_HOMEPAGE=https://wasmedge.org
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.1
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68812775e5f5237300101f712eadf9d666b18859021edfa672e914db140ef957
TERMUX_PKG_DEPENDS="libc++, libllvm, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, boost-static, libllvm-static, libpolly, lld, llvm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_FORCE_DISABLE_LTO=ON
"

# WASMEDGE_BUILD_AOT_RUNTIME is not supported on 32-bit archs.
# See https://github.com/WasmEdge/WasmEdge/blob/2414c83047f2bf8fe241716be6ef8c0de34dc245/lib/aot/compiler.cpp#L4874
if [ $TERMUX_ARCH_BITS = 32 ]; then
	TERMUX_PKG_DEPENDS="libc++"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWASMEDGE_BUILD_AOT_RUNTIME=OFF"
fi

# Build failure for i686 (0.9.1):
# ```
# [...]/wasmedge/src/thirdparty/wasi/api.hpp:55:1: error: static_assert failed
# due to requirement 'alignof(long long) == 8' "non-wasi data layout"
# static_assert(alignof(int64_t) == 8, "non-wasi data layout");
# ^             ~~~~~~~~~~~~~~~~~~~~~
# ```
# Build failure for i686 (0.10.1):
# [14/83] Building CXX object lib/system/CMakeFiles/wasmedgeSystem.dir/allocator.cpp.o
# FAILED: lib/system/CMakeFiles/wasmedgeSystem.dir/allocator.cpp.o
# ...
# /home/builder/.termux-build/wasmedge/src/lib/system/allocator.cpp:149:42: error: use of undeclared identifier 'PROT_READ'
#  if (auto Pointer = mmap(nullptr, Size, PROT_READ | PROT_WRITE,
#                                         ^
# Both i686 and arm warning (0.10.1):
# /home/builder/.termux-build/wasmedge/src/lib/aot/compiler.cpp:1202:24: warning: unused variable 'VectorSize' [-Wunused-variable]
#         const uint32_t VectorSize = IsFloat ? 4 : 2;
#                        ^
# Upstream doesnt seem to support 32bit platforms well
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
