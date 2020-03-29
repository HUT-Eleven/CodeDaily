---
typora-copy-images-to: ..\pictures
typora-root-url: ..\pictures
---

# 一、条件判断语句

##1. 语法格式

- 格式1： ==**test**== 条件表达式
- 格式2： **[** 条件表达式 ]   
- 格式3： **[[** 条件表达式 ]] ,区别：可以用正则....

**特别说明：**

1）==[    ] 和[[    ]]两边都有空格==

2）更多判断，`man test`去查看，很多的参数都用来进行条件判断

3）[] 和[[]]特殊：**非空返回** **true**，如：[ '' ]返回false,[ !  '' ]返回ture

## 2. 相关参数

==以下所有都可以用`man test`辅助记忆==

### ㈠ ==判断文件==

| 判断参数 | 含义                                         |
| -------- | -------------------------------------------- |
| ==-e==   | 判断文件是否存在（任何类型文件）             |
| ==-f==   | 判断文件是否存在==并且==是一个file           |
| -d       | 判断文件是否存在并且是一个目录               |
| -L       | 判断文件是否存在并且是一个软连接文件         |
| -b       | 判断文件是否存在并且是一个块设备文件         |
| -S       | 判断文件是否存在并且是一个套接字文件         |
| -c       | 判断文件是否存在并且是一个字符设备文件       |
| -p       | 判断文件是否存在并且是一个命名管道文件       |
| ==-s==   | 判断文件是否存在并且是一个非空文件（有内容） |

**举例说明：**

```powershell
test -e file					只要文件存在条件为真
[ -d /shell01/dir1 ]		 	判断目录是否存在，存在条件为真
[ ! -d /shell01/dir1 ]			判断目录是否存在,不存在条件为真
[[ -f /shell01/1.sh ]]			判断文件是否存在，并且是一个普通的文件
```

### ㈡ 判断文件权限

| 判断参数 | 含义                       |
| -------- | -------------------------- |
| -r       | 当前用户对其是否可读       |
| -w       | 当前用户对其是否可写       |
| -x       | 当前用户对其是否可执行     |
| -u       | 是否有suid，高级权限冒险位 |
| -g       | 是否sgid，高级权限强制位   |
| -k       | 是否有t位，高级权限粘滞位  |

### ㈢ 判断文件新旧

说明：这里的新旧指的是==文件的修改时间==。

| 判断参数         | 含义                                                         |
| ---------------- | ------------------------------------------------------------ |
| file1 -nt  file2 | 比较file1是否比file2新                                       |
| file1 -ot  file2 | 比较file1是否比file2旧                                       |
| file1 -ef  file2 | 比较是否为同一个文件，或者用于判断硬连接，是否指向同一个inode |

### ㈣ ==判断整数==

| 判断参数 | 含义              |
| -------- | ----------------- |
| -eq      | equals,相等       |
| -ne      | not equals,不等   |
| -gt      | greater than,大于 |
| -lt      | less than,小于    |
| -ge      | 大于等于          |
| -le      | 小于等于          |


- 数值比较

```powershell
# [ $(id -u) -eq 0 ] && echo "the user is admin"
$ [ $(id -u) -ne 0 ] && echo "the user is not admin"

# uid=`id -u`
# test $uid -eq 0 && echo this is admin
```

### ㈤ ==判断字符串==

比较字符串时，最好用双引号框起来

| 判断参数                                   | 含义                                                      |
| ------------------------------------------ | --------------------------------------------------------- |
| -z                                         | zero,判断是否为==空==字符串，字符串长度为0则成立          |
| -n                                         | not null ,判断是否为==非空==字符串，字符串长度不为0则成立 |
| string1 = string2  或者 string1 == string2 | 判断字符串是否相等, ==等号两边需空格==                    |
| string1 != string2                         | 判断字符串是否相不等                                      |
注意:

```powershell
# a='hello world';b=world
# [ $a = $b ];echo $?   ----> 会报错
以下正确
# [ "$a" = "$b" ];echo $?
```
### ㈥ ==&&  ||==

==shell中&&和||没有优先级之分，从左往右依次看==

| 判断符号   | 含义   | 举例                                                         |
| ---------- | ------ | ------------------------------------------------------------ |
| -a 和 &&   | 逻辑与 | \[ 1 -eq 1 -a 1 -ne 0 ]         [ 1 -eq 1 ] && [ 1 -ne 0 ]   |
| -o 和 \|\| | 逻辑或 | \[ 1 -eq 1 -o 1 -ne 1 ]         [ 1 -eq 1 ] \|\| [ 1 -ne 1 ] |

&&	前面的表达式==为真==，才会执行后面的代码

||	 前面的表达式==为假==，才会执行后面的代码


# 二、if语句

## 1. 语法格式

### ㈠ ==if结构==

格式如下：

```shell
if [ condition ];then
		command
fi
# then前面的；可以省略
```

```powershell

if test 条件;then
	命令
fi
```
```powershell
if [[ 条件 ]];then
	命令
fi
```
```powershell
[ 条件 ] && command
```

