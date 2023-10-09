TERMUX_PKG_HOMEPAGE=https://fex-emu.com/
TERMUX_PKG_DESCRIPTION="Fast x86 emulation frontend"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2212
TERMUX_PKG_SRCURL=git+https://github.com/FEX-Emu/FEX
TERMUX_PKG_GIT_BRANCH=FEX-${TERMUX_PKG_VERSION}
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTS=OFF
-DENABLE_LTO=OFF
-DENABLE_JEMALLOC=OFF
-DENABLE_OFFLINE_TELEMETRY=OFF
-DENABLE_TERMUX_BUILD=True
-DTUNE_CPU=generic
-DTUNE_ARCH=armv8-a
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_pre_configure() {
	find $TERMUX_PKG_SRCDIR -name '*.h' -o -name '*.c' -o -name '*.cpp' | \
		xargs -n 1 sed -i -e 's:"/tmp:"'$TERMUX_PREFIX'/tmp:g'
}

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag#FEX-}"
}
