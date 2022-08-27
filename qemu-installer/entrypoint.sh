#!/usr/bin/bash

set -ex

IFACE="$(ls -1 /sys/class/net/ | head -1)"

echo "allow ${IFACE}" >> /etc/qemu/bridge.conf

base_dir="/data/"

disk_img=${base_dir}/disk-a64.img

rm ${disk_img}

qemu-img create -f raw ${disk_img} 16G
sgdisk -g -e --clear --new=1:2048: --change-name=1:solaris --typecode=1:6A85CF4D-1DD2-11B2-99A6-080020736631 ${disk_img}

illumos_dir=${base_dir}/illumos-gate
disk_img=${base_dir}/disk-a64.img

qemu-system-aarch64 -nographic -machine virt -m 1G -smp 4 \
    -cpu cortex-a53 \
    -kernel ${illumos_dir}/usr/src/psm/stand/boot/aarch64/virt/inetboot.bin \
    -append "-D /virtio_mmio@a003e00" \
    -netdev bridge,id=net0,br=${IFACE} \
    -device virtio-net-device,netdev=net0,mac=52:54:00:70:0a:e4 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=${disk_img},format=raw,id=hd0,if=none \
    -semihosting-config enable=on,target=native \
    -gdb tcp::1234
