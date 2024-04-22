TERMUX_PKG_HOMEPAGE=https://github.com/hetznercloud/cli
TERMUX_PKG_DESCRIPTION="Hetzner Cloud command line client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.43.1"
TERMUX_PKG_SRCURL=https://github.com/hetznercloud/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5bd9e55b7c0877ec51cd1f3d873d5c1f7447cad8cb76dcaba1f3c5186e7f02bc
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	# Below are taken from github.com/hetznercloud/cli@v1.30.1/.goreleaser.yml
	local LD_FLAGS="-s -w -X 'github.com/hetznercloud/cli/internal/version.Version=v${TERMUX_PKG_VERSION}'"
	go build -ldflags "${LD_FLAGS}" -o hcloud  cmd/hcloud/main.go 
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin hcloud
}
