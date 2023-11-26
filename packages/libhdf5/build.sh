TERMUX_PKG_HOMEPAGE=https://portal.hdfgroup.org/display/support
TERMUX_PKG_DESCRIPTION="Hierarchical Data Format 5 (HDF5)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.3"
#TERMUX_PKG_SRCURL=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${TERMUX_PKG_VERSION:0:4}/hdf5-$TERMUX_PKG_VERSION/src/hdf5-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/hdf5-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9425f224ed75d1280bb46d6f26923dd938f9040e7eaebf57e66ec7357c08f917
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="libhdf5-dev"
TERMUX_PKG_REPLACES="libhdf5-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHDF5_BUILD_CPP_LIB=ON
-DHDF5_ENABLE_Z_LIB_SUPPORT=ON
-C$TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/TryRunResults_out.cmake
"

termux_step_post_get_source() {
	local d="hdf5-${TERMUX_PKG_VERSION}"
	if [ -d "${d}" ]; then
		find "${d}" -mindepth 1 -maxdepth 1 -exec mv '{}' ./ \;
		rmdir "${d}"
	fi
}

termux_step_pre_configure () {
	mkdir -p $TERMUX_PKG_BUILDDIR/src/shared/
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/src/
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/src/shared/
	touch $TERMUX_PKG_BUILDDIR/src/gen_SRCS.stamp1 $TERMUX_PKG_BUILDDIR/src/gen_SRCS.stamp2
	touch $TERMUX_PKG_BUILDDIR/src/shared/shared_gen_SRCS.stamp1 $TERMUX_PKG_BUILDDIR/src/shared/shared_gen_SRCS.stamp2
}

termux_step_post_configure () {
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/src/shared/
}
