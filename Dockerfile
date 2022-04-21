FROM gitpod/workspace-full@sha256:e249a43d75e6852086a32e6e91745395fef5c7f818529ac72f4201be7b29c448

# Use docker buildx
ENV DOCKER_BUILDKIT=1
RUN sudo docker buildx create --use

# Install nightly and components
RUN rustup default nightly
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis


# Install beta and components
RUN rustup default beta
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis

# Install latest stable and components
RUN rustup default stable
RUN rustup component add rustfmt rust-std rust-docs clippy cargo rust-src rust-analysis
 
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
        jq yq\
        snapd\
        libmysqlclient-dev default-mysql-client\
        cron\
        gh\
        valgrind\
    && sudo rm -rf /var/lib/apt/lists/*

# Install cargo binstall
ADD https://github.com/ryankurte/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-gnu.tgz /usr/local/bin/cargo-binstall.tgz
RUN sudo tar -xf /usr/local/bin/cargo-binstall.tgz -C /usr/local/bin/

ARG BINSTALL="cargo binstall"
ARG BINSTALL_FLAGS="--no-confirm"

RUN ${BINSTALL} cargo-watch ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-outdated ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-audit ${BINSTALL_FLAGS} \
    & ${BINSTALL} cargo-udeps ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-geiger ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-all-features ${BINSTALL_FLAGS} \
    & ${BINSTALL} cargo-whatfeatures ${BINSTALL_FLAGS} \
    & ${BINSTALL} cargo-spellcheck ${BINSTALL_FLAGS} \
    & ${BINSTALL} cargo-expand ${BINSTALL_FLAGS} \
    & ${BINSTALL} flamegraph ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-tarpaulin ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-nextest ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-benchcmp ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-tomlfmt ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-sort ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-license ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-modules ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-profiler ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-deps ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-deadlinks ${BINSTALL_FLAGS}\
    & ${BINSTALL} cargo-bloat ${BINSTALL_FLAGS}\
    & wait

# Install cargo binaries which are not available via cargo-binstall
RUN cargo install cargo-linked cargo-grammarly

# Install diesel cli with additional features
RUN cargo install diesel_cli --features=default,postgres,sqlite,mysql --force