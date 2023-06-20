TERMUX_PKG_HOMEPAGE=https://www.mono-project.com/
TERMUX_PKG_DESCRIPTION="Cross platform, open source .NET framework"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.12.0.182
TERMUX_PKG_SRCURL=https://download.mono-project.com/sources/mono/mono-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=57366a6ab4f3b5ecf111d48548031615b3a100db87c679fc006e8c8a4efd9424
TERMUX_PKG_DEPENDS="krb5, mono-libs, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-btls
--without-ikvm-native
"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	rm -f external/bdwgc/config.status
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	$TERMUX_PKG_SRCDIR/configure --prefix=$_PREFIX_FOR_BUILD \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "arm" ]; then
		CFLAGS="${CFLAGS//-mthumb/}"
	fi
	LDFLAGS+=" -lgssapi_krb5"
}

termux_step_post_make_install() {
	pushd $TERMUX_PKG_HOSTBUILD_DIR/prefix/lib/mono
	find . -name '*.so' -exec rm -f \{\} \;
	rm -f ./4.5/mono-shlib-cop.exe.config
	cp -rT . $TERMUX_PREFIX/lib/mono
	popd

	# Strip off SOVERSION suffix for shared libraries.
	sed -i -E 's/\.so\.[0-9]+/.so/g' $TERMUX_PREFIX/etc/mono/config
}
