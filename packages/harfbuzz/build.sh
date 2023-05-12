TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.3.0
TERMUX_PKG_SRCURL=https://github.com/harfbuzz/harfbuzz/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cefc6cc161e9d5c88210dafc43bc733ca3e383fd3dd4f1e6178f81bd41cfaae
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="freetype, glib, libcairo, libgraphite"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="harfbuzz-dev"
TERMUX_PKG_REPLACES="harfbuzz-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgobject=enabled
-Dgraphite=enabled
-Dintrospection=enabled
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/gtk-doc
"

termux_step_post_get_source() {
	mv CMakeLists.txt CMakeLists.txt.unused
}

termux_step_pre_configure() {
	termux_setup_gir
}
