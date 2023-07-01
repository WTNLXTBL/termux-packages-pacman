TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.13.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/freetype/freetype-${TERMUX_PKG_VERSION}.tar.xz
#TERMUX_PKG_SRCURL=https://download.savannah.nongnu.org/releases/freetype/freetype-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ea67e3b019b1104d1667aa274f5dc307d8cbd606b399bc32df308a77f1a564bf
TERMUX_PKG_DEPENDS="brotli, libbz2, libpng, zlib"
TERMUX_PKG_BREAKS="freetype-dev"
TERMUX_PKG_REPLACES="freetype-dev"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
# not install these files anymore so install them manually.
termux_step_post_make_install() {
	install -Dm700 freetype-config $TERMUX_PREFIX/bin/freetype-config
	install -Dm600 ../src/docs/freetype-config.1 $TERMUX_PREFIX/share/man/man1/freetype-config.1
}