注意if后面是有空格的

### ㈡ ==if...else结构==

```powershell
if [ condition ];then
		command1
	else
		command2
fi
```
==等价于：==
```powershell
[ 条件 ] && command1 || command2
```

**小试牛刀：**

==让用户自己输入==字符串，==如果==用户输入的是hello，请打印world，==否则==打印“请输入hello”

```powershell
#!/bin/env bash

read -p '请输入一个字符串:' str
if [ "$str" = 'hello' ];then
    echo 'world'
 else
    echo '请输入hello!'
fi
或者：
read -p '请输入一个字符串:' str
[ "$str" = 'hello' ] && echo 'world' ||  echo '请输入hello!'
```

### ㈢ ==if...elif...else结构==

```powershell
if [ condition1 ];then
		command1  	
	elif [ condition2 ];then
		command2   	
	else
		command3
fi
```

## 2. 应用案例

### ㈠ 判断两台主机是否ping通

**需求：**判断==当前主机==是否和==远程主机==是否ping通

#### ① 思路

1. 使用哪个命令实现

     `ping -c次数`

2. 根据命令的==执行结果状态==来判断是否通

   `$?`

3. 根据逻辑和语法结构来编写脚本(条件判断或者流程控制)

#### ② 落地实现

```powershell
#!/bin/env bash
# 该脚本用于判断当前主机是否和远程指定主机互通

# 交互式定义变量，让用户自己决定ping哪个主机
read -p "请输入你要ping的主机的IP:" ip

# 使用ping程序判断主机是否互通
ping -c1 $ip &>/dev/null
&>：可以将错误信息或者普通信息都重定向输出  等价于  1 > a.txt 2>&1	
if [ $? -eq 0 ];then
	echo "当前主机和远程主机$ip是互通的"
 else
 	echo "当前主机和远程主机$ip不通的"
fi

逻辑运算符
test $? -eq 0 &&  echo "当前主机和远程主机$ip是互通的" || echo "当前主机和远程主机$ip不通的"
```

### ㈡ 判断一个进程是否存在

**需求：**判断web服务器中mysql进程是否存在

#### ① 思路

1. 查看进程的相关命令   ps  或者  pgrep

   ```shell
   ps -ef | grep mysql | grep -v grep  #去掉grep这个进程
   或者
   pgrep mysql
   ```

2. 根据命令的返回状态值来判断进程是否存在

3. 根据逻辑用脚本语言实现

#### ② 落地实现

```powershell
#!/bin/env bash
# 判断一个程序(httpd)的进程是否存在
pgrep mysql &>/dev/null
if [ $? -ne 0 ];then
	echo "当前httpd进程不存在"
else
	echo "当前httpd进程存在"
fi

或者
test $? -eq 0 && echo "当前httpd进程存在" || echo "当前httpd进程不存在"
```

#### ③ 补充命令

```powershell
pgrep命令：以名称为依据从运行进程队列中查找进程，并显示查找到的进程id
选项
-o：仅显示找到的最小（起始）进程号;
-n：仅显示找到的最大（结束）进程号；
-l：显示进程名称；
-P：指定父进程号；pgrep -p 4764  查看父进程下的子进程id
-g：指定进程组；
-t：指定开启进程的终端；
-u：指定进程的有效用户ID。
```

### ㈢ 判断一个服务是否正常

**需求：**判断门户网站是否能够正常访问

#### ① 思路

1. 可以判断进程是否存在，用/etc/init.d/httpd status判断状态等方法

2. 最好的方法是==直接去访问==一下，通过访问成功和失败的返回值来判断,可以用以下命令：

   `wget` 

    `curl `

    `elinks -dump`

#### ② 落地实现

```powershell
#!/bin/env bash
# 判断门户网站是否能够正常提供服务

read -p "请输入需要检查的ip或域名：" web_server

#所下载网页的保存路径
pre_dir=/home/eleven/shell_demo/

wget -P ${pre_dir} $web_server &> /dev/null

if [ $? -eq 0 ];then
        echo "is ok"
        #删除下载下来的网页文件
        rm -f ${pre_dir}/*.html && echo "delete complect" || "delete failure"
else
        echo "is failure"
fi
```

### ㈠ 判断用户是否存在

**需求1：**输入一个用户，用脚本判断该用户是否存在

```powershell
 #!/bin/env bash
# 判断 用户（id） 是否存在
read -p "输入壹个用户：" id
id $id &> /dev/null
if [ $? -eq 0 ];then
        echo "该用户存在"
else
        echo "该用户不存在"
fi
```

### ㈢ 判断当前主机的内核版本

**需求3：**判断当前内核主版本是否为2，且次版本是否大于等于6；如果都满足则输出当前内核版本

