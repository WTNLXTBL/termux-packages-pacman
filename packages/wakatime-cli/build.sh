TERMUX_PKG_HOMEPAGE=https://wakatime.com/plugins/
TERMUX_PKG_DESCRIPTION="Command line interface used by all WakaTime text editor plugins"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.86.2"
TERMUX_PKG_SRCURL=https://github.com/wakatime/wakatime-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72317f86097fd0c43b09a1cdda2016f95091b941d64f5ad1f5018c1f3c5c21c0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
        rm -f Makefile
        termux_setup_golang

        local _REPO=github.com/wakatime/wakatime-cli
        local _COMMIT=$(git ls-remote https://github.com/wakatime/wakatime-cli refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
        local _DATE=$(date -u '+%Y-%m-%dT%H:%M:%S %Z')
        CGO_ENABLED=0 go build -o wakatime-cli -ldflags="-s -w -X '${_REPO}/pkg/version.BuildDate=${_DATE}' -X '${_REPO}/pkg/version.Commit=${_COMMIT}' -X '${_REPO}/pkg/version.Version=${TERMUX_PKG_VERSION}' -X '${_REPO}/pkg/version.OS=android' -X '${_REPO}/pkg/version.Arch=$(go env GOARCH)'" 
}

termux_step_make_install() {
        install -Dm755 -t "${TERMUX_PREFIX}"/bin ${TERMUX_PKG_SRCDIR}/wakatime-cli
}
