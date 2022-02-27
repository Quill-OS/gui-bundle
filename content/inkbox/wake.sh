#!/bin/sh

READING=`cat /tmp/inkboxReading`

if [ "$READING" == "true" ]; then
	echo "true" > /tmp/suspendBook
	echo "false" > /inkbox/remount
else
	echo "false" > /tmp/suspendBook
	echo "true" > /inkbox/remount
fi

/mnt/onboard/.adds/inkbox/inkbox.sh
