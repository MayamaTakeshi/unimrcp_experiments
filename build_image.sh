#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

DOCKER_BUILDKIT=1 docker build --network=host --rm -f Dockerfile -t unimrcp .
