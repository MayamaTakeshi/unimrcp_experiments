#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

docker run --rm -it -v /etc/localtime:/etc/localtime:ro -v `pwd`/..:/home/$(whoami)/host unimrcp


