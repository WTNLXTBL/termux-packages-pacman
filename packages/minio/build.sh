TERMUX_PKG_HOMEPAGE=https://min.io/
TERMUX_PKG_DESCRIPTION="Multi-Cloud Object Storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2024.01.18.22.51.28"
_VERSION=$(sed 's/\./T/3;s/\./-/g' <<< $TERMUX_PKG_VERSION)
TERMUX_PKG_SRCURL=https://github.com/minio/minio/archive/refs/tags/RELEASE.${_VERSION}Z.tar.gz
TERMUX_PKG_SHA256=267c949e03f6d931f3b2da07c067f02483cb2b2604b627e1eb9b96acb0fd9192
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/T/-/g;s/[^0-9-]//g;s/-/./g'
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	local _COMMITID=$(git ls-remote https://github.com/minio/minio refs/tags/RELEASE.${_VERSION}Z | cut -f1)
	local _SHORTCOMMITID=$(git ls-remote https://github.com/minio/minio refs/tags/RELEASE.${_VERSION}Z | head -c 12)

	MINIOLDFLAGS="\
	-w -s \
	-X 'github.com/minio/minio/cmd.Version=${_VERSION}Z' \
	-X 'github.com/minio/minio/cmd.CopyrightYear=$(date +%Y)' \
	-X 'github.com/minio/minio/cmd.ReleaseTag=RELEASE.${_VERSION}Z'\
	-X 'github.com/minio/minio/cmd.CommitID=${_COMMITID}' \
	-X 'github.com/minio/minio/cmd.ShortCommitID=${_SHORTCOMMITID}' \
	-X 'github.com/minio/minio/cmd.GOPATH=$(go env GOPATH)' \
	-X 'github.com/minio/minio/cmd.GOROOT=$(go env GOROOT)' \
	"
	CGO_ENABLED=0 go build -tags kqueue -trimpath --ldflags="$MINIOLDFLAGS" -o minio
}
termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin minio
}
