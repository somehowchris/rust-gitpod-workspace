#!/bin/bash
set -e -x shl
set -o pipefail

rustup self update

# setup rust and rust components
install_rustup_channel_with_components() {
    rustup toolchain install $1
    rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis --toolchain $1
}

install_rustup_channel_with_components beta &\
install_rustup_channel_with_components nightly &\
install_rustup_channel_with_components stable &\
rustup target add wasm32-unknown-unknown &\
wait

