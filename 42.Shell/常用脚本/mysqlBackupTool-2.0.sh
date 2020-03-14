#!/bin/env bash
################################
#
# 作用：mysql数据库备份脚本
# 注意：该脚本目前是密码明文，所以不适合生产使用！！！
#
################################

###########################数据库信息###############################
mysql_user="root"			#MySQL用户
mysql_password="root"			#MySQL用户密码
mysql_host="192.168.27.4"		#Mysql的ip
mysql_port="3306"			#Mysql的端口号
#mysql_charset="utf8" 			#MySQL编码
###########################数据库信息###############################


###########################备份相关配置信息###############################
backup_db_arr=("mydb" "sldb") 		#需备份的数据库名称，多个用空格分开隔开 如("db1" "db2" "db3")
backup_location=/tmp/mysqlbackup 	#备份位置的一级目录，末尾请不要带"/",此项可以保持默认，程序会自动创建文件夹
expire_backup_delete="OFF" 		#是否开启过期备份删除 ON为开启 OFF为关闭
expire_days=3				#过期时间天数 默认为三天，此项只有在expire_backup_delete="ON"时有效
remote_ip_01=192.168.27.4		#远程库ip
remote_user_01=eleven			#远程服务器用户名
remote_password_01=123456		#远程服务器密码
remote_backup_path_01=/home/$remote_user_01/mysqlbackup		#远程存放备份地址
###########################备份相关配置信息###############################


###########################功能实现部分###############################
backup_time=`date +%F_%T` 			#详细时间
backup_Ymd=`date +%F` 				#年月日
backup_dir=$backup_location/$backup_Ymd 	#以年月日作为二级目录

#路径不存在，则创建目录
[ ! -d $backup_dir ] && `mkdir -p $backup_dir`

echo "--------$(date +%F_%T)--------MySQL backup tools start--------" | tee -a $backup_dir/backup.log
	
# mysqldump执行备份
if [ "$backup_db_arr" != "" ];then
	#dbnames=$(cut -d ',' -f1-5 $backup_database)
	#echo "arr is (${backup_db_arr[@]})"
	for dbname in ${backup_db_arr[@]}
	do
		echo "--------$(date +%F_%T)--------database $dbname backup start--------" | tee -a $backup_dir/backup.log
		# --default-character-set=$mysql_charset
		`mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $dbname | gzip > $backup_dir/$dbname-$backup_time.sql.gz`	#以dbname-time.sql.gz作为文件名
		
		if [ $? -eq 0 ];then
			echo "--------$(date +%F_%T)--------database $dbname success backup to $backup_dir/$dbname-$backup_time.sql.gz--------" | tee -a $backup_dir/backup.log
		else
			echo "--------$(date +%F_%T)--------[error]---database $dbname backup fail!--------" | tee -a $backup_dir/backup.log
		fi
	done
else
	echo "--------$(date +%F_%T)--------[error]---No database to backup! backup stop--------" | tee -a $backup_dir/backup.log
	exit
fi


#复制到远程服务器上(复制整个二级目录)

/usr/bin/expect<<EOF
spawn scp -qpr  $backup_dir  ${remote_user_01}@${remote_ip_01}:$remote_backup_path_01

expect {
	"*(yes/no)?" {send "yes\r";exp_continue}
	"*password:" {send 123456\r"}
}
expect interact
EOF


# 删除过期备份操作
if [ "$expire_backup_delete" == "ON" -a "$backup_location" != "" ];then
	#`find $backup_location/ -type d -o -type f -ctime +$expire_days -exec rm -rf {} \;`
	`find $backup_location/ -type d -mtime +$expire_days | xargs rm -rf`
	echo "Expired backup data delete complete!" | tee -a $backup_dir/backup.log
fi

echo "--------$(date +%F_%T)--------database backup over--------" | tee -a $backup_dir/backup.log
exit

###########################功能实现部分###############################
