#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

cd ~/
wget https://unimrcp.org/project/release-view/unimrcp-deps-1-6-0-tar-gz/download -O unimrcp-deps-1.6.0.tar.gz
tar xf unimrcp-deps-1.6.0.tar.gz
cd unimrcp-deps-1.6.0
sudo ./build-dep-libs.sh -s

cd ~/src/git/unimrcp
./bootstrap
./configure
make
sudo rm -fr /usr/local/unimrcp # need to remove existing files
sudo make install

echo Success
