#!/bin/sh

MOUNT_RULE=`cat /inkbox/remount`

if [ "$MOUNT_RULE" != "false" ]; then
        umount -l -f /inkbox
        mount -t tmpfs tmpfs /inkbox
        mkdir -p /inkbox/book/split
        mkdir -p /inkbox/dictionary
else
        echo "split.sh: remount flag set to 'false', not remounting tmpfs..."
fi
