set -e 
set -o pipefail

# network things for thailscale etc.
sudo curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m)
sudo chmod +x /usr/bin/slirp4netns

. /etc/os-release \
    && echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add - \
    && sudo apt-get install --reinstall ca-certificates \
    && sudo mkdir /usr/local/share/ca-certificates/cacert.org \
    && sudo wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && sudo update-ca-certificates

# setup rust and rust components
install_rustup_channel_with_components() {
    rustup default $1
    rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis --target $1
}

install_rustup_channel_with_components beta &\
install_rustup_channel_with_components nightly &\
install_rustup_channel_with_components stable &\
wait

# install cargo-binstall
sudo wget https://github.com/ryankurte/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-gnu.tgz -O /usr/local/bin/cargo-binstall.tgz
sudo tar -xf /usr/local/bin/cargo-binstall.tgz -C /usr/local/bin/

# install cargo subcommands via cargo-binstall
install_via_cargo_binstall() {
    cargo binstall $1 --no-confirm
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
&wait

# install apt packages
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 \
    && sudo add-apt-repository ppa:rmescandon/yq \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg\
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null\
    && sudo apt update \
    && sudo apt upgrade -y && \
    sudo apt-get install -y \
        libssl-dev \
        libxcb-composite0-dev \
        pkg-config \
        libpython3.6 \
        jq yq\
        snapd\
        libmysqlclient-dev default-mysql-client\
        cron\
        gh\
        valgrind\
        podman\
        software-properties-common\
    && sudo rm -rf /var/lib/apt/lists/*

# setting up podman
sudo cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
    && sudo sed -i '/^# cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf \
    # && sed -i '/^# events_logger = "journald"/ a events_logger = "file"' /etc/containers/containers.conf \
    && sudo sed -i '/^driver = "overlay"/ c\driver = "vfs"' /etc/containers/storage.conf

cd /usr/local && curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
