TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1.1.28"
TERMUX_PKG_REVISION=1
_VERSION="${TERMUX_PKG_VERSION%.*}-${TERMUX_PKG_VERSION##*.}"
#TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://imagemagick.org/archive/releases/ImageMagick-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=ee4b6cdaaf2fa6020b6a3c6e055d993e970361a2fadf2bf2f984308b35c61915
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, gdk-pixbuf, glib, harfbuzz, imath, libandroid-support, libbz2, libc++, libcairo, libheif, libjpeg-turbo, libjxl, liblzma, libpng, librsvg, libtiff, libwebp, libx11, libxext, libxml2, littlecms, openexr, openjpeg, pango, zlib"
TERMUX_PKG_BREAKS="imagemagick-dev, imagemagick-x"
TERMUX_PKG_REPLACES="imagemagick-dev, imagemagick-x"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-x
--without-gvc
--with-magick-plus-plus=yes
--with-bzlib=yes
--with-xml=yes
--with-rsvg=yes
--with-lzma
--with-jxl=yes
--with-openexr
--with-fftw
--disable-openmp
ac_cv_func_ftime=no
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/ImageMagick-7/francais.xml
"

termux_step_pre_configure() {
	export LDFLAGS+=" $($CC -print-libgcc-file-name)"

	# Value of PKG_CONFIG becomes hardcoded in bin/*-config
	export PKG_CONFIG=pkg-config
}
