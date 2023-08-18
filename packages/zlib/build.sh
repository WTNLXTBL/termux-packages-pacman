TERMUX_PKG_HOMEPAGE=https://www.zlib.net/
TERMUX_PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7
TERMUX_PKG_BREAKS="ndk-sysroot (<< 19b-3), zlib-dev"
TERMUX_PKG_REPLACES="ndk-sysroot (<< 19b-3), zlib-dev"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a+crc"
		CXXFLAGS+=" -march=armv8-a+crc"
	fi
}

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/configure" --prefix=$TERMUX_PREFIX
}
