#!/usr/bin/env bash

. $(dirname $0)/demo.conf

# do everything in the same directory as this script
pushd $(dirname $0) &> /dev/null

if [[ ! -f flash0.img -o ! -f flash1.img ]]
then
  # create the raw images to be used as flash for UEFI and efi variable storage
  rm -f flash0.img flash1.img
  dd if=/dev/zero bs=1m count=64 of=flash0.img
  dd if=/dev/zero bs=1m count=64 of=flash1.img
  dd if=$UEFI_FW_PATH bs=1m of=flash0.img conv=notrunc
fi

if [[ ! -f rhel-disk.img ]]
  # create a fresh hard disk for install
  rm -f rhel-disk.img
  qemu-img create rhel-disk.img $HDD_SIZE
fi

# QEMU 5.2 ARM Virtual Machine
# no graphical console, redirect serial I/O to the terminal
# 8 GB memory
# cortex-a72 (ARMv8) CPU
# 8 cores
# create a SLiRP mode network backend named "vnet" to NAT to the
#   host's network and forward port 2222 on the host to port 22
#   on the guest. The network runs dhcp for the $VM_NET address
#   range
# create a virtio-net-pci device on the backend "vnet" network 
# create "drive0" using the blank image file to act as the hard disk
# create "drive1" as the CDROM for ISO installation
# create the UEFI firmware flash drives

qemu-system-aarch64 \
    -nographic \
    -machine virt \
    -m $MEM_SIZE \
    -cpu cortex-a72 \
    -smp $NUM_CORES \
    -device virtio-net-pci,netdev=mynet0 \
    -netdev user,id=mynet0,net=$VM_NET,hostfwd=tcp::2222-:22 \
    -drive file=rhel-disk.img,if=none,id=drive0,cache=writeback \
    -device virtio-blk,drive=drive0,bootindex=0 \
    -drive file=$ISO_PATH,if=none,id=drive1,media=cdrom \
    -device virtio-blk,drive=drive1,bootindex=1 \
    -drive file=flash0.img,format=raw,if=pflash \
    -drive file=flash1.img,format=raw,if=pflash

popd &> /dev/null

