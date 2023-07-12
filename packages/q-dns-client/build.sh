TERMUX_PKG_HOMEPAGE=https://github.com/natesales/q
TERMUX_PKG_DESCRIPTION="A tiny command line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="0.11.4"
TERMUX_PKG_SRCURL="git+https://github.com/natesales/q"
TERMUX_PKG_SHA256=6e61155a66311164d7c4300fabfcda4cb69a5fe9c846ca106503ed8e7828133d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]] ; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_make() {
	termux_setup_golang

	local _builtAt=$(date +'%FT%T%Z')

	local ldflags="\
	-w -s \
	-X 'main.version=${TERMUX_PKG_VERSION}' \
	-X 'main.commit=$(git log -1 --format=%H)' \
	-X 'main.date=${_builtAt}' \
	"

	export CGO_ENABLED=1

	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags"
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin/q
}
