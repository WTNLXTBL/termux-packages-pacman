TERMUX_PKG_HOMEPAGE=https://github.com/rust-analyzer/rust-analyzer
TERMUX_PKG_DESCRIPTION="A Rust compiler front-end for IDEs"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=2023-06-19
TERMUX_PKG_VERSION=${_VERSION//-/}
TERMUX_PKG_SRCURL=https://github.com/rust-analyzer/rust-analyzer/archive/refs/tags/${_VERSION}.tar.gz
TERMUX_PKG_SHA256=3365b6a8de1929a73af198520f3169f146ab882b47b41146045ea8217fcdcd61
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rust-analyzer
}
