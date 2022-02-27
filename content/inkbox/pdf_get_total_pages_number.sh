#!/bin/sh

[ -z "${1}" ] && echo "'filename' argument needed" && exit 1

strings < "${1}" | sed -n 's|.*/Count -\{0,1\}\([0-9]\{1,\}\).*|\1|p' | sort -rn | head -n 1 > /run/pdf_total_pages_number
