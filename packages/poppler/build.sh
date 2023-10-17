TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `poppler-qt` package.
TERMUX_PKG_VERSION="23.10.0"
TERMUX_PKG_REVISION=1
# Do not forget to bump revision of reverse dependencies and rebuild them
# when SOVERSION is changed.
_POPPLER_SOVERSION=132
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=31a3dfdea79f4922402d313737415a44d44dc14d6b317f959a77c5bba0647dd9
# The package must be updated at the same time as poppler, auto updater script does not support that.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, libc++, libcairo, libcurl, libiconv, libjpeg-turbo, libpng, libtiff, littlecms, openjpeg, zlib, libnss, gpgme, gpgmepp"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, g-ir-scanner, openjpeg-tools"
TERMUX_PKG_BREAKS="poppler-dev, poppler-qt (<< ${TERMUX_PKG_VERSION})"
TERMUX_PKG_REPLACES="poppler-dev, poppler-qt (<< 22.04.0-3)"
TERMUX_PKG_DISABLE_GIR=false
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_GOBJECT_INTROSPECTION=ON
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=OFF
-DENABLE_QT6=OFF
-DFONT_CONFIGURATION=fontconfig
"

termux_step_pre_configure() {
	if ! test "${_POPPLER_SOVERSION}"; then
		termux_error_exit "Please set _POPPLER_SOVERSION variable."
	fi
	local sover_x11=$(. $TERMUX_SCRIPTDIR/x11-packages/poppler-qt/build.sh; echo $_POPPLER_SOVERSION)
	if [ "${sover_x11}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION mismatch with \"poppler-qt\" package."
	fi
	local sover_cmake=$(sed -En 's/^set\(POPPLER_SOVERSION_NUMBER "([0-9]+)"\)$/\1/p' CMakeLists.txt)
	if [ "${sover_cmake}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed (CMakeLists.txt: \"${sover_cmake}\")."
	fi

	termux_setup_gir

	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}

termux_pkg_auto_update() {
	local LATEST_VERSION="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	if [[ "$LATEST_VERSION" == "null" ]]; then
		echo "INFO: Already up to date."
		return 0
	fi
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${LATEST_VERSION}"; then
		mv "$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}" "$TERMUX_PKG_BUILDER_DIR/gir/${LATEST_VERSION##*:}"
	fi
	termux_repology_auto_update
}
