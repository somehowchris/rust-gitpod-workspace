#!/bin/bash
set -e -x shl
set -o pipefail
. /etc/os-release

# network things for rootless podman
sudo curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m)
sudo chmod +x /usr/bin/slirp4netns

if [[ $VERSION_CODENAME == "focal" ]];
then
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
    sudo apt-get install --reinstall ca-certificates
    sudo mkdir /usr/local/share/ca-certificates/cacert.org
    sudo wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt
    sudo update-ca-certificates
fi

# install podman
sudo apt-get update
sudo apt-get upgrade -y
# needs to be installed before podman...
sudo apt-get install -y fuse-overlayfs
sudo apt-get install podman -y

# setting up podman
sudo cp /usr/share/containers/containers.conf /etc/containers/containers.conf
sudo sed -i '/^# cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf
sudo wget -O /etc/containers/storage.conf https://raw.githubusercontent.com/containers/podman/main/vendor/github.com/containers/storage/storage.conf
sudo sed -i '/^driver = "overlay"/ c\driver = "vfs"' /etc/containers/storage.conf
    # && sed -i '/^# events_logger = "journald"/ a events_logger = "file"' /etc/containers/containers.conf \


# docker
sudo apt install kmod -y
echo "export XDG_RUNTIME_DIR=$HOME/.docker/run" | sudo tee -a ~/.bashrc
echo "export PATH=$HOME/bin:$PATH" | sudo tee -a ~/.bashrc
echo "export DOCKER_HOST=unix:///var/run/docker.sock" | sudo tee -a ~/.bashrc

export XDG_RUNTIME_DIR=$HOME/.docker/run
export PATH=$HOME/bin:$PATH
export DOCKER_HOST=unix:///var/run/docker.sock

mkdir -p $XDG_RUNTIME_DIR

sudo echo "$USER:100000:65536" | sudo tee /etc/subuid
sudo echo "$USER:100000:65536" | sudo tee /etc/subgid

export FORCE_ROOTLESS_INSTALL="true"

curl -fsSL https://get.docker.com/rootless | sh

rm -f /etc/subgid
rm -f /etc/subuid

# setup docker buildx
docker buildx create --use
    