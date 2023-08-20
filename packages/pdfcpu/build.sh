TERMUX_PKG_HOMEPAGE="https://pdfcpu.io"
TERMUX_PKG_DESCRIPTION="A PDF processor written in Go"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL="https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d67529db954b4b8fd708ac984cf79a53baf57ab2d50ef9ee0f9188f7e4a83127
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	cd "${TERMUX_PKG_SRCDIR}/cmd/pdfcpu"
	go build
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_SRCDIR}/cmd/pdfcpu/pdfcpu" \
		"$TERMUX_PREFIX/bin/"
}
