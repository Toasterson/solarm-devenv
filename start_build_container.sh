#!/usr/bin/env bash

set -ex

docker run -it --rm -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \
    -u $(id -u $USER):$(id -g $USER) \
    -v $(pwd):$(pwd) \
    -v $HOME:$HOME \
    -v $(pwd)/netsvc-vm/output:/data \
    -e WKDIR=$(pwd) \
    illumos-build:latest bash

