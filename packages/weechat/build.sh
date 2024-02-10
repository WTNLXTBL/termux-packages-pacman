TERMUX_PKG_HOMEPAGE=https://weechat.org/
TERMUX_PKG_DESCRIPTION="Fast, light and extensible IRC chat client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# `weechat-python-plugin` depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_SRCURL=https://www.weechat.org/files/src/weechat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=253ddf086f6c845031a2dd294b1552851d6b04cc08a2f9da4aedfb3e2f91bdcd
TERMUX_PKG_DEPENDS="libandroid-support, libcurl, libgcrypt, libgnutls, libiconv, ncurses, zlib, zstd"
TERMUX_PKG_BREAKS="weechat-dev"
TERMUX_PKG_REPLACES="weechat-dev"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/weechat-curses
share/icons
share/man/man1/weechat-headless.1
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCA_FILE=${TERMUX_PREFIX}/etc/tls/cert.pem
-DGETTEXT_FOUND=ON
-DENABLE_GUILE=OFF
-DENABLE_HEADLESS=OFF
-DENABLE_JAVASCRIPT=OFF
-DENABLE_LUA=ON
-DENABLE_MAN=ON
-DENABLE_PERL=ON
-DENABLE_PYTHON3=ON
-DENABLE_PHP=OFF
-DENABLE_RUBY=ON
-DENABLE_SPELL=OFF
-DENABLE_TCL=OFF
-DENABLE_TESTS=OFF
-DLIBGCRYPT_CONFIG_EXECUTABLE=${TERMUX_PREFIX}/bin/libgcrypt-config
-DMSGFMT_EXECUTABLE=$(command -v msgfmt)
-DMSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DSTRICT=ON
-DXGETTEXT_EXECUTABLE=$(command -v xgettext)
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPKG_CONFIG_EXECUTABLE=${PKG_CONFIG}"
}
