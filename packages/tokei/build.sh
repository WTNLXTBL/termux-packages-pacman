TERMUX_PKG_HOMEPAGE=https://github.com/XAMPPRocky/tokei
TERMUX_PKG_DESCRIPTION="A blazingly fast CLOC (Count Lines Of Code) program"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.0.0-alpha.0"
TERMUX_PKG_SRCURL=https://github.com/XAMPPRocky/tokei/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5e5e4a538efdc122d89145f139274350f8e92d76adb3e975a45f717817d4fdf7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/tokei \
		"$TERMUX_PREFIX"/bin/tokei
}
