#!/usr/bin/env bash

set -ex

rm -rf /data/proto/root_aarch64/* /tmp/solaris/  && \
    make -C /ws/openindiana/aarch64-porting/illumos-gate/usr/src tools && \
    make -C /ws/openindiana/aarch64-porting/illumos-gate/usr/src clobber -j MACH=aarch64 && \
    time make -C /ws/openindiana/aarch64-porting/illumos-gate/usr/src -j MACH=aarch64 2>&1 | \
    tee /ws/openindiana/aarch64-porting/illumos-gate/usr/src/build.aarch64.log
