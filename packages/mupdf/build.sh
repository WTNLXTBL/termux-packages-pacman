TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=54c66af4e6ef8cea9867cc0320ef925d561b42919ea0d4f89db5c9ef485bbeb7
TERMUX_PKG_DEPENDS="freetype, gumbo-parser, harfbuzz, jbig2dec, leptonica, libc++, libjpeg-turbo, openjpeg, tesseract, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX build=release libs shared=yes tesseract=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	mv pyproject.toml{,.unused}
	mv setup.py{,.unused}
}

termux_step_pre_configure() {
	rm -rf thirdparty/{freeglut,freetype,harfbuzz,jbig2dec,leptonica,libjpeg,openjpeg,tesseract,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	TERMUX_PKG_EXTRA_MAKE_ARGS="${TERMUX_PKG_EXTRA_MAKE_ARGS/shared=yes/}"
	termux_step_make
	install -Dm600 -t $TERMUX_PREFIX/lib build/release*/libmupdf{-third,}.a
}
