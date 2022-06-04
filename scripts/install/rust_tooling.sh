#!/bin/bash
set -e -x shl
set -o pipefail

rustup self update

# setup rust and rust components
install_rustup_channel_with_components() {
    rustup toolchain install $1
    rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis --toolchain $1
}

install_rustup_channel_with_components beta-musl &\
install_rustup_channel_with_components nightly-musl &\
install_rustup_channel_with_components stable-musl &\
install_rustup_channel_with_components beta-gnu &\
install_rustup_channel_with_components nightly-gnu &\
install_rustup_channel_with_components stable-gnu &\
wait

rustup target add wasm32-unknown-unknown