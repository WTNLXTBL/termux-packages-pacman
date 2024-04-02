TERMUX_PKG_HOMEPAGE=https://nextcloud.com/
TERMUX_PKG_DESCRIPTION="Command-line client tool for Nextcloud."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Zhymabek Roman <robanokssamit@yandex.ru>"
TERMUX_PKG_VERSION=3.12.3
TERMUX_PKG_SRCURL="https://github.com/nextcloud/desktop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9466abfc663dd12bd9fc8e6812fd9c3ef9a685c773a473532294c638c460c00b
TERMUX_PKG_DEPENDS="dbus, dbus-glib, libdbusmenu-qt, qtkeychain, qt5-qtbase, qt5-qttools, inotify-tools, libsqlite, karchive, qt5-qtwebsockets, qt5-qtsvg, qt5-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools, pkg-config, qt5-qmake, qt5-qtbase, qt5-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_GUI=OFF
-DBUILD_SHELL_INTEGRATION=OFF
-DBUILD_UPDATER=OFF
-DTOKEN_AUTH_ONLY=OFF
-DBUILD_TESTING=OFF
"
