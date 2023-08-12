TERMUX_PKG_HOMEPAGE=https://github.com/shenwei356/rush
TERMUX_PKG_DESCRIPTION="A cross-platform command-line tool for executing jobs in parallel"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="0.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/shenwei356/rush/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f2901313ee279818e6230b432d48b0bb0e1a681ca83740f7e67975ad8b95dd6
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/shenwei356"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/shenwei356/rush"
	cd "${GOPATH}/src/github.com/shenwei356/rush"
	go get -d -v
	go install

	install -Dm700 $TERMUX_PKG_BUILDDIR/bin/*/rush $TERMUX_PREFIX/bin/
}
