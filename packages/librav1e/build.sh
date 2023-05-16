TERMUX_PKG_HOMEPAGE=https://github.com/xiph/rav1e/
TERMUX_PKG_DESCRIPTION="An AV1 encoder library focused on speed and safety"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.6"
TERMUX_PKG_SRCURL=https://github.com/xiph/rav1e/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=723696e93acbe03666213fbc559044f3cae5b8b888b2ddae667402403cff51e5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_make_install() {
	termux_setup_rust
	termux_setup_cargo_c

	export CARGO_BUILD_TARGET=$CARGO_TARGET_NAME

	cargo fetch \
		--target $CARGO_TARGET_NAME \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
		--path . \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	# `cargo cinstall` refuses to work with Android
	cargo cbuild \
		--release \
		--prefix $TERMUX_PREFIX \
		--jobs $TERMUX_MAKE_PROCESSES \
		--frozen \
		--target $CARGO_TARGET_NAME \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	cd target/$CARGO_TARGET_NAME/release/
	mkdir -p $TERMUX_PREFIX/include/rav1e/
	cp rav1e.h $TERMUX_PREFIX/include/rav1e/
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig/
	cp rav1e.pc $TERMUX_PREFIX/lib/pkgconfig/
	cp librav1e.a $TERMUX_PREFIX/lib/
	cp librav1e.so $TERMUX_PREFIX/lib/librav1e.so.$TERMUX_PKG_VERSION
	ln -s librav1e.so.$TERMUX_PKG_VERSION \
		$TERMUX_PREFIX/lib/librav1e.so.${TERMUX_PKG_VERSION%%.*}
	ln -s librav1e.so.$TERMUX_PKG_VERSION $TERMUX_PREFIX/lib/librav1e.so
}
