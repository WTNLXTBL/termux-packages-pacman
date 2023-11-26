TERMUX_PKG_HOMEPAGE=https://github.com/strukturag/libde265
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream decoder library"
TERMUX_PKG_LICENSE="LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.14"
TERMUX_PKG_SRCURL=https://github.com/strukturag/libde265/releases/download/v$TERMUX_PKG_VERSION/libde265-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=99f46ef77a438be639aa3c5d9632c0670541c5ed5d386524d4199da2d30df28f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sherlock265 --disable-arm --disable-encoder"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^LIBDE265_'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	sed -i "s#tools##;s#acceleration-speed##" ${TERMUX_PKG_SRCDIR}/Makefile.am
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
