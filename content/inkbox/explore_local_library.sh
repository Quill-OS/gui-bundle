#!/bin/sh

calculate() {
	result=$(awk "BEGIN { print "$*" }")
	printf "%.0f\n" ${result}
}

if [ ${EXTRACT_COVER} == 1 ]; then
	EXTRACT_COVER=${EXTRACT_COVER} LD_LIBRARY_PATH="/lib:system/lib" system/bin/epubtool ${@}
else
	LD_LIBRARY_PATH="/lib:system/lib" system/bin/epubtool ${@}
fi

eval $(system/lib/ld-musl-armhf.so.1 /external_root/opt/bin/fbink/fbink -e)
coverSize="$(calculate ${viewWidth}/8)x$(calculate ${viewHeight}/8)"

if [ ${EXTRACT_COVER} == 1 ]; then
	cd /mnt/onboard/onboard/.thumbnails
	for cover in *; do
		if [ "${cover}" != "*" ]; then
			chroot /external_root /usr/bin/convert "/data/onboard/.thumbnails/${cover}" -resize "${coverSize}" "/data/onboard/.thumbnails/${cover}"
		fi
	done
	cd - &>/dev/null
fi
