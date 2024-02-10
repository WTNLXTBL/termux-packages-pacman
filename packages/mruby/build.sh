TERMUX_PKG_HOMEPAGE=https://mruby.org/
TERMUX_PKG_DESCRIPTION="Lightweight implementation of the Ruby language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_SRCURL=https://github.com/mruby/mruby/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c198e4a31d31fe8524013066fac84a67fe6cd6067d92c25a1c79089744cb608
TERMUX_PKG_DEPENDS="libandroid-complex-math, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_make() {
	export CC_FOR_TARGET="$CC"
	export CFLAGS_FOR_TARGET="$CPPFLAGS $CFLAGS \
		-DMRB_USE_READLINE \
		-DMRB_READLINE_HEADER=\\<readline/readline.h\\> \
		-DMRB_READLINE_HISTORY=\\<readline/history.h\\> \
		"
	export LDFLAGS_FOR_TARGET="$LDFLAGS -lncurses -lreadline"
	LDFLAGS_FOR_TARGET+=" -landroid-complex-math"
	unset CPPFLAGS CFLAGS LDFLAGS
	export CC="$CC_FOR_BUILD"
	export LD="$CC_FOR_BUILD"

	export ANDROID_NDK_HOME="$NDK"
	export MRUBY_CONFIG=android-termux
	rake
}

termux_step_make_install() {
	cd "$TERMUX_PKG_BUILDDIR/build/android-termux"
	for f in bin/*; do
		install -Dm700 -t $TERMUX_PREFIX/bin $f
	done
	for f in lib/*.a; do
		install -Dm600 -t $TERMUX_PREFIX/lib $f
	done
	cp -a "$TERMUX_PKG_SRCDIR/include" $TERMUX_PREFIX/
}
