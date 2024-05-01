TERMUX_PKG_HOMEPAGE=https://github.com/ndevilla/iniparser
TERMUX_PKG_DESCRIPTION="Offers parsing of ini files from the C level"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2"
TERMUX_PKG_SRCURL=https://github.com/ndevilla/iniparser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbcbaf3aedb4f88a9fc0df4b315737ddd10e6c37918e3d89f0ecc475333bde4d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libiniparser.so.1
	ln -sf libiniparser.so.1 $TERMUX_PREFIX/lib/libiniparser.so
	install -Dm600 -t $TERMUX_PREFIX/include/iniparser src/*.h
}
