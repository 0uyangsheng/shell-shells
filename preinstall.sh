#!/system/bin/sh

# 定义变量,"="右边可以是文件也可以是目录
MARK=/data/local/symbol_thirdpart_apks_installed
PKGS=/system/usr
SYMBOL_FOTA=/data/local/symbol_fota
BACKUP_KODI=/sdcard/Android/data/backup_kodi

# 判断文件是否存在，如果MARK所指的文件不存在则进入if语句执行，存在则不进入if语句执行。"!"表示非，"$"用来引用变量，"-e"表示文件存在
if [ ! -e $MARK ]; then

# "echo"用来输出字符串到屏幕
echo "booting the first time, so pre-install some APKs."

# 执行busybox语句，查找变量PKGS所指的/system/usr下所有apk，然后调用pm安装
busybox find $PKGS -name "*\.apk" -exec sh /system/bin/pm install -r {} \;

# 判断文件是否存在，如果SYMBOL_FOTA所指的文件存在则进入if语句执行，不存在则不进入if语句执行
    if [ -e $SYMBOL_FOTA ]; then

# 启动一个应用
        am start -n com.android.tv.settings/.KodiUpgradeAttention
# 强制停止一个应用	    
        am force-stop org.xbmc.kodi
# 判断文件夹是否存在，如果BACKUP_KODI所指的文件夹不存在则进入if语句执行，存在则不进入if语句执行。"!"表示非，"$"用来引用变量，
# "-d"表示文件夹存在
        if [ ! -d $BACKUP_KODI ]; then
	        busybox mv /sdcard/Android/data/org.xbmc.kodi /sdcard/Android/data/backup_kodi
	        echo "OK, org.xbmc.kodi was renamed to backup_kodi"
# fi 表示if语句结束，在if后并与就近的if配套使用
	    fi

# 卸载应用
	    /system/bin/pm uninstall org.xbmc.kodi
# 睡眠2秒	    
        sleep 2

# 安装应用	    
        /system/bin/pm install /system/usr/kodi-15.2-Isengard_rc1-armeabi-v7a.apk

	    am force-stop org.xbmc.kodi
	    busybox rm -rf /sdcard/Android/data/org.xbmc.kodi
	    busybox mv /sdcard/Android/data/backup_kodi /sdcard/Android/data/org.xbmc.kodi
	    echo "OK, backup_kodi was renamed to org.xbmc.kodi"

# 删除SYMBOL_FOTA所代表的文件
        busybox rm $SYMBOL_FOTA
	    echo "OK, symbol_fota was removed"
	    am force-stop com.android.tv.settings
	    am start -n com.android.tv.settings/.KodiUpgradeComplete
    fi

# NO NEED to delete these APKs since we keep a mark under data partition.
# And the mark will be wiped out after doing factory reset, so you can install
# these APKs again if files are still there.

# 创建文件
touch $MARK
echo "OK, installation complete."
fi