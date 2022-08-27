#!/usr/bin/env bash

set -ex

docker run -it --rm -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \
    -u $(id -u $USER):$(id -g $USER) \
    -v /ws/openindiana/aarch64-porting:/ws/openindiana/aarch64-porting \
    -v /ws/toast:/ws/toast \
    -v /ws/openindiana/aarch64-porting/output:/data \
    illumos-build:latest bash

