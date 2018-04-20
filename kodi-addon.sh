#!/system/bin/sh

XBMC_MARK=/data/local/symbol_xbmc_addons
xbmc_success_flag=0

if [ ! -e $XBMC_MARK ]; then
	until [ $xbmc_success_flag -eq 1 ]
	do
		busybox unzip /system/usr/xbmc1.zip -o -q -d /sdcard/Android/data/
		if [ $? -eq 0 ]; then
		    xbmc_success_flag=1
		    touch $XBMC_MARK
		else
		    xbmc_success_flag=0
		fi
		echo "xbmc_addons sleep 1"
		sleep 1
	done
fi