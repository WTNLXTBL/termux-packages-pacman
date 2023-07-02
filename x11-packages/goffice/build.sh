TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/goffice/
TERMUX_PKG_DESCRIPTION="A GLib/GTK+ set of document-centric objects and utilities"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.55
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/goffice/${_MAJOR_VERSION}/goffice-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=16a221191855a6a6c0d06b1ef8e481cf3f52041a654ec96d35817045ba1a99af
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libgsf, librsvg, libspectre, libxml2, libxslt, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--with-lasem=no
--without-long-double
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -D__USE_GNU"
}

termux_step_post_configure() {
	touch ./goffice/g-ir-scanner
}
