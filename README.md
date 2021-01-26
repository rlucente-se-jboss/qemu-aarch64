# qemu-aarch64-on-osx
This simple tutorial helps get an ARMv8 emulated system up and
running on OSX.

## Setup QEMU
First, you'll need to install QEMU. On OSX, the easiest way to do
this is to use [brew](https://brew.sh).  Once brew is enabled, type
the following:

    brew install qemu

QEMU will place firmware files in `/usr/local/share/qemu` with `.fd`
extensions.

## Installation
Clone this repository to your local OSX host. Next, obtain the DVD
ISO image for the operating system you'd like to install. This
defaults to RHEL 8.3 for aarch64 which can be downloaded from the
[Red Hat Customer Portal](https://access.redhat.com/downloads/content/419/ver=/rhel---8/8.3/aarch64/product-software).
Adjust the various parameters in the `demo.conf` file. Then,

    ./launch.sh

## Update the emulated system
Once the system starts you'll be prompted to go through the text
mode of the anaconda installer for RHEL. Make sure to configure the
various options including networking and a minimal install.

Immediately after installation, you can copy the `setup-rhel8.sh`
script to the emulated system to subscribe and pull updates from
Red Hat. From the host,

    scp -P 2222 setup-rhel8.sh rlucente@localhost:

Log on to the emulated system and edit `setup-rhel8.sh` and set the `USERNAME`
and `PASSWORD` to match your [Red Hat Customer Portal](https://access.redhat.com)
credentials. Then,

    ssh -p 2222 rlucente@localhost
    sudo ./setup-rhel8.sh

## Running
Once installed, the directory containing this repo will have several
`.img` files. To launch your system, simply run:

    ./launch.sh

