TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Qt 5 addon providing access to numerous types of archives (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.71.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/karchive-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=cc81e856365dec2bcf3ec78aa01d42347ca390a2311ea12050f309dfbdb09624
TERMUX_PKG_DEPENDS="qt5-qtbase, zlib, liblzma, libbz2"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt5-qtbase-cross-tools"

