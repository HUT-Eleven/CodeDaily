---
typora-copy-images-to: pictures
typora-root-url: ..\pictures
---

# 一、条件判断语法结构

##1. ==条件判断语法格式==

- 格式1： ==**test**== 条件表达式
- 格式2： **[** 条件表达式 ]   
- 格式3： **[[** 条件表达式 ]] 

**特别说明：**

1）==[==    ==]== 和==[[==    ==]]==两边都有空格

2）更多判断，`man test`去查看，很多的参数都用来进行条件判断

## 2. 条件判断相关参数

==以下所有都可以用`man test`辅助记忆==

### ㈠ ==判断文件类型==

| 判断参数 | 含义                                         |
| -------- | -------------------------------------------- |
| ==-e==   | 判断文件是否存在（任何类型文件）             |
| -f       | 判断文件是否存在==并且==是一个普通文件       |
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

| 判断参数 | 含义     |
| -------- | -------- |
| -eq      | 相等     |
| -ne      | 不等     |
| -gt      | 大于     |
| -lt      | 小于     |
| -ge      | 大于等于 |
| -le      | 小于等于 |

==注意：还可以用>,<,,>=,<=...来比较==
- 数值比较

```powershell
# [ $(id -u) -eq 0 ] && echo "the user is admin"
$ [ $(id -u) -ne 0 ] && echo "the user is not admin"

# uid=`id -u`
# test $uid -eq 0 && echo this is admin
```

- 数值比较

```powershell
注意：在(( ))中，=表示赋值；==表示判断
# ((1==2));echo $?
# ((1<2));echo $?
# ((2>=1));echo $?
# ((2!=1));echo $?
# ((`id -u`==0));echo $?
 
# ((a=123));echo $a
# unset a
# ((a==123));echo $?
```

### ㈤ ==判断字符串==

| 判断参数           | 含义                                            |
| ------------------ | ----------------------------------------------- |
| -z                 | 判断是否为==空==字符串，字符串长度为0则成立     |
| -n                 | 判断是否为==非空==字符串，字符串长度不为0则成立 |
| string1 = string2  | 判断字符串是否相等, ==等号两边需空格==          |
| string1 != string2 | 判断字符串是否相不等                            |

### ㈥ ==&&  ||==

| 判断符号   | 含义   | 举例                                                         |
| ---------- | ------ | ------------------------------------------------------------ |
| -a 和 &&   | 逻辑与 | \[ 1 -eq 1 -a 1 -ne 0 ]         [ 1 -eq 1 ] && [ 1 -ne 0 ]   |
| -o 和 \|\| | 逻辑或 | \[ 1 -eq 1 -o 1 -ne 1 ]         [ 1 -eq 1 ] \|\| [ 1 -ne 1 ] |

**==特别说明：==**

&&	前面的表达式==为真==，才会执行后面的代码

||	 前面的表达式==为假==，才会执行后面的代码

;        ==只==用于==分割==命令或表达式

==shell中&&和||没有优先级之分，从左往右依次看==

**① 举例说明**


- 字符串比较

  ==注意：双引号引起来，看作一个整体；= 和 == 在 [ 字符串 ] 比较中都表示判断==

```powershell
# a='hello world';b=world
# [ $a = $b ];echo $?
# [ "$a" = "$b" ];echo $?
# [ "$a" != "$b" ];echo $?

# [ "$a" == "$b" ];echo $?
# test "$a" != "$b";echo $?


test  表达式
[ 表达式 ]
[[ 表达式 ]]

思考：[ ] 和 [[ ]] 有什么区别？

# a=
# test -z $a;echo $?
# a=hello
# test -z $a;echo $?
# test -n $a;echo $?
# test -n "$a";echo $?

# [ '' = $a ];echo $?
-bash: [: : unary operator expected
2
# [[ '' = $a ]];echo $?
0


# [ 1 -eq 0 -a 1 -ne 0 ];echo $?
# [ 1 -eq 0 && 1 -ne 0 ];echo $?
# [[ 1 -eq 0 && 1 -ne 0 ]];echo $?
```

# 二、流程控制语句

## 1. 基本语法结构

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

  1 #!/bin/env bash
  2
  3 read -p "请输入一个字符串:" str
  4 if [ "$str" = "hello" ]
  5 then
  6     echo world
  7 else
  8     echo "请输入hello!"
  9 fi

#!/bin/env bash

A=hello
B=world
C=hello

if [ "$1" = "$A" ];then
        echo "$B"
    else
        echo "$C"
fi


read -p '请输入一个字符串:' str;
 [ "$str" = 'hello' ] && echo 'world' ||  echo '请输入hello!'
```

### ㈢ ==if...elif...else结构==

```powershell
if [ condition1 ];then
		command1  	结束
	elif [ condition2 ];then
		command2   	结束
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
#&>/dev/null：表示输出的结果不要了，直接扔到null中
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

### ㈡ 判断软件包是否安装

**需求2：**用脚本判断一个软件包是否安装，如果没安装则安装它（假设本地yum已配合）

```powershell

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

