#!/system/bin/sh

# 定义变量，"="右边可以是数值
APP_MARK=/data/local/symbol_data_app
app_success_flag=0
# 进入某个目录里面
cd /data/app

# 判断文件是否存在，如果APP_MARK所指的文件不存在则进入if语句执行，存在则不进入if语句执行。"!"表示非，"$"用来引用变量，"-e"表示文件存在
if [ ! -e $APP_MARK ]; then
# 直到app_success_flag的值等于1才结束until do done循环，"-eq" 表示等于
    until [ $app_success_flag -eq 1 ]
	do
# 解压zip文件，-o 表示强制覆盖原有文件，-q 表示不打印任何信息，-d 表示解压到指定目录下		
        busybox unzip /system/usr/apks.zip -o -q -d /data/app/
# 判断上一条语句是否执行成功，"$?" 表示上一条语句执行的结果，"$?" 等于 0 表示成功，否则失败
        if [ $? -eq 0 ]; then
# 循环查找/data/app下的apk文件并赋给变量 file,如果file不存在或为空则退出循环 for do done, "$(命令)" 表示 引用 命令执行的结果
            for file in $(ls *.apk)
			do
				#busybox cp -f /system/usr/$file /data/app/
				echo "chown system:system /data/app/$file"
				echo "chmod 644 /data/app/$file"
				chown system:system /data/app/$file
				chmod 644 /data/app/$file
			done
# 将app_success_flag赋值为 1		    
            app_success_flag=1
# 创建文件		    
            touch $APP_MARK
		else
# 将app_success_flag赋值为 0		    
            app_success_flag=0
		fi
		echo "data app sleep 1"
		sleep 1
	done
fi