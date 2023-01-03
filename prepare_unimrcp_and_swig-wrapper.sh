#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

cd ~/src/unimrcp
./bootstrap
./configure
make
sudo make install

cd ~/src/swig-wrapper
rm -f CMakeCache.txt
cmake -D APR_LIBRARY=/usr/local/apr/lib/libapr-1.so -D APR_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D APU_LIBRARY=/usr/local/apr/lib/libaprutil-1.so -D APU_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D UNIMRCP_SOURCE_DIR=~/src/unimrcp -D SOFIA_INCLUDE_DIRS=/usr/include/sofia-sip-1.12 -D WRAP_CPP=OFF -D WRAP_JAVA=OFF -D BUILD_C_EXAMPLE=OFF .
make

sudo /sbin/ldconfig

echo Success
