TERMUX_PKG_HOMEPAGE=https://github.com/XmacsLabs/mogan
TERMUX_PKG_DESCRIPTION="A structure editor forked from GNU TeXmacs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/XmacsLabs/mogan/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ba26b0d43e0727c9aa5c3cf7fb84890f6014b03e6409031c0512dc1c5c42348
TERMUX_PKG_DEPENDS="freetype, ghostscript, libandroid-complex-math, libandroid-execinfo, libandroid-spawn, libc++, libcurl, libiconv, libjpeg-turbo, libpng, libsqlite, mogan-data, qt5-qtbase, qt5-qtsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-complex-math -landroid-execinfo -landroid-spawn"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/Xmacs/plugins/shell/bin
	ln -sfTr $TERMUX_PREFIX/{libexec,share}/Xmacs/plugins/shell/bin/tm_shell
}
