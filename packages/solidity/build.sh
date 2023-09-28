TERMUX_PKG_HOMEPAGE=https://solidity.readthedocs.io
TERMUX_PKG_DESCRIPTION="An Ethereum smart contract-oriented language"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.21"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ethereum/solidity/releases/download/v${TERMUX_PKG_VERSION}/solidity_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d1bb8e72850320e72d788575f6bd25dd4930cb6dd9edd35a59266a46f610d13
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, jsoncpp, libc++"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_Z3=OFF
-DUSE_CVC4=OFF
-DUSE_LD_GOLD=OFF
-DBoost_USE_STATIC_LIBS=OFF
"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	LDFLAGS+=" -ljsoncpp"
}
