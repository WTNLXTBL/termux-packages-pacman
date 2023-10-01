TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="A superset of Lua 5.4, with unique features, optimizations, and improvements"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.3"
TERMUX_PKG_SRCURL=https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf078ad04752baffd859194b57d8c2b473198fbfa2c1dc520db03323d823d335
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PLAT=linux
INSTALL_TOP=$TERMUX_PREFIX
INSTALL_INC=$TERMUX_PREFIX/include/pluto
"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
	export MYCFLAGS="$CXXFLAGS $CPPFLAGS"
	export MYLDFLAGS="$LDFLAGS"
}
