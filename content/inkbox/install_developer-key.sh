#!/bin/sh

if [ -z "${1}" ]; then
	echo "You must provide the 'UID' argument."
	exit 1
fi
if [ -z "${2}" ]; then
	echo "You must provide the location of the digest file."
	exit 1
fi

echo -n 1 | dd of=/dev/mmcblk0 bs=256 seek=159746
echo -n "${1}" | dd of=/dev/mmcblk0 bs=256 seek=159748
dd if="${2}" of=/dev/mmcblk0 bs=256 seek=159750
sync
exit 0
