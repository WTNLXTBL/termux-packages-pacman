TERMUX_PKG_HOMEPAGE=https://www.cairographics.org/pycairo/
TERMUX_PKG_DESCRIPTION="Python bindings for the cairo graphics library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.0
TERMUX_PKG_SRCURL=https://github.com/pygobject/pycairo/releases/download/v${TERMUX_PKG_VERSION}/pycairo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1444d52f1bb4cc79a4a0c0fe2ccec4bd78ff885ab01ebe1c0f637d8392bcafb6
TERMUX_PKG_DEPENDS="libcairo, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
