set -e 
set -o pipefail

# network things for thailscale etc.
sudo curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m)
sudo chmod +x /usr/bin/slirp4netns