FROM gitpod/workspace-full:commit-f2d623ca9d270c2ce8560d2ca0f9ce71b105aff2

SHELL ["/bin/bash", "-c"]

RUN set -x shl
ENV DOCKER_BUILDKIT=1
RUN mkdir -p /home/gitpod/.docker/cli-plugins
RUN wget https://github.com/docker/buildx/releases/download/v0.6.1/buildx-v0.6.1.linux-amd64 -O /home/gitpod/.docker/cli-plugins/docker-buildx
RUN chmod a+x /home/gitpod/.docker/cli-plugins/docker-buildx
RUN docker buildx create --use

RUN source /etc/os-release && sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
RUN source /etc/os-release && sudo wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -

RUN sudo apt-get update
RUN sudo apt-get install podman -y

RUN podman --version

RUN rustup default nightly
RUN rustup default stable

RUN rustup component add clippy rls rustfmt rust-analysis
RUN cargo install cargo-watch cargo-outdated cargo-audit diesel_cli cargo-binstall cargo-geiger cargo-all-features cargo-whatfeatures cargo-spellcheck cargo-udeps flamegraph
