TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/gdbm/
TERMUX_PKG_DESCRIPTION="Library of database functions that use extensible hashing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gdbm/gdbm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f366c823a6724af313b6bbe975b2809f9a157e5f6a43612a72949138d161d762
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BREAKS="gdbm-dev"
TERMUX_PKG_REPLACES="gdbm-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-libgdbm-compat"

