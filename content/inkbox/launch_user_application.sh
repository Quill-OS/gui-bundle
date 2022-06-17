#!/bin/sh

die() {
	printf "Error: %s.\n" "${1}"
	exit ${2}
}

cd "$(dirname '${0}')"
workdir="${PWD}"

[ -z "${1}" ] && die "No chroot directory specified" 1
[ -z "${2}" ] && die "No application executable specified" 1

QT_FONT_DPI="$(cat /mnt/onboard/.adds/inkbox/.config/09-dpi/config 2>/dev/null)"
chroot_directory="${1}"
proc_mountpoint="${chroot_directory}/proc"
application="${2}"

# Launching user application
# LD_LIBRARY_PATH is ignored by BusyBox here
env LD_LIBRARY_PATH="/lib:system/lib" PATH="/system-bin:/app-bin" QT_FONT_DPI=${QT_FONT_DPI} system/bin/unshare -p -P "${proc_mountpoint}" -- system/lib/ld-musl-armhf.so.1 system/bin/chroot --userspec=user:user "${chroot_directory}" "${application}"

# Relaunching InkBox binary
LD_LIBRARY_PATH='/mnt/onboard/.adds/qt-linux-5.15.2-kobo/lib' QT_FONT_DPI=${QT_FONT_DPI} /mnt/onboard/.adds/inkbox/inkbox
