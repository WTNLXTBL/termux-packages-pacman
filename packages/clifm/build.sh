TERMUX_PKG_HOMEPAGE=https://github.com/leo-arch/clifm
TERMUX_PKG_DESCRIPTION="The shell-like, command line terminal file manager: simple, fast, extensible, and lightweight as hell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11"
TERMUX_PKG_SRCURL=https://github.com/leo-arch/clifm/releases/download/v${TERMUX_PKG_VERSION}/clifm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32f69ab2215bfcf10e8fe3920c5b4ffd6e699a68463577b32c39f9189d5a9c56
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false
TERMUX_PKG_DEPENDS="libcap, libacl, readline, file, libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-f misc/termux/Makefile"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
