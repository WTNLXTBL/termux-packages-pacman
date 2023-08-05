TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2023.08.05"
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/releases/download/v$TERMUX_PKG_VERSION/kakoune-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=3e45151e0addd3500de2d6a29b5aacf2267c42bb256d44a782e73defb29cda5c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no "

termux_step_pre_configure() {
	# This patch should be no longer needed when NDK bumps to r26
	local _file="$TERMUX_PKG_BUILDER_DIR/src-display_buffer.hh.patch"
	if [ -f $_file && "$TERMUX_NDK_VERSION" != 25c ]; then
		termux_error_exit "Please remove $_file"
	fi
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/kak 45
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/kak
		fi
	fi
	EOF
}
