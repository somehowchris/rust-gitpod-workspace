#!/bin/bash
set -e -x shl
set -o pipefail

# install cargo-binstall
sudo wget https://github.com/ryankurte/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-gnu.tgz -O /usr/local/bin/cargo-binstall.tgz
sudo tar -xf /usr/local/bin/cargo-binstall.tgz -C /usr/local/bin/

# install cargo subcommands via cargo-binstall
install_via_cargo_binstall() {
    cargo-binstall $1 --no-confirm
}

install_via_cargo_binstall cargo-watch &\
install_via_cargo_binstall cargo-outdated &\
install_via_cargo_binstall cargo-audit &\
install_via_cargo_binstall cargo-udeps &\
install_via_cargo_binstall cargo-geiger &\
install_via_cargo_binstall cargo-all-features &\
install_via_cargo_binstall cargo-whatfeatures &\
install_via_cargo_binstall cargo-spellcheck &\
install_via_cargo_binstall cargo-expand &\
install_via_cargo_binstall flamegraph &\
install_via_cargo_binstall cargo-tarpaulin &\
install_via_cargo_binstall cargo-nextest &\
install_via_cargo_binstall cargo-benchcmp &\
install_via_cargo_binstall cargo-tomlfmt &\
install_via_cargo_binstall cargo-sort &\
install_via_cargo_binstall cargo-license &\
install_via_cargo_binstall cargo-modules &\
install_via_cargo_binstall cargo-profiler &\
install_via_cargo_binstall cargo-deps &\
install_via_cargo_binstall cargo-deadlinks &\
install_via_cargo_binstall cargo-bloat &\
install_via_cargo_binstall cargo-linked &\
install_via_cargo_binstall cargo-grammarly &\
# cargo binstall does not use features
cargo install diesel_cli --features=default,postgres,sqlite,mysql --force &\
& wait