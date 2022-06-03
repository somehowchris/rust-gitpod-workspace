set -e 
set -o pipefail

# setup rust and rust components
install_rustup_channel_with_components() {
    rustup default $1
    rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis --target $1
}

install_rustup_channel_with_components beta &\
install_rustup_channel_with_components nightly &\
install_rustup_channel_with_components stable &\
wait