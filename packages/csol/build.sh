TERMUX_PKG_HOMEPAGE=https://github.com/nielssp/csol
TERMUX_PKG_DESCRIPTION="A small collection of solitaire games implemented in C using ncurses"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/nielssp/csol/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f14ad0756cf7d3ae63fd73e28ae6be7a9f8047380dc4300ff44388aefcfef4f4
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_BUILD_IN_SRC=true

