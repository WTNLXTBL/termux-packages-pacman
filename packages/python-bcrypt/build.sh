TERMUX_PKG_HOMEPAGE=https://github.com/pyca/bcrypt
TERMUX_PKG_DESCRIPTION="Acceptable password hashing for your software and your servers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1.1"
TERMUX_PKG_SRCURL=https://pypi.io/packages/source/b/bcrypt/bcrypt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df37f5418d4f1cdcff845f60e747a015389fa4e63703c918330865e06ad80007
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools-rust"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_configure() {
	export CARGO_BUILD_TARGET=${CARGO_TARGET_NAME}
	export PYO3_CROSS_LIB_DIR=$TERMUX_PREFIX/lib
}
