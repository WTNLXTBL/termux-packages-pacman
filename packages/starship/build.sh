TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.15.0
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e525476cf93d3a06332abf9e02415d4789fac6f28e4b7d98db7d83da08231828
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--all-features"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake
	: "${CARGO_HOME:=${HOME}/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local p="cmake-0.1.50-src-lib.rs.diff"
	local d
	for d in $CARGO_HOME/registry/src/*/cmake-*; do
		patch --silent -p1 -d ${d} \
			< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
	done

	CFLAGS+=" ${CPPFLAGS}"

	mv "${TERMUX_PREFIX}"/lib/libz.so.1{,.tmp}
	mv "${TERMUX_PREFIX}"/lib/libz.so{,.tmp}

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p "${_CARGO_TARGET_LIBDIR}"

	ln -sfT "$(readlink -f "${TERMUX_PREFIX}"/lib/libz.so.1.tmp)" \
		"${_CARGO_TARGET_LIBDIR}"/libz.so.1
	ln -sfT "$(readlink -f "${TERMUX_PREFIX}"/lib/libz.so.tmp)" \
		"${_CARGO_TARGET_LIBDIR}"/libz.so

	RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	mv "${TERMUX_PREFIX}"/lib/libz.so.1{.tmp,}
	mv "${TERMUX_PREFIX}"/lib/libz.so{.tmp,}

	# Make a placeholder for shell-completions (to be filled with postinst)
	mkdir -p ${TERMUX_PREFIX}/share/bash-completions/completions
	mkdir -p ${TERMUX_PREFIX}/share/fish/vendor_completions.d
	mkdir -p ${TERMUX_PREFIX}/share/zsh/site-functions
	touch ${TERMUX_PREFIX}/share/bash-completions/completions/starship
	touch ${TERMUX_PREFIX}/share/fish/vendor_completions.d/starship.fish
	touch ${TERMUX_PREFIX}/share/zsh/site-functions/_starship
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh

		starship completions bash > ${TERMUX_PREFIX}/share/bash-completions/completions/starship
		starship completions fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/starship.fish
		starship completions zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_starship
	EOF
}
