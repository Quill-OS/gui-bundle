#!/bin/sh

# Fossil
killall -q nickel sickel hindenburg 2>/dev/null
cd /mnt/onboard/.adds/inkbox

DPI=$(cat .config/09-dpi/config 2>/dev/null)
GENUINE_OS=$(cat /opt/inkbox_genuine 2>/dev/null)
DEVICE=$(cat /opt/inkbox_device 2>/dev/null)
FIRST_LAUNCH_SINCE_BOOT=$(cat /tmp/first_launch_since_boot 2>/dev/null)
LOCKSCREEN=$(cat .config/12-lockscreen/config 2>/dev/null)

if [ "${GENUINE_OS}" == "true" ]; then
	FIRST_BOOT=$(cat /external_root/boot/flags/FIRST_BOOT 2>/dev/null)
	GUI_DEBUG=$(cat /external_root/boot/flags/GUI_DEBUG 2>/dev/null)
else
	FIRST_BOOT=$(cat .flags/FIRST_BOOT 2>/dev/null)
	GUI_DEBUG=$(cat .flags/GUI_DEBUG 2>/dev/null)
fi

MOUNT_RULE=$(cat /inkbox/remount 2>/dev/null)

if [ "${MOUNT_RULE}" != "false" ]; then
        umount -l -f /inkbox 2>/dev/null
        mount -t tmpfs tmpfs /inkbox
else
        echo "inkbox.sh: remount flag set to 'false', not remounting tmpfs..."
fi

if [ "${GUI_DEBUG}" == "true" ]; then
	DEBUG=1
else
	DEBUG=0
fi

mkdir -p .flags 2>/dev/null
mkdir -p /inkbox
mkdir -p /mnt/onboard/onboard/.database
mkdir -p .config/00-kobox
mkdir -p .config/01-demo
mkdir -p .config/02-clock
mkdir -p .config/03-brightness
mkdir -p .config/04-book
mkdir -p .config/05-quote
mkdir -p .config/06-words
mkdir -p .config/07-words_number
mkdir -p .config/08-recent_books
mkdir -p .config/09-dpi
mkdir -p .config/10-dark_mode
mkdir -p .config/11-menubar
mkdir -p .config/12-lockscreen
mkdir -p .config/13-epub_page_size
mkdir -p .config/14-reader_scrollbar
mkdir -p .config/15-sleep_timeout
mkdir -p .config/16-global_reading_settings
mkdir -p .config/17-wifi_connection_information
mkdir -p .config/18-encrypted_storage
mkdir -p .config/19-timezone
mkdir -p .config/20-sleep_daemon
mkdir -p .config/21-local_library
mkdir -p .config/22-usb
mkdir -p .config/23-updates
mkdir -p .config/e-2-audio

rm /var/run/brightness 2>/dev/null
if [ "${DEVICE}" != "n236" ] && [ "${DEVICE}" != "n437" ]; then
	ln -s /sys/class/backlight/mxc_msp430.0/brightness /var/run/brightness 2>/dev/null
else
	ln -s /sys/class/backlight/mxc_msp430_fl.0/brightness /var/run/brightness 2>/dev/null
fi

if [ "${DPI}" != "false" ]; then
        if [ "${DPI}" == "" ]; then
		if [ "${DEVICE}" == "n705" ]; then
	                echo "187" > .config/09-dpi/config
		elif [ "${DEVICE}" == "n905" ] || [ "${DEVICE}" == "kt" ]; then
			echo "160" > .config/09-dpi/config
		elif [ "${DEVICE}" == "n613" ] || [ "${DEVICE}" == "n236" ] || [ "${DEVICE}" == "n306" ]; then
			echo "195" > .config/09-dpi/config
		elif [ "${DEVICE}" == "n437" ]; then
			echo "275" > .config/09-dpi/config
		elif [ "${DEVICE}" == "n873" ]; then
			echo "285" > .config/09-dpi/config
		else
			echo "187" > .config/09-dpi/config
		fi
                DPI=$(cat .config/09-dpi/config 2>/dev/null)
        elif [ "${FIRST_BOOT}" == "true" ]; then
                QT_FONT_DPI=${DPI} ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./oobe-inkbox
        else
                if [ "${1}" == "lockscreen" ]; then
                        QT_FONT_DPI=${DPI} ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./lockscreen
                else
			if [ "${FIRST_LAUNCH_SINCE_BOOT}" == "true" ]; then
				echo "false" > /tmp/first_launch_since_boot
				if [ "${LOCKSCREEN}" == "true" ]; then
					INITIAL_LAUNCH=1 QT_FONT_DPI=${DPI} ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./lockscreen
				else
					QT_FONT_DPI=${DPI} ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" DEBUG=${DEBUG} ./inkbox
				fi
			else
				QT_FONT_DPI=${DPI} ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" DEBUG=${DEBUG} ./inkbox
			fi
		fi
        fi
else
        if [ "${FIRST_BOOT}" == "true" ]; then
                QT_FONT_DPI=0 ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./oobe-inkbox
        else
                if [ "${1}" == "lockscreen" ]; then
                        QT_FONT_DPI=0 ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./lockscreen
                else
			if [ "${FIRST_LAUNCH_SINCE_BOOT}" == "true" ]; then
				echo "false" > /tmp/first_launch_since_boot
				if [ "${LOCKSCREEN}" == "true" ]; then
					INITIAL_LAUNCH=1 QT_FONT_DPI=0 ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" ./lockscreen
				else
					QT_FONT_DPI=0 ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" DEBUG=${DEBUG} ./inkbox
				fi
			else
				QT_FONT_DPI=0 ADDSPATH="/mnt/onboard/.adds/" QTPATH="${ADDSPATH}/qt-linux-5.15.2-kobo" LD_LIBRARY_PATH="${QTPATH}lib:lib:" DEBUG=${DEBUG} ./inkbox
			fi
                fi
        fi
fi
