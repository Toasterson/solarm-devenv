FROM opensuse/leap:latest

RUN  zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses \
    qemu-arm qemu-tools gptfdisk

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
