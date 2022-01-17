FROM gitpod/workspace-full@sha256:46859378f3067e50e8d9509e270f67a0447bb28f5d2a2f0c723dc916411a46c8

# Use docker buildx
ENV DOCKER_BUILDKIT=1
RUN sudo docker buildx create --use

# Install nightly and components
RUN rustup default nightly
RUN rustup component add clippy rustfmt rust-analysis rust-src

# Install latest stable and components
RUN rustup default stable
RUN rustup component add clippy rls rustfmt rust-analysis rust-src
 
# Install apt packages
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 \
    && sudo add-apt-repository ppa:rmescandon/yq \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg\
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null\
    && sudo apt update \
    && sudo apt-get update && \
    sudo apt-get install -y \
        libssl-dev \
        libxcb-composite0-dev \
        pkg-config \
        libpython3.6 \
        rust-lldb \
        jq yq\
        snapd\
        libmysqlclient-dev default-mysql-client\
        cron\
        gh\
    && sudo rm -rf /var/lib/apt/lists/*

# Env variable for rust debugging
ENV RUST_LLDB=/usr/bin/lldb-11

# Install cargo binaries from source
RUN cargo install \
    cargo-outdated \
    cargo-audit \
    cargo-udeps \
    cargo-geiger \
    cargo-all-features \
    cargo-whatfeatures \
    cargo-spellcheck \
    cargo-binstall \
    cargo-expand \
    cargo-edit\
    flamegraph --force

RUN cargo binstall cargo-watch --no-confirm

# Install diesel cli with additional features
RUN cargo install diesel_cli --features=default,postgres,sqlite,mysql --force