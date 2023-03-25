# qemu-aarch64
This simple tutorial helps get an ARMv8 emulated system up and
running on either Fedora, RHEL, or OSX.

## Install QEMU
Clone this repository to your local host. You'll need to install
QEMU. Once installed, QEMU will place firmware files with `.fd`
extensions in system-specific locations shown below:

* Fedora: /usr/share/edk2/aarch64/
* RHEL 8: /opt/qemu-5.2.0/share/qemu/
* OSX: /usr/local/share/qemu/

Make sure to adjust the `demo.conf` settings appropriately as
described below.

### Install QEMU on Fedora
To install QEMU on Fedora simply use:

    sudo dnf -y install qemu

### Install QEMU on RHEL
On RHEL, you'll need to register and update the system. Edit
`demo.conf` and set the `USERNAME` and `PASSWORD` to match
your [Red Hat Customer Portal](https://access.redhat.com) credentials.
Then,

    sudo ./setup-rhel.sh

Next, you'll need to obtain a QEMU rpm as RHEL does not include the
ability to emulate aarch64 architectures OOTB. Follow these
[instructions](https://github.com/ajacocks/qemu) to build a QEMU
rpm for RHEL.

Copy the QEMU rpm to the target system and install it using:

    sudo subscription-manager repos \
        --enable=codeready-builder-for-rhel-8-x86_64-rpms

    sudo dnf -y install dnf-utils \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    sudo dnf config-manager --disable epel epel-modular
    
    sudo dnf -y install --enablerepo=epel \
        /path/to/qemu-full-5.2.0-1.el8.x86_64.rpm

where `/path/to/` matches the location of the QEMU rpm on your local
system. The above commands install the EPEL repos but don't leave
them enabled. Adjust accordingly for your target system needs.

### Install QEMU on OSX
The easiest way to do this is to use [brew](https://brew.sh). Once
brew is enabled, type the following:

    brew install qemu

## Installation
Adjust the various parameters in the `demo.conf` file. For Fedora,
you must modify the `UEFI_FW_PATH` to be

    UEFI_FW_PATH=/usr/share/edk2/aarch64/QEMU_EFI.fd

For RHEL, you must modify the `UEFI_FW_PATH` to be

    UEFI_FW_PATH=/opt/qemu-5.2.0/share/qemu/edk2-aarch64-code.fd

Obtain the DVD ISO image for the operating system you'd like to
install. This defaults to RHEL 8.3 for aarch64 which can be downloaded
from the [Red Hat Customer Portal](https://access.redhat.com/downloads/content/419/ver=/rhel---8/8.3/aarch64/product-software).

For RHEL only, type the command:

    export PATH=$PATH:/opt/qemu-5.2.0/bin

For all systems, launch the emulated Arm system using:

    ./launch.sh

## Update the emulated system
Once the system starts you'll be prompted to go through the text
mode of the anaconda installer for RHEL. Make sure to configure the
various options including networking and a minimal install. Also
make sure to create a regular user with system admin privileges.

Immediately after installation, you can copy the `demo.conf` and
`setup-rhel.sh` files to the emulated system to subscribe and pull
updates from Red Hat. From the host,

    scp -P 2222 demo.conf setup-rhel.sh USER@localhost:

Log on to the emulated system with the regular `USER` you created
at installation and register and update the system as shown in the
following commands.

    ssh -p 2222 USER@localhost
    sudo ./setup-rhel.sh

## Running
Once installed, the directory containing this repo will have several
`.img` files. To launch your system, simply run:

    ./launch.sh

