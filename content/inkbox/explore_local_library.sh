#!/bin/busybox-initrd sh

DEVICE="$(cat /opt/inkbox_device)"

calculate() {
	result=$(awk "BEGIN { print "$*" }")
	printf "%.0f\n" ${result}
}

cd "$(dirname ""${0}"")"

#### EPUB ####
pre_epubtool_epoch="$(date +%s)"
json=$(EXTRACT_COVER=1 LD_LIBRARY_PATH='/lib:system/lib' system/bin/epubtool "${@}")

# Evaluate constants for screen-size-based icon scaling
if [ "${DEVICE}" == "kt" ]; then
	eval $(/external_root/opt/bin/fbink/fbink -e)
else
	eval $(system/lib/ld-musl-armhf.so.1 /external_root/opt/bin/fbink/fbink -e)
fi

coverSize="$(calculate ${viewWidth}/${icon_width_divider})!x$(calculate ${viewHeight}/${icon_height_divider})!"

#### ePUB thumbnails ####
cd /mnt/onboard/onboard/.thumbnails
for cover in *; do
	if [ "${cover}" != "*" ]; then
		cover_epoch="$(busybox-initrd stat -c '%Y' ""${cover}"")"
		if [ ${cover_epoch} -ge ${pre_epubtool_epoch} ]; then
			chroot /external_root /usr/bin/convert "/data/onboard/.thumbnails/${cover}" -resize "${coverSize}" "/data/onboard/.thumbnails/${cover}"
		fi
	fi
done
cd - &>/dev/null

#### Book ID ####
last_book_id=$(echo "${json}" | grep "\"BookID\"\:" | awk '{ print $2 }' | tr -d "\"" | tr -d "," | tail -n 1)
book_id=$((last_book_id+1))

IFS=$'\n'; set -f
#### TXT ####
for txt in $(find /mnt/onboard/onboard \( -path "/mnt/onboard/onboard/.inkbox" -o -path "/mnt/onboard/onboard/.apps" -o -path "/mnt/onboard/onboard/.thumbnails" \) -prune -o -name "*.txt" -or -name "*.TXT"); do
	[ -d "${txt}" ] && continue
	if [ ${book_id} == 1 ]; then
		char="{"
	else
		char=",{"
	fi
	json="${json}${char}\"BookID\": \"${book_id}\",\"BookPath\": \"${txt}\",\"Title\": \"$(basename ""${txt}"")\"}"
	book_id=$((book_id+1))
done

#### PDF ####
for pdf in $(find /mnt/onboard/onboard \( -path "/mnt/onboard/onboard/.inkbox" -o -path "/mnt/onboard/onboard/.apps" -o -path "/mnt/onboard/onboard/.thumbnails" \) -prune -o -name "*.pdf" -or -name "*.PDF"); do
	[ -d "${pdf}" ] && continue
	pdf_cksum="$(sha256sum ""${pdf}"" | awk '{ print $1 }')"
	cover_raw_mutool="${pdf_cksum}"
	cover_raw="/mnt/onboard/onboard/.thumbnails/${pdf_cksum}1"
	if [ ! -f "/mnt/onboard/onboard/.thumbnails/${pdf_cksum}" ]; then
		cd /mnt/onboard/onboard/.thumbnails && /usr/local/bin/mutool convert -F png -O width=$(calculate ${viewWidth}/${icon_width_divider}),height=$(calculate ${viewHeight}/${icon_height_divider}) -o "${cover_raw_mutool}" "${pdf}" 1 && cd -
		cover=$(ls ${cover_raw})
		cover="${cover%?}"
		mv "${cover_raw}" "${cover}"
	else
		cover="/mnt/onboard/onboard/.thumbnails/${pdf_cksum}"
	fi
	if [ ${book_id} == 1 ]; then
		char="{"
	else
		char=",{"
	fi
	json="${json}${char}\"BookID\": \"${book_id}\",\"BookPath\": \"${pdf}\",\"CoverPath\": \"/mnt/onboard/onboard/.thumbnails/${pdf_cksum}\",\"Title\": \"$(basename ""${pdf}"")\"}"
	book_id=$((book_id+1))
done

#### Pictures ####
for picture in $(find /mnt/onboard/onboard \( -path "/mnt/onboard/onboard/.inkbox" -o -path "/mnt/onboard/onboard/.apps" -o -path "/mnt/onboard/onboard/.thumbnails" -o -path "/mnt/onboard/onboard/.screensaver" \) -prune -o -name "*.png" -or -name "*.PNG" -or -name "*.jpg" -or -name "*.JPG" -or -name "*.jpeg" -or -name "*.JPEG" -or -name "*.bmp" -or -name "*.BMP" -or -name "*.tif" -or -name "*.TIF" -or -name "*.tiff" -or -name "*.TIFF"); do
	[ -d "${picture}" ] && continue
	cover="$(sha256sum ""${picture}"" | awk '{ print $1 }')"
	[ ! -f "/mnt/onboard/onboard/.thumbnails/${cover}" ] && chroot /external_root /usr/bin/convert "$(echo "${picture}" | sed 's/\/mnt\/onboard\/onboard/\/data\/onboard/g')" -resize "${coverSize}" "/data/onboard/.thumbnails/${cover}"
	if [ ${book_id} == 1 ]; then
		char="{"
	else
		char=",{"
	fi
	json="${json}${char}"\"BookID\"": \"${book_id}\",\"BookPath\": \"${picture}\",\"CoverPath\": \"/mnt/onboard/onboard/.thumbnails/${cover}\",\"Title\": \"$(basename ""${picture}"")\"}"
	book_id=$((book_id+1))
done
unset IFS; set +f

#### JSON output ####
echo "${json}]}" > /inkbox/LocalLibrary.db.raw
