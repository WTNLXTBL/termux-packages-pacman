TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Yonle <yonle@lecturify.net>"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=321f7d3f72206b2522f30a1cb8ad1936fd4533ffc4d29dd335b1953c9fb371e6
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsndfile, pulseaudio, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"
