#!/bin/bash
set -e -x shl
set -o pipefail

cd /usr/local && curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
