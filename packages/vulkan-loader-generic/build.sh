TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Loader
TERMUX_PKG_DESCRIPTION="Vulkan Loader"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.249"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Loader/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dad9cda73559b277e9b188f5222bedcbf39b35a201d23a2c35dba25953511311
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers (=${TERMUX_PKG_VERSION}), libx11, libxcb, libxrandr"
TERMUX_PKG_CONFLICTS="vulkan-loader-android"
TERMUX_PKG_PROVIDES="vulkan-loader-android"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DVULKAN_HEADERS_INSTALL_DIR=$TERMUX_PREFIX
-DBUILD_TESTS=OFF
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	CPPFLAGS+=" -Wno-typedef-redefinition"
}

termux_step_post_make_install() {
	# Sanity check
	echo "INFO: ========== vulkan.pc =========="
	cat "$TERMUX_PREFIX/lib/pkgconfig/vulkan.pc"
	echo "INFO: ========== vulkan.pc =========="

	# Lots of apps will search libvulkan.so.1
	if [ ! -e $TERMUX_PREFIX/lib/libvulkan.so.1 ]; then
		ln -sfr $TERMUX_PREFIX/lib/libvulkan.so{,.1}
	fi
}
