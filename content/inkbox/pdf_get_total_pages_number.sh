#!/bin/sh

[ -z "${1}" ] && echo "'filename' argument needed" && exit 1

/usr/local/bin/mutool info -M "${1}" | grep "Pages: " | awk '{ print $2 }' > /run/pdf_total_pages_number
