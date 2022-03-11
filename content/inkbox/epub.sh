#!/bin/sh

# Arguments		Examples
# 1 - Font size		12
# 2 - Page width	600
# 3 - Page height	800
# 4 - Page number	22
# 5 - Get total pages number

if [ -z "${5}" ]; then
	cat /run/page | tr -d '\n\t' | ./grep -o -P "<div id=\"page${4}\">.*?</div>" | busybox-initrd sed 's/<h3>/<p>/g; s/<\/h3>/<\/p>/g' > /inkbox/book/page
else
	# N is the last page number
	/usr/local/bin/mutool convert -X -F xhtml -S ${1} -W ${2} -H ${3} -o /run/page /run/book.epub 1-N
	sed -n '/div id="page/h;${x;p;}' /run/page | sed 's/[^0-9]*//g' > /run/epub_total_pages_number
fi
