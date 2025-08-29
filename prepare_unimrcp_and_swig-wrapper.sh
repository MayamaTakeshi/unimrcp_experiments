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

cd ~/src/git/swig-wrapper
rm -f CMakeCache.txt
cmake -D APR_LIBRARY=/usr/local/apr/lib/libapr-1.so -D APR_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D APU_LIBRARY=/usr/local/apr/lib/libaprutil-1.so -D APU_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D UNIMRCP_SOURCE_DIR=~/src/unimrcp -D SOFIA_INCLUDE_DIRS=/usr/include/sofia-sip-1.12 -D WRAP_CPP=OFF -D WRAP_JAVA=OFF -D BUILD_C_EXAMPLE=OFF .
make

sudo /sbin/ldconfig

echo Success
