TERMUX_PKG_HOMEPAGE=https://github.com/golang/tools
TERMUX_PKG_DESCRIPTION="The official Go language server"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@SunPodder"
TERMUX_PKG_VERSION="0.15.2"
TERMUX_PKG_SRCURL=https://github.com/golang/tools/archive/refs/tags/gopls/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf5b8246b36967eb8fbbed518ea941110cc6bbcc7f42a44bc5a4fe0d7ee61652
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	# Get the newest tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	# check if this is not a release:
	if grep -qP "^gopls/v${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a release($tag)"
	fi
}

termux_step_make() {
	termux_setup_golang

	cd $TERMUX_PKG_SRCDIR/gopls
	go build -o gopls
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/gopls/gopls
}

