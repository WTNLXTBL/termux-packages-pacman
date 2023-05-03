TERMUX_PKG_HOMEPAGE=https://mate-session-manager.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-session contains the MATE session manager, as well as a configuration program to choose applications starting on login."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-session-manager/releases/download/v$TERMUX_PKG_VERSION/mate-session-manager-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5915a2f6583c0e5e58afb3abae3f4adbbe6a003c174a5b6e3d204b4e398a1816
TERMUX_PKG_DEPENDS="dbus, dbus-glib, gdk-pixbuf, glib, gtk3, libcairo, libepoxy, libice, libsm, libx11, libxau, libxcomposite, libxext, libxrender, libxtst, opengl"
