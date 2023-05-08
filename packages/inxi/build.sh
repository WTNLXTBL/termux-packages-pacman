TERMUX_PKG_HOMEPAGE=https://github.com/smxi/inxi
TERMUX_PKG_DESCRIPTION="Full featured CLI system information tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.27-1
TERMUX_PKG_SRCURL=https://github.com/smxi/inxi/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=35207195579261ddfe59508fdc92d40902c91230084d2b98b4541a6f4c682f63
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin/ inxi
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1/ inxi.1
}
