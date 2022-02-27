#!/bin/sh

RUNTIME="busybox-initrd"
EXITCODE=0

if [ -z "${1}" ]; then
	echo "Argument required: ePUB file."
	exit 1
elif [ -z "${2}" ]; then
	echo "Argument required: metadata."
	echo "Available options: title, creator"
	exit 1
else
	RAND_MNT_NUM=$("${RUNTIME}" tr -dc A-Za-z0-9 </dev/urandom | "${RUNTIME}" head -c 10)
	BASEPATH="/tmp/book-${RAND_MNT_NUM}"
	mkdir -p "${BASEPATH}"
	cd "${BASEPATH}"
	"${RUNTIME}" unzip "${1}" &> /dev/null
	OPF_FILE=$("${RUNTIME}" find . -type f -name "*.opf")
	FIND_CMD_EXITCODE=${?}
	if [ ${?} != 0 ]; then
		echo "Error."
		exit ${FIND_CMD_EXITCODE}
	else
		if [ "${2}" == "title" ]; then
			"${RUNTIME}" grep '<dc:title>' "${OPF_FILE}" | "${RUNTIME}" sed -e 's/<[^>]*>//g' | "${RUNTIME}" sed -e 's/[ \t]*//'
		elif [ "${2}" == "creator" ]; then
			"${RUNTIME}" grep '<dc:creator' "${OPF_FILE}" | "${RUNTIME}" sed -e 's/<[^>]*>//g' | "${RUNTIME}" sed -e 's/[ \t]*//'
		else
			echo "Invalid argument: ${2}"
			EXITCODE=1
		fi
	fi
	cd - &> /dev/null
	"${RUNTIME}" rm -rf "${BASEPATH}"
	exit ${EXITCODE}
fi