```powershell
思路：
1. 先查看内核的版本号	uname -r
2. 先将内核的版本号保存到一个变量里，然后再根据需求截取出该变量的一部分：主版本和次版本
3. 根据需求进步判断

#!/bin/bash
kernel=`uname -r`
var1=`echo $kernel|cut -d. -f1`
var2=`echo $kernel|cut -d. -f2`
test $var1 -eq 2 -a $var2 -ge 6 && echo $kernel || echo "当前内核版本不符合要求"
或者
[ $var1 -eq 2 -a $var2 -ge 6 ] && echo $kernel || echo "当前内核版本不符合要求"
或者
[[ $var1 -eq 2 && $var2 -ge 6 ]] && echo $kernel || echo "当前内核版本不符合要求"

或者
#!/bin/bash
kernel=`uname -r`
test ${kernel:0:1} -eq 2 -a ${kernel:2:1} -ge 6 && echo $kernel || echo '不符合要求'

其他命令参考：
uname -r|grep ^2.[6-9] || echo '不符合要求'
```

# 一、case语句

===java的switch==

## 1. 语法结构

~~~powershell
case var in             定义变量;var代表是变量名
v1|v2|v3)               用 | 分割多个模式，相当于or
    command1            需要执行的语句
    ;;                  两个分号代表命令结束
v4)
    command2
    ;;
v5|v6)
    command3
    ;;
*)            不满足以上模式，默认执行*)下面的语句
    command4
    ;;
esac					esac表示case语句结束
~~~

## 2. 案例

### ㈠ 脚本传不同值做不同事

**具体需求：**当给程序传入start、stop、restart三个不同参数时分别执行相应命令

~~~powershell
#!/bin/env bash  这样看比较舒服
case $1 in
	start|S)
        service apache start &>/dev/null && echo "apache 启动成功";;
	stop|T)
        service apache stop &>/dev/null && echo "apache 停止成功";;
    restart|R)
        service apache restart &>/dev/null && echo "apache 重启完毕";;
    *)
        echo "请输入要做的事情...";;
esac
~~~

### ㈡ 根据用户需求选择做事

**具体需求：**

脚本提示让用户输入需要管理的服务名，然后提示用户需要对服务做什么操作，如启动，关闭等操作

```powershell
#!/bin/env bash
read -p "请输入你要管理的服务名称(vsftpd):" service
case $service in
	vsftpd|ftp)
        read -p "请选择你需要做的事情(restart|stop):" action
        case $action in
			stop|S)
			    service vsftpd stop &>/dev/null && echo "该$serivce服务已经停止成功"
                ;;
            start)
                service vsftpd start &>/dev/null && echo "该$serivce服务已经成功启动"
                ;;
        esac
        ;;
    httpd|apache)
        echo "apache hello world"
        ;;
    *)
    	echo "请输入你要管理的服务名称(vsftpd)"
        ;;
esac
```

###㈢ 菜单提示让用户选择需要做的事

**具体需求：**

模拟一个多任务维护界面;当执行程序时先显示总菜单，然后进行选择后做相应维护监控操作

```powershell
**********请选择*********
h	显示命令帮助
f	显示磁盘分区
d	显示磁盘挂载
m	查看内存使用
u	查看系统负载
q	退出程序
*************************
```

**思路：**

1. 菜单打印出来
2. 交互式让用户输入操作编号，然后做出相应处理

**落地实现：**

1. 菜单打印(分解动作)

```powershell
#!/bin/env bash
cat <<-EOF
	h	显示命令帮助
	f	显示磁盘分区
	d	显示磁盘挂载
	m	查看内存使用
	u	查看系统负载
	q	退出程序
	EOF
```

2. 最终实现

~~~powershell
#!/bin/bash
#打印菜单
cat <<-EOF
	h	显示命令帮助
	f	显示磁盘分区
	d	显示磁盘挂载
	m	查看内存使用
	u	查看系统负载
	q	退出程序
	EOF

#让用户输入需要的操作
while true
do
read -p "请输入需要操作的选项[f|d]:" var1
case $var1 in
	h)
	cat <<-EOF
        h       显示命令帮助
        f       显示磁盘分区
        d       显示磁盘挂载
        m       查看内存使用
        u       查看系统负载
        q       退出程序
	EOF
	;;
	f)
	fdisk -l
	;;
	d)
	df -h
	;;
	m)
	free -m
	;;
	u)
	uptime
	;;
	q)
	exit
	;;
esac
done



#!/bin/bash
#打印菜单
menu(){
cat <<-END
	h	显示命令帮助
	f	显示磁盘分区
	d	显示磁盘挂载
	m	查看内存使用
	u	查看系统负载
	q	退出程序
	END
}
menu
while true
do
read -p "请输入你的操作[h for help]:" var1
case $var1 in
	h)
	menu
	;;
	f)
	read -p "请输入你要查看的设备名字[/dev/sdb]:" var2
	case $var2 in
		/dev/sda)
		fdisk -l /dev/sda
		;;
		/dev/sdb)
		fdisk -l /dev/sdb
		;;
	esac
	;;
	d)
	lsblk
	;;
	m)
	free -m
	;;
	u)
	uptime
	;;
	q)
	exit
	;;
esac
done

~~~

