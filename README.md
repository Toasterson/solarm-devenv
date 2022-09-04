# illumos SolARM
This repo is the official upstreaming and development project for illumos on ARM processors and platforms. This repo included a hosting development environment setup and the automations to get you going to develop.

This Repository contains the following parts:
- A VM to host the services required to run the Network boot Environment vis NFS [README](./netsvc-vm/README.md)
- The OpenSolaris Porting Project sources as Subrepo [README](./illumos-gate/README.md)
- The OpenSolaris Porting Project build container [README](./illumos-build/README.md)
- Qemu Emulator and scripts/guides to run qemu-aarch64 [README](./qemu-installer/README.md)

To get started first follow the instructions in the build container or use the provided shellscripts

## Building with the Shellscripts
First build the docker container to host the build
```bash
./make_build_container.sh
```

Then start the container with a Shell
```bash
./start_build_container.sh
```

Then inside the container run
```bash
cd ${WKDIR}
./run_build_illumos.sh
```

## Setup the Netservices host VM
After the build has run one can start the vagrant build to serve the illumos root via NFS for a qemu VM to boot from.
change the directory to `netsvc-vm` and run
```bash
vagrant up --provider libivrt
```
When the VM is running go to `qemu-installer` and follow along the [README](./qemu-installer/README.md) there to get the 
VM to netboot. Make sure the qemu process connects to the same bridge as the one the netsvc VM is running under. Instructions how to do that are in the README.

# External Documentations
To get more information on how to help and contribute, check out these docs for the specific topics

- [illumos Makefile Development](https://www.illumos.org/books/dev/layout.html)
- [OpenSolaris Device Drivers](https://dlc.openindiana.org/docs/osol/20090715/DRIVER/html/docinfo.html)
- [Debugging the System and book links](https://illumos.org/docs/user-guide/debug-systems/)
- [Writing Device Drivers](https://illumos.org/books/wdd/preface.html#preface)
- [Dynamic Tracing Guide](https://illumos.org/books/dtrace/preface.html#preface)