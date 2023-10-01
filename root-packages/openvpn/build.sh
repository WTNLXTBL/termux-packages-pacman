TERMUX_PKG_HOMEPAGE=https://openvpn.net
TERMUX_PKG_DESCRIPTION="An easy-to-use, robust, and highly configurable VPN (Virtual Private Network)"
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.6"
TERMUX_PKG_SRCURL=https://github.com/OpenVPN/openvpn/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81415358b89660c9da98d9cf26fd4942fa806fa8f653529fa100a3090c8a3951
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcap-ng, liblz4, liblzo, net-tools, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-plugin-auth-pam
--disable-systemd
--disable-debug
--enable-iproute2
--enable-small
--enable-x509-alt-username
ac_cv_func_getpwnam=yes
IFCONFIG=$TERMUX_PREFIX/bin/ifconfig
ROUTE=$TERMUX_PREFIX/bin/route
IPROUTE=$TERMUX_PREFIX/bin/ip
NETSTAT=$TERMUX_PREFIX/bin/netstat
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	# Examples.
	install -d -m700 "$TERMUX_PREFIX/share/openvpn/examples"
	cp "$TERMUX_PKG_SRCDIR"/sample/sample-config-files/* "$TERMUX_PREFIX/share/openvpn/examples"
}
