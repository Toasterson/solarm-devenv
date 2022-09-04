#!/usr/bin/env bash

set -ex


rm -rf ~/devel/rpms/SOURCES/TOASTdhcp-foundation-conf/etc \
    ~/devel/rpms/SOURCES/TOASTdhcp-illumos-conf/etc/ \
    ~/devel/rpms/SOURCES/TOASTdhcp-foundation-conf.tar.xz \
    ~/devel/rpms/SOURCES/TOASTdhcp-illumos-conf.tar.xz

mkdir -p ~/devel/rpms/SOURCES/TOASTdhcp-foundation-conf/etc
mkdir -p ~/devel/rpms/SOURCES/TOASTdhcp-illumos-conf/etc/

cd /vagrant
cp dhcpd.conf ~/devel/rpms/SOURCES/TOASTdhcp-foundation-conf/etc/
cp dhcpd-illumos.conf ~/devel/rpms/SOURCES/TOASTdhcp-illumos-conf/etc/

cd ~/devel/rpms
cd SOURCES
tar cf - TOASTdhcp-foundation-conf | xz -9evc > TOASTdhcp-foundation-conf.tar.xz
tar cf - TOASTdhcp-illumos-conf | xz -9evc > TOASTdhcp-illumos-conf.tar.xz

cd /vagrant
cp TOASTdhcp-foundation-conf.spec ~/devel/rpms/SPECS/
cp TOASTdhcp-illumos-conf.spec ~/devel/rpms/SPECS/

cd ~/devel/rpms/SPECS
rpmbuild -ba TOASTdhcp-foundation-conf.spec
rpmbuild -ba TOASTdhcp-illumos-conf.spec
