#!/bin/bash
set -e -x shl
set -o pipefail
. /etc/os-release

if [[ $VERSION_CODENAME == "focal" ]];
then
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -\
    && sudo apt-get install --reinstall ca-certificates \
    && sudo mkdir /usr/local/share/ca-certificates/cacert.org \
    && sudo wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && sudo update-ca-certificates
fi

# install podman
sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get install podman -y

# setting up podman
sudo cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
    && sudo sed -i '/^# cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf \
    && sudo sed -i '/^driver = "overlay"/ c\driver = "vfs"' /etc/containers/storage.conf
    # && sed -i '/^# events_logger = "journald"/ a events_logger = "file"' /etc/containers/containers.conf \

# docker
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io
# setup docker buildx
docker buildx create --use
    