#!/bin/bash
set -e -x shl
set -o pipefail

# install cargo-binstall
sudo wget https://github.com/ryankurte/cargo-binstall/releases/latest/download/cargo-binstall-$(uname -m)-unknown-linux-musl.tgz -O /usr/local/bin/cargo-binstall.tgz
sudo tar -xf /usr/local/bin/cargo-binstall.tgz -C /usr/local/bin/

cargo install cargo-cache

# TODO use cargo-binstall once its fixed
# install cargo subcommands via cargo-binstall
install_via_cargo_binstall() {
    cargo install $1 --force
    cargo cache --autoclean
    cargo cache --remove-dir all --remove-if-younger-than 01.01.2000
}

install_via_cargo_binstall cargo-watch
install_via_cargo_binstall cargo-outdated
install_via_cargo_binstall cargo-audit
install_via_cargo_binstall cargo-udeps
install_via_cargo_binstall cargo-geiger
install_via_cargo_binstall cargo-all-features
install_via_cargo_binstall cargo-whatfeatures
install_via_cargo_binstall cargo-spellcheck
install_via_cargo_binstall cargo-expand
install_via_cargo_binstall flamegraph
install_via_cargo_binstall cargo-tarpaulin
install_via_cargo_binstall cargo-nextest
install_via_cargo_binstall cargo-benchcmp
install_via_cargo_binstall cargo-tomlfmt
install_via_cargo_binstall cargo-sort
install_via_cargo_binstall cargo-license
install_via_cargo_binstall cargo-modules
install_via_cargo_binstall cargo-profiler
install_via_cargo_binstall cargo-deps
install_via_cargo_binstall cargo-deadlinks
install_via_cargo_binstall cargo-bloat
install_via_cargo_binstall cargo-linked
install_via_cargo_binstall cargo-grammarly
install_via_cargo_binstall trunk
install_via_cargo_binstall wasm-bindgen-cli
install_via_cargo_binstall minifier

sudo wget -O /usr/local/bin/minify https://wilsonl.in/minify-html/bin/0.8.0-linux-x86_64
sudo chmod +x /usr/local/bin/minify

# cargo binstall does not use features
cargo install diesel_cli --features=default,postgres,sqlite,mysql --force