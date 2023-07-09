TERMUX_PKG_HOMEPAGE=https://numpy.org/
TERMUX_PKG_DESCRIPTION="The fundamental package for scientific computing with Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.25.1"
TERMUX_PKG_SRCURL=git+https://github.com/numpy/numpy
TERMUX_PKG_DEPENDS="libc++, libopenblas, python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, pybind11, Cython, pythran"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

termux_step_post_get_source() {
	# numpy has switched to use meson-python by default, 
	# but meson-python hasn't supported cross compiling.
	# See mesonbuild/meson-python#321
	rm -f meson.build
}

termux_step_pre_configure() {
	export MATHLIB="m"

	LDFLAGS+=" -lm"
}
