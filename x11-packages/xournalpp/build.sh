TERMUX_PKG_HOMEPAGE=https://github.com/xournalpp/xournalpp
TERMUX_PKG_DESCRIPTION="A hand note taking software"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=https://github.com/xournalpp/xournalpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b873ea4e2beadc3061fab87faef31c374ae7876c88dbda5565c491945cf7290f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libandroid-execinfo, libc++, libcairo, librsvg, libsndfile, libx11, libxi, libxml2, libzip, pango, poppler, portaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHELP2MAN=NO
"
