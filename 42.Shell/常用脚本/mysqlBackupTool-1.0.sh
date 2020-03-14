#!/bin/env bash
################################
#
# 作用：mysql数据库备份脚本
#
################################

# 以下配置信息请自己修改
mysql_user="root"			#MySQL用户
mysql_password="root"		#MySQL用户密码
mysql_host="192.168.27.4"	#Mysql的ip
mysql_port="3306"			#Mysql的端口号
#mysql_charset="utf8" 		#MySQL编码
backup_db_arr=("mydb" "sldb") 		#要备份的数据库名称，多个用空格分开隔开 如("db1" "db2" "db3")
backup_location=/tmp/mysqlbackup 	#备份数据存放位置，末尾请不要带"/",此项可以保持默认，程序会自动创建文件夹
expire_backup_delete="OFF" 			#是否开启过期备份删除 ON为开启 OFF为关闭
expire_days=3						#过期时间天数 默认为三天，此项只有在expire_backup_delete="ON"时有效

# 本行开始以下不需要修改
backup_time=`date +%F_%T` 				#备份详细时间
backup_Ymd=`date +%F` 					#定义备份目录中的年月日时间
backup_dir=$backup_location/$backup_Ymd #以时间作为文件夹名称

#路径不存在，则创建目录。启动脚本即创建目录，记录运行日志
[ ! -d $backup_dir ] && `mkdir -p $backup_dir`

echo "${backup_time}-----MySQL backup tools start-----" | tee -a $backup_dir/backup.log

# 判断MYSQL服务是否在运行中,mysql没有启动则备份退出
mysql_ps=`ps -ef |grep mysql | grep -v grep |wc -l`		#注意去除grep本身
mysql_listen=`netstat -an |grep LISTEN |grep $mysql_port|wc -l`
if [ $mysql_ps -eq 0 -o $mysql_listen -eq 0 ]; then
	echo "ERROR:MySQL is not running! backup stop!" | tee -a $backup_dir/backup.log
	exit
else
	echo "MySQL.service status is running! go on" | tee -a $backup_dir/backup.log
fi
 
# 连接到mysql数据库，无法连接则备份退出
mysql -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password <<end
use mysql;
select host,user from user where user='root' and host='localhost';
exit
end
 
if [ $? -ne 0 ]; then
	echo "ERROR:Can't connect mysql server! backup stop!" | tee -a $backup_dir/backup.log
	exit
else
	echo "MySQL connect ok! Please wait......" | tee -a $backup_dir/backup.log
	
	# 判断有没有定义备份的数据库，如果定义则开始备份，否则退出备份
	if [ "$backup_db_arr" != "" ];then
		#dbnames=$(cut -d ',' -f1-5 $backup_database)
		#echo "arr is (${backup_db_arr[@]})"
		for dbname in ${backup_db_arr[@]}
		do
			echo "database $dbname backup start..." | tee -a $backup_dir/backup.log
			
			# --default-character-set=$mysql_charset
			`mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $dbname | gzip > $backup_dir/$dbname-$backup_time.sql.gz`
			
			if [ $? -eq 0 ];then
				echo "database $dbname success backup to $backup_dir/$dbname-$backup_time.sql.gz" | tee -a $backup_dir/backup.log
			else
				echo "database $dbname backup fail!" | tee -a $backup_dir/backup.log
			fi
		done
	else
		echo "ERROR:No database to backup! backup stop" | tee -a $backup_dir/backup.log
		exit
	fi
	
	# 如果开启了删除过期备份，则进行删除操作
	if [ "$expire_backup_delete" == "ON" -a "$backup_location" != "" ];then
		#`find $backup_location/ -type d -o -type f -ctime +$expire_days -exec rm -rf {} \;`
		`find $backup_location/ -type d -mtime +$expire_days | xargs rm -rf`
		echo "Expired backup data delete complete!" | tee -a $backup_dir/backup.log
	fi
	
	echo "$(date +%F_%T)------database backup success----- " | tee -a $backup_dir/backup.log
	exit
fi
