#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

docker run --network host --rm -it -v /etc/localtime:/etc/localtime:ro -v `pwd`/..:/home/$(whoami)/src unimrcp


