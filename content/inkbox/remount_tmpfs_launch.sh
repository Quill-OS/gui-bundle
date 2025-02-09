#!/bin/sh

DEVICE=$(cat /opt/inkbox_device)
REAL_DEVICE=$(cat /external_root/opt/inkbox_device)
WIFI_ABLE=$(cat /run/wifi_able)

sync
umount -l -f /inkbox
umount -l -f /run
mount -t tmpfs tmpfs -o size=50% /inkbox
mount -t tmpfs tmpfs -o size=128M /run

mkdir -p /inkbox/book/split
mkdir -p /inkbox/dictionary
echo "${WIFI_ABLE}" > /run/wifi_able
if [ "${REAL_DEVICE}" == "n236" ] || [ "${REAL_DEVICE}" == "n437" ]; then
	ln -s /sys/class/backlight/mxc_msp430_fl.0/brightness /var/run/brightness 2>/dev/null
elif [ "${REAL_DEVICE}" == "n249" ]; then
	ln -s /sys/class/backlight/backlight_cold/actual_brightness /var/run/brightness 2>/dev/null
	ln -s /sys/class/backlight/backlight_cold/brightness /var/run/brightness_write 2>/dev/null
elif [ "${REAL_DEVICE}" == "n418" ]; then
	ln -s /sys/class/leds/aw99703-bl_FL2/brightness /var/run/brightness 2>/dev/null
else
	ln -s /sys/class/backlight/mxc_msp430.0/brightness /var/run/brightness 2>/dev/null
fi

# For udev support
ln -s /external_root/run/udev/ /run/udev
