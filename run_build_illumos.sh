#!/usr/bin/env bash

set -ex

OUT_DIR="/data"

rm -rf ${OUT_DIR}/proto/root_aarch64/* /tmp/solaris/

make -C ${WKDIR}/illumos-gate/usr/src tools

make -C ${WKDIR}/illumos-gate/usr/src clobber -j MACH=aarch64

time make -C ${WKDIR}/illumos-gate/usr/src -j MACH=aarch64 2>&1 | \
    tee ${WKDIR}/illumos-gate/usr/src/build.aarch64.log
