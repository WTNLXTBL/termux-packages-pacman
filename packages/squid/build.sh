TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION="Full-featured Web proxy cache server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=5
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://squid.mirror.globo.tech/archive/${_MAJOR_VERSION}/squid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3fe5c2007da2757446af91b6ef974f154b208120a9a39396ea681e5c4abb04b5
TERMUX_PKG_DEPENDS="libc++, libcrypt, libexpat, libgnutls, libltdl, libnettle, libxml2, openldap, resolv-conf"

#disk-io uses XSI message queue which are not available on Android.
# Option 'cache_dir' will be unusable.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_memrchr=yes
ac_cv_func_strtoll=yes
ac_cv_search_shm_open=
ac_cv_lib_sasl2_sasl_errstring=no
ac_cv_dbopen_libdb=no
squid_cv_gnu_atomics=yes
--datarootdir=$TERMUX_PREFIX/share/squid
--libexecdir=$TERMUX_PREFIX/libexec/squid
--mandir=$TERMUX_PREFIX/share/man
--sysconfdir=$TERMUX_PREFIX/etc/squid
--with-logdir=$TERMUX_PREFIX/var/log/squid
--with-pidfile=$TERMUX_PREFIX/var/run/squid.pid
--disable-external-acl-helpers
--disable-strict-error-checking
--enable-auth
--enable-auth-basic
--enable-auth-digest
--enable-auth-negotiate
--enable-auth-ntlm
--enable-delay-pools
--enable-linux-netfilter
--enable-removal-policies="lru,heap"
--enable-snmp
--disable-disk-io
--disable-storeio
--enable-translation
--with-dl
--without-openssl
--disable-ssl-crtd
--with-size-optimizations
--with-gnutls
--with-libnettle
--without-mit-krb5
--with-maxfd=256
"

termux_step_pre_configure() {
	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
}

termux_step_post_massage() {
	# Ensure that necessary directories exist, otherwise squid fill fail.
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/cache/squid"
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/log/squid"
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run"
}
