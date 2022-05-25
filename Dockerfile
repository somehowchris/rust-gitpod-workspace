FROM gitpod/workspace-full@sha256:dc1dfc3870ca1f668c927389396bfe81fcec5a8ecf0eea2276c901856323b144

# Install podman

## Needed for the experimental network mode (to support Tailscale)
RUN sudo curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && sudo chmod +x /usr/bin/slirp4netns

RUN . /etc/os-release \
    && echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add - \
    && sudo apt-get install --reinstall ca-certificates \
    && sudo mkdir /usr/local/share/ca-certificates/cacert.org \
    && sudo wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && sudo update-ca-certificates

# Install user environment
CMD /bin/bash -l

# Install beta and components
RUN rustup default beta
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis


# Install nightly and components
RUN rustup default nightly
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis


# Install latest stable and components
RUN rustup default stable
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis

# Install cargo binstall
ADD https://github.com/ryankurte/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-gnu.tgz /usr/local/bin/cargo-binstall.tgz
RUN sudo tar -xf /usr/local/bin/cargo-binstall.tgz -C /usr/local/bin/

ARG BINSTALL="cargo binstall"
ARG BINSTALL_FLAGS="--no-confirm"

RUN ${BINSTALL} cargo-watch ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-outdated ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-audit ${BINSTALL_FLAGS} \
    && ${BINSTALL} cargo-udeps ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-geiger ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-all-features ${BINSTALL_FLAGS} \
    && ${BINSTALL} cargo-whatfeatures ${BINSTALL_FLAGS} \
    && ${BINSTALL} cargo-spellcheck ${BINSTALL_FLAGS} \
    && ${BINSTALL} cargo-expand ${BINSTALL_FLAGS} \
    && ${BINSTALL} flamegraph ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-tarpaulin ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-nextest ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-benchcmp ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-tomlfmt ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-sort ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-license ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-modules ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-profiler ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-deps ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-deadlinks ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-bloat ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-linked ${BINSTALL_FLAGS}\
    && ${BINSTALL} cargo-grammarly ${BINSTALL_FLAGS}

# Install apt packages
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 \
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
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
    && sudo sed -i '/^# cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf \
    # && sed -i '/^# events_logger = "journald"/ a events_logger = "file"' /etc/containers/containers.conf \
    && sudo sed -i '/^driver = "overlay"/ c\driver = "vfs"' /etc/containers/storage.conf

# Install diesel cli with additional features
RUN cargo install diesel_cli --features=default,postgres,sqlite,mysql --force

