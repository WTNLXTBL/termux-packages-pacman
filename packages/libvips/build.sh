TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Thibault Meyer <meyer.thibault@gmail.com>"
TERMUX_PKG_VERSION="8.14.4"
TERMUX_PKG_SRCURL=https://github.com/libvips/libvips/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0638150ee5066814aa22ca89e0285f2310a539be3c39a631edeb38135a3f1f15
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cgif, fftw, fontconfig, glib, imagemagick, libc++, libcairo, libexif, libexpat, libheif, libimagequant, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openexr, openjpeg, pango, poppler, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Dvapi=true
-Dgsf=disabled
-Dorc=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
