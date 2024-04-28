TERMUX_PKG_HOMEPAGE=https://abiword.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.2"
TERMUX_PKG_SRCURL=https://github.com/AbiWord/enchant/releases/download/v${TERMUX_PKG_VERSION}/enchant-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cc3400a6657974a740b6e3c2568e2935c70e5302f07fadb2095366b75ecad6f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-relocatable"
TERMUX_PKG_DEPENDS="aspell, glib, hunspell, libc++"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libenchant-2.so"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
