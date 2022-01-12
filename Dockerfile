FROM gitpod/workspace-full@sha256:46859378f3067e50e8d9509e270f67a0447bb28f5d2a2f0c723dc916411a46c8

SHELL ["/bin/bash", "-c"]

ENV DOCKER_BUILDKIT=1
RUN mkdir -p /home/gitpod/.docker/cli-plugins
ADD https://github.com/docker/buildx/releases/download/v0.6.1/buildx-v0.6.1.linux-amd64 /home/gitpod/.docker/cli-plugins/docker-buildx
RUN sudo chmod a+x /home/gitpod/.docker/cli-plugins/docker-buildx
RUN sudo docker buildx create --use

RUN rustup default nightly
RUN rustup default stable

RUN rustup component add clippy rls rustfmt rust-analysis rust-src
 
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

ENV RUST_LLDB=/usr/bin/lldb-11

RUN cargo install \
    cargo-watch \
    cargo-outdated \
    cargo-audit \
    cargo-binstall \
    cargo-geiger \
    cargo-all-features \
    cargo-whatfeatures \
    cargo-spellcheck \
    cargo-udeps \
    cargo-outdated\
    cargo-whatfeatures\
    cargo-edit\
    flamegraph --force
RUN cargo install diesel_cli --features=default,postgres,sqlite,mysql --force