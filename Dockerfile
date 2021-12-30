FROM gitpod/workspace-full:commit-f2d623ca9d270c2ce8560d2ca0f9ce71b105aff2

SHELL ["/bin/bash", "-c"]

RUN set -x shl
ENV DOCKER_BUILDKIT=1
RUN mkdir -p /home/gitpod/.docker/cli-plugins
ADD https://github.com/docker/buildx/releases/download/v0.6.1/buildx-v0.6.1.linux-amd64 /home/gitpod/.docker/cli-plugins/docker-buildx
RUN sudo chmod a+x /home/gitpod/.docker/cli-plugins/docker-buildx
RUN sudo docker buildx create --use

RUN rustup default nightly
RUN rustup default stable

RUN rustup component add clippy rls rustfmt rust-analysis
#RUN cargo install cargo-watch cargo-outdated cargo-audit diesel_cli cargo-binstall cargo-geiger cargo-all-features cargo-whatfeatures cargo-spellcheck cargo-udeps flamegraph --force

RUN sudo apt-get update && \
    sudo apt-get install -y \
        libssl-dev \
        libxcb-composite0-dev \
        pkg-config \
        libpython3.6 \
        rust-lldb \
    && sudo rm -rf /var/lib/apt/lists/*

ENV RUST_LLDB=/usr/bin/lldb-11

USER root

RUN apt update && apt install -y slirp4netns fuse-overlayfs

RUN . /etc/os-release \
    && sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list" \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | apt-key add - \
    && apt-get install --reinstall ca-certificates \
    && mkdir /usr/local/share/ca-certificates/cacert.org \
    && wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && update-ca-certificates \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install podman buildah

RUN cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
    && sed -i '/^#cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf \
    && sed -i '/^driver = "vfs"/ c\driver = "overlay"' /etc/containers/storage.conf\
    && sed -i '/^#mount_program = "\/usr\/bin\/fuse-overlayfs"/ a mount_program = "\/usr\/bin\/fuse-overlayfs"' /etc/containers/storage.conf

USER gitpod
