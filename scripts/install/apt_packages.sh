#!/bin/bash
set -e -x shl
set -o pipefail

# install apt packages
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq\
    && sudo chmod +x /usr/bin/yq \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg\
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null\
    && sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get install -y \
        libssl-dev \
        libxcb-composite0-dev \
        pkg-config \
        libpython3.6 \
        jq\
        snapd\
        default-mysql-client\
        cron\
        gh\
        valgrind\
        build-essential\
        apt-utils\
        libclang-dev\
    && sudo rm -rf /var/lib/apt/lists/*
