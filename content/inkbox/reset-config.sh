#!/bin/sh

cd /mnt/onboard/.adds/inkbox
rm -rf .config/
mkdir .config && cd .config
tar -xf ../config.tar.xz
sync
cd ..
echo "true" > .flags/FIRST_BOOT
sync
