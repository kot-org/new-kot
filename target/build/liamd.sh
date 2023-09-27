#!/bin/bash

ACTION=$1
BOOT_DEVICE=$2
PACKAGE_NAME=$3

if [ "$PACKAGE_NAME" = "all" ]; then
    PACKAGE_NAME="--all"
fi

if [ "$BOOT_DEVICE" = "virtual" ]; then
    BOOT_DEVICE="liamd/boot-kot.img"
fi

cd ../ # target

source boot-disk.sh mount liamd amd64 $BOOT_DEVICE boot_disk_kot_mount

cd ../ # root

if [ "$PACKAGE_NAME" = "" ]; then
    xbstrap install --$ACTION
else
    xbstrap install $PACKAGE_NAME --$ACTION
fi

cd target/ # target

source boot-disk.sh unmount liamd amd64 $BOOT_DEVICE boot_disk_kot_mount
