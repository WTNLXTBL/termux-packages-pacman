TERMUX_PKG_HOMEPAGE=https://tukaani.org/xz/
TERMUX_PKG_DESCRIPTION="XZ-format compression library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.GPLv2, COPYING.GPLv3, COPYING.LGPLv2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/lzmautils/xz-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=92177bef62c3824b4badc524f8abcce54a20b7dbcfb84cde0a2eb8b49159518c
TERMUX_PKG_BREAKS="liblzma-dev"
TERMUX_PKG_REPLACES="liblzma-dev"
TERMUX_PKG_ESSENTIAL=true

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/liblzma.so.5"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done

	# Check if SONAME is properly set:
	if ! readelf -d lib/liblzma.so | grep -q '(SONAME).*\[liblzma\.so\.'; then
		termux_error_exit "SONAME of liblzma.so is not properly set."
	fi
}
