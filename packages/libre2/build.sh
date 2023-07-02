TERMUX_PKG_HOMEPAGE=https://github.com/google/re2
TERMUX_PKG_DESCRIPTION="A regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2023.07.01
TERMUX_PKG_SRCURL=https://github.com/google/re2/archive/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=18cf85922e27fad3ed9c96a27733037da445f35eb1a2744c306a37c6d11e95c4
TERMUX_PKG_DEPENDS="abseil-cpp, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=11

	local v=$(sed -E -n 's/^SONAME=([0-9]+)$/\1/p' Makefile)
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "Error: SOVERSION guard check failed."
	fi
}
