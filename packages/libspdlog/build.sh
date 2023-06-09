TERMUX_PKG_HOMEPAGE=https://github.com/gabime/spdlog
TERMUX_PKG_DESCRIPTION="Very fast, header-only/compiled, C++ logging library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.0
TERMUX_PKG_SRCURL=https://github.com/gabime/spdlog/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="fmt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPDLOG_BUILD_SHARED=ON
-DSPDLOG_FMT_EXTERNAL=ON
"
