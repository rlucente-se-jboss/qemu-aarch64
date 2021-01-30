#!/usr/bin/env bash

sudo subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-rpms

sudo yum -y group install 'Development Tools'
sudo yum -y install python3 ninja-build glib2-devel pixman-devel zlib-devel

curl -sLO https://download.qemu.org/qemu-5.2.0.tar.xz
tar xvJf qemu-5.2.0.tar.xz
cd qemu-5.2.0
./configure
make
sudo make install

