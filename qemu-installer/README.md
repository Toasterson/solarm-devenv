# Qemu Emulator Instructions

# Installation via packages
## Archlinux
```bash
pacman -S qemu-system-aarch64 qemu-img gptfdisk
```
### Suse
```
zypper install qemu-arm qemu-tools gptfdisk
```

# Running the Emulator
## VM Setup specific Variables
If you are using the provided vagrant VM to host the dhcp/tftp/nfs setup you will need to find the bridge that
the VM is connected to

For libvirt provider this should be an interfacestarting with the name `virbr` and a number.
for example on linux you can find that interface with `ip addr | grep virbr`. The Ip address should be in the range defined in the `Vagrantfile` of the VM which by default is `192.168.56.0`.

```bash
export IFACE="virbr1"
```

### Running the Emulator

Now that we have the network interface defined we can run the emulator with
```bash
cd qemu-installer
base_dir=".."

disk_img=${base_dir}/qemu-installer/disk-a64.img

rm ${disk_img}

qemu-img create -f raw ${disk_img} 16G
sgdisk -g -e --clear --new=1:2048: --change-name=1:solaris --typecode=1:6A85CF4D-1DD2-11B2-99A6-080020736631 ${disk_img}

illumos_dir=${base_dir}/illumos-gate
disk_img=${base_dir}/disk-a64.img

flash_bin="${base_dir}/qemu-installer/flash.bin"
inetboot_bin="${illumos_dir}/usr/src/psm/stand/boot/aarch64/virt/inetboot.bin"

qemu-system-aarch64 -nographic -machine virt -m 1G -smp 4 \
    -cpu cortex-a53 \
    -kernel ${illumos_dir}/usr/src/psm/stand/boot/aarch64/virt/inetboot.bin \
    -append "-D /virtio_mmio@a003e00" \
    -netdev bridge,id=net0,br=${IFACE} \
    -device virtio-net-device,netdev=net0,mac=52:54:00:70:0a:e4 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=./disk-a64.img,format=raw,id=hd0,if=none \
    -semihosting-config enable=on,target=native
```

# Installing illumos to disk
```bash
devfsadm
zpool create -f -o altroot=/mnt   rpool /dev/dsk/c1t0d0s0
zfs create rpool/ROOT
zfs create rpool/ROOT/solarm
gtar -o -xf /var/illumos.tar.gz -C /mnt/rpool/ROOT/solarm --warning=no-timestamp
chown -R dladm:netadm  /mnt/rpool/ROOT/solarm/etc/dladm
chown -R netadm:netadm /mnt/rpool/ROOT/solarm/etc/ipadm
chown -R netadm:netadm /mnt/rpool/ROOT/solarm/etc/nwam
mkdir -p /mnt/rpool/ROOT/solarm/etc/zfs
zfs unmount -a
zpool export rpool
zpool import -o cachefile=/tmp/zpool.cache -o altroot=/mnt rpool
cp /tmp/zpool.cache /mnt/rpool/ROOT/solarm/etc/zfs/
zfs unmount -a
zpool set bootfs=rpool/ROOT/solarm rpool
zpool set cachefile="" rpool
zfs set mountpoint=none rpool
zfs set mountpoint=legacy rpool/ROOT
zfs set canmount=noauto rpool/ROOT/solarm
zfs set mountpoint=/ rpool/ROOT/solarm
zpool export rpool
```

# Booting the Installed disk
```bash
qemu-system-aarch64 -nographic -machine virt -m 1G -smp 4 \
    -cpu cortex-a53 \
    -kernel ${illumos_dir}/usr/src/psm/stand/boot/aarch64/virt/inetboot.bin \
    -append "-D /virtio_mmio@a003c00" \
    -netdev bridge,id=net0,br=${IFACE} \
    -device virtio-net-device,netdev=net0,mac=52:54:00:70:0a:e4 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=./disk-a64.img,format=raw,id=hd0,if=none \
    -semihosting-config enable=on,target=native
```