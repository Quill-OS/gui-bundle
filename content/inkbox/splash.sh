#!/bin/sh

export DARK_MODE=`cat /kobo/mnt/onboard/.adds/inkbox/.config/10-dark_mode/config`

if [ "$DARK_MODE" == "true" ]; then
	/opt/bin/fbink/fbink -k -f -h
        /opt/bin/fbink/fbink -g file=/tmp/dump.png -h
else
	/opt/bin/fbink/fbink -k -f -h
	/opt/bin/fbink/fbink -g file=/tmp/dump.png
fi
