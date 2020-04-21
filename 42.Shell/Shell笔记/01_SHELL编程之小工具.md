---
typora-copy-images-to: ../pictures
typora-root-url: ..\pictures
---

# 《工具篇》

#一、文本处理工具

##==1. grep工具==

grep是==**行过滤**==工具；用于根据关键字进行行过滤

**语法：**

```powershell
# grep [选项] '关键字' 文件名
```

**常见选项：**

~~~powershell
OPTIONS:
    -i: 不区分大小写
    -v: 查找不包含指定内容的行,反向选择
    -w: 按单词搜索
    -o: 打印匹配关键字
    -c: 统计匹配到的行数
    -n: 显示行号
    -r: 逐层遍历目录查找
    -A: 显示匹配行及后面多少行	
    -B: 显示匹配行及前面多少行
    -C: 显示匹配行前后多少行
    -l：只列出匹配的文件名
    -L：列出不匹配的文件名
    -E:使用扩展正则匹配
    ^key:以关键字开头
    key$:以关键字结尾
    ^$:匹配空行
    --color=auto ：可以将找到的关键词部分加上颜色的显示
~~~

**颜色显示（别名设置）：**

```powershell
临时设置：
# alias grep='grep --color=auto'			//只针对当前终端和当前用户生效

永久设置：
1）全局（针对所有用户生效）
vim /etc/bashrc
alias grep='grep --color=auto'
source /etc/bashrc

2）局部（针对具体的某个用户）
vim ~/.bashrc
alias grep='grep --color=auto'
source ~/.bashrc
```

**举例说明：**

```powershell
# grep -i root passwd						忽略大小写匹配包含root的行
# grep -v root passwd						匹配不包含root的行
# grep -w ftp passwd 						精确匹配ftp单词的行
# grep -r ftp passwd 						逐层遍历目录查找
# grep -o ftp passwd 						打印匹配到的关键字ftp
# grep -n root passwd 						显示行号
# grep -c root passwd						统计匹配的总行数
# grep ^root passwd 						以root开头的行
# grep bash$ passwd 						以bash结尾的行
# grep -n ^$ passwd 						匹配空行并打印行号
# grep -A 5 mail passwd 				 	匹配包含mail关键字及其后5行
# grep -B 5 mail passwd 				 	匹配包含mail关键字及其前5行
# grep -C 5 mail passwd 					匹配包含mail关键字及其前后5行
```

##==2. cut工具==

cut是==**列截取**==工具，分隔符必须是单个字符。

**语法：**

```powershell
# cut 选项  文件名
```

**常见选项：**

```powershell
-c:	以**字符**为单位进行分割,截取
-d:	**自定义**分隔符，默认为制表符\t  注意-d紧连字符，不能空格
-f:	与-d一起使用，指定截取哪个区域
```

**举例说明:**

~~~powershell
# cut -d: -f1 1.txt 			以:冒号分割，截取第1列内容
# cut -d: -f1,6,7 1.txt 	以:冒号分割，截取第1,6,7列内容
# cut -c4 1.txt 				截取文件中每行第4个字符
# cut -c4-10 1.txt 			截取文件中每行的4-10个字符
# cut -c5- 1.txt 				从第5个字符开始截取后面所有字符
~~~

**课堂练习：**
用小工具列出你当系统的运行级别。5/3

1. 如何查看系统运行级别
   - 命令`runlevel`
   - 文件`/etc/inittab`
2. 如何过滤运行级别

```powershell
runlevel |cut -c3
runlevel | cut -d ' ' -f2
grep -v '^#' /etc/inittab | cut -d: -f2
grep '^id' /etc/inittab |cut -d: -f2
grep "initdefault:$" /etc/inittab | cut -c4
grep -v ^# /etc/inittab |cut -c4
grep 'id:' /etc/inittab |cut -d: -f2
cut -d':' -f2 /etc/inittab |grep -v ^#
cut -c4 /etc/inittab |tail -1
cut -d: -f2 /etc/inittab |tail -1
```



## ==3. sort工具==

> 文件内容排序，
> 注：不改变源文件;默认按ASCII码比较。

```powershell
-u ：unique,去除重复行
-r ：reverse,降序排列，默认是升序
-o : output,将排序结果输出到文件中,类似重定向符号>
-n ：number,以数字排序，默认是按字符排序
-t ：分隔符
-k ：第N列， -t' ' -k 1  以空格分隔，取第一列
-b ：忽略前导空格。
-R ：随机排序，每次运行的结果均不同
-f ：igonre case
```

**举例说明**

~~~powershell
# sort -n -t: -k3 1.txt 			按照用户的uid进行升序排列
# sort -nr -t: -k3 1.txt 			按照用户的uid进行降序排列
# sort -n 2.txt 						按照数字排序
# sort -nu 2.txt 						按照数字排序并且去重
# sort -nr 2.txt 
# sort -nru 2.txt 
# sort -nru 2.txt 
# sort -n 2.txt -o 3.txt 			按照数字排序并将结果重定向到文件
# sort -R 2.txt 
# sort -u 2.txt 
~~~

##4.uniq工具

> uniq用于**去除文件连续重复行，不修改源文件**

~~~powershell
常见选项：
-i: ignore case
-c: 统计重复行次数
-d: 只显示重复行

举例说明：
# uniq 2.txt 
# uniq -d 2.txt 
# uniq -dc 2.txt 
~~~

## ==5.tee工具==

> 双向覆盖重定向（屏幕输出|文本输入）

~~~powershell
选项：
-a append追加

# echo hello world|tee file1
# echo 999|tee -a file1
~~~

## ==6.diff工具==

> diff工具用于逐行比较文件的不同,也可用于对比目录下文件差异

注意：diff的描述是告诉我们**怎样改变第一个**文件成为==与第二个文件匹配==。

**语法：**

```powershell
diff [选项] srcFile targetFile
```

| 选项   | 含义                               |
| ------ | ---------------------------------- |
| -b     | 不检查空格                         |
| -B     | 不检查空白行                       |
| -i     | 不检查大小写                       |
| -w     | 忽略所有的空格                     |
| ==-c== | 上下文格式显示                     |
| ==-u== | 合并格式显示                       |
| ==-q== | 对比目录下文件区别，不对比文件内容 |

**举例说明：**

- 文件准备：

```powershell
# vim file1
aaaa
111
hello world
222
333
bbb
#
# vim file2
aaa
hello
111
222
bbb
333
world
```

1）正常显示

```powershell
diff目的：file1如何改变才能和file2匹配
# diff file1 file2
1c1,2					第一个文件的第1行需要改变(c=change)才能和第二个文件的第1到2行匹配			
< aaaa				小于号"<"表示左边文件(file1)文件内容
---					---表示分隔符
> aaa					大于号">"表示右边文件(file2)文件内容
> hello
3d3					第一个文件的第3行删除(d=delete)后才能和第二个文件的第3行匹配
< hello world
5d4					第一个文件的第5行删除后才能和第二个文件的第4行匹配
< 333
6a6,7					第一个文件的第6行增加(a=add)内容后才能和第二个文件的第6到7行匹配
> 333					需要增加的内容在第二个文件里是333和world
> world
```

2）上下文格式显示（推荐）

```powershell
# diff -c file1 file2
前两行主要列出需要比较的文件名和文件的时间戳；文件名前面的符号***表示file1，---表示file2
*** file1       2019-04-16 16:26:05.748650262 +0800
--- file2       2019-04-16 16:26:30.470646030 +0800
***************	我是分隔符
*** 1,6 ****		以***开头表示file1文件，1,6表示1到6行
! aaaa				!表示该行需要修改才与第二个文件匹配
  111
- hello world		-表示需要删除该行才与第二个文件匹配
  222
- 333					-表示需要删除该行才与第二个文件匹配
  bbb
--- 1,7 ----		以---开头表示file2文件，1,7表示1到7行
! aaa					表示第一个文件需要修改才与第二个文件匹配
! hello				表示第一个文件需要修改才与第二个文件匹配
  111
  222
  bbb
+ 333					表示第一个文件需要加上该行才与第二个文件匹配
+ world				表示第一个文件需要加上该行才与第二个文件匹配

```

3）合并格式显示（推荐）

```powershell
# diff -u file1 file2
前两行主要列出需要比较的文件名和文件的时间戳；文件名前面的符号---表示file1，+++表示file2
--- file1       2019-04-16 16:26:05.748650262 +0800
+++ file2       2019-04-16 16:26:30.470646030 +0800
@@ -1,6 +1,7 @@
-aaaa
+aaa
+hello
 111
-hello world
 222
-333
 bbb
+333
+world
```

- 比较两个**目录不同**

```powershell
默认情况下也会比较两个目录里相同文件的内容
# diff dir1 dir2
diff dir1/file1 dir2/file1
0a1
> hello
Only in dir1: file3
Only in dir2: test1
如果只需要比较两个目录里文件的不同，不需要进一步比较文件内容，需要加-q选项
# diff -q dir1 dir2
Files dir1/file1 and dir2/file1 differ
Only in dir1: file3
Only in dir2: test1

```

**其他小技巧：**

有时候我们需要以一个文件为标准，去修改其他文件，并且修改的地方较多时，我们可以通过打补丁的方式完成。

```powershell
1）先找出文件不同，然后输出到一个文件
# diff -uN file1 file2 > file.patch
-u:上下文模式
-N:将不存在的文件当作空文件(可不用)
2）将不同内容打补丁到文件
# patch file1 file.patch
patching file file1
3）测试验证
# diff file1 file2
```

## 7. paste工具

> 用于逐行合并文件

~~~powershell
常用选项：
-d：自定义间隔符，默认是tab
-s：横行处理，非并行
~~~

##8. tr工具

>  替换和删除字符，
>  注意：不会修改源文件

**语法：**

```powershell
用法1：命令的执行结果交给tr处理，其中string1用于查询，string2用于替换
# commands|tr  'string1'  'string2'
用法2：tr处理的内容来自文件，记住要使用"<"标准输入
# tr  'string1'  'string2' < filename

用法3：匹配string1进行相应操作，如删除操作
# tr [options] 'string1' < filename
```

**常用选项：**

```powershell
-d 删除匹配字符串。
-s 删除所有重复出现字符序列，只保留第一个；即将重复出现字符串压缩为一个字符串
```

**常匹配字符串：**

| 字符串             | 含义                 | 备注                                                         |
| ------------------ | -------------------- | ------------------------------------------------------------ |
| ==a-z==或[:lower:] | 匹配所有小写字母     | [a-zA-Z0-9]                                                  |
| ==A-Z==或[:upper:] | 匹配所有大写字母     |                                                              |
| ==0-9==或[:digit:] | 匹配所有数字         |                                                              |
| [:alnum:]          | 匹配所有字母和数字   |                                                              |
| [:alpha:]          | 匹配所有字母         |                                                              |
| [:blank:]          | 所有水平空白         |                                                              |
| [:punct:]          | 匹配所有标点符号     |                                                              |
| [:space:]          | 所有水平或垂直的空格 |                                                              |

**举例说明：**

~~~powershell
# cat 3.txt 	自己创建该文件用于测试
ROOT:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin
boss02:x:516:511::/home/boss02:/bin/bash
vip:x:517:517::/home/vip:/bin/bash
stu1:x:518:518::/home/stu1:/bin/bash
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
smmsp:x:51:51::/var/spool/mqueue:/sbin/nologin
aaaaaaaaaaaaaaaaaaaa
bbbbbb111111122222222222233333333cccccccc
hello world 888
666
777
999


# tr -d '[:/]' < 3.txt 				删除文件中的:和/
# cat 3.txt |tr -d '[:/]'			删除文件中的:和/
# tr '[0-9]' '@' < 3.txt 			将文件中的数字替换为@符号
# tr '[a-z]' '[A-Z]' < 3.txt 		将文件中的小写字母替换成大写字母
# tr -s '[a-z]' < 3.txt 			匹配小写字母并将重复的压缩为一个
# tr -s '[a-z0-9]' < 3.txt 			匹配小写字母和数字并将重复的压缩为一个
# tr -d '[:digit:]' < 3.txt 		删除文件中的数字
# tr -d '[:blank:]' < 3.txt 		删除水平空白
# tr -d '[:space:]' < 3.txt 		删除所有水平和垂直空白

~~~

## 练习

1. 使用小工具分别截取当前主机IP；截取NETMASK；截取广播地址；截取MAC地址

~~~powershell
# ifconfig eth0|grep 'Bcast'|tr -d '[a-zA-Z ]'|cut -d: -f2,3,4
10.1.1.1:10.1.1.255:255.255.255.0
# ifconfig eth0|grep 'Bcast'|tr -d '[a-zA-Z ]'|cut -d: -f2,3,4|tr ':' '\n'
10.1.1.1
10.1.1.255
255.255.255.0
# ifconfig eth0|grep 'HWaddr'|cut -d: -f2-|cut -d' ' -f4
00:0C:29:25:AE:54
# ifconfig eth0|grep 'HW'|tr -s ' '|cut -d' ' -f5
00:0C:29:B4:9E:4E

# ifconfig eth1|grep Bcast|cut -d: -f2|cut -d' ' -f1
# ifconfig eth1|grep Bcast|cut -d: -f2|tr -d '[ a-zA-Z]'
# ifconfig eth1|grep Bcast|tr -d '[:a-zA-Z]'|tr ' ' '@'|tr -s '@'|tr '@' '\n'|grep -v ^$
# ifconfig eth0|grep 'Bcast'|tr -d [:alpha:]|tr '[ :]' '\n'|grep -v ^$
# ifconfig eth1|grep HWaddr|cut -d ' ' -f11
# ifconfig eth0|grep HWaddr|tr -s ' '|cut -d' ' -f5
# ifconfig eth1|grep HWaddr|tr -s ' '|cut -d' ' -f5
# ifconfig eth0|grep 'Bcast'|tr -d 'a-zA-Z:'|tr ' ' '\n'|grep -v '^$'
~~~

2. 将系统中所有普通用户的用户名、密码和默认shell保存到一个文件中，要求用户名密码和默认shell之间用tab键分割

~~~powershell
# grep 'bash$' passwd |grep -v 'root'|cut -d: -f1,2,7|tr ':' '\t' |tee abc.txt
~~~

# 二、bash的特性

> 什么是shell和bash?
>
> shell：用户与系统内核交互的界面，即“命令行”界面
> bash：全称Bourne-Again shell，是shell中一种，是Linux中默认的shell，诸如还有C shell（csh）

##2、常见的快捷键

~~~powershell
^即ctrl
^z	  			将前台运行的程序挂起到后台
^d   			退出 等价exit
^l   			清屏 
^a or home  	光标移到命令行的最前端
^e or end  		光标移到命令行的后端
^u   			删除光标前所有字符
^k   			删除光标后所有字符
^r	 			搜索历史命令
~~~

##3 、常用的通配符（重点）

~~~powershell
*:	匹配0或多个任意字符
?:	匹配任意单个字符
[list]:	匹配[list]中的任意单个字符,或者一组单个字符   [a-z]
[!list]: 反向选择
{string1,string2,...}：匹配string1,string2或更多字符串
~~~

##4、bash中的引号（重点）

- 双引号""   :会把引号的内容当成整体来看待，==允许通过$符号引用其他变量值==
- 单引号''     :会把引号的内容当成整体来看待，==禁止引用其他变量值==，shell中特殊符号都被视为普通字符
- 反撇号``  :等于==$()==，引号或括号里的命令会优先执行，如果存在嵌套，反撇号不能用，推荐用\$()

~~~powershell
# echo "$(hostname)"
server
# echo '$(hostname)'
$(hostname)

# echo $(date +%F' '%T)
2020-02-29 14:51:15
# echo `date +%F`
2018-11-22
# echo `echo `date +%F``
date +%F
# echo $(echo `date +%F`)
2018-11-22
~~~

# 变量篇

# 一、SHELL介绍

**前言：**

计算机只能认识（识别）机器语言(0和1)，如（11000000 这种）。但是，我们的程序猿们不能直接去写01这样的代码，所以，要想将程序猿所开发的代码在计算机上运行，就必须找"人"（工具）来翻译成机器语言，这个"人"(工具)就是我们常常所说的**编译器**或者**解释器**。

![编译和解释型语言区别](/编译和解释型语言区别.png)

##1. 编程语言分类

- **编译型语言：**

​    程序在执行之前需要一个专门的编译过程，把程序编译成为机器语言文件，运行时不需要重新翻译，直接使用编译的结果就行了。程序执行效率高，依赖编译器，跨平台性差些。如C、C++、java

- **解释型语言：**

​    程序不需要编译，程序在运行时由**==解释器==**翻译成机器语言，每执行一次都要翻译一次。因此效率比较低。比如Python/JavaScript/ Perl /ruby/==Shell==等都是解释型语言。

![./语言分类](语言分类.png)

- **总结**

编译型语言比解释型语言==速度较快==，但是不如解释型语言==跨平台性好==。如果做底层开发或者大型应用程序或者操作系开发一==般都用编译型语言==；如果是一些服务器脚本及一些辅助的接口，对速度要求不高、对各个平台的==兼容性有要求==的话则一般都用==解释型语言==。

##2. shell简介

![00_shell介绍](/00_shell介绍.png)

**总结：**

- **shell就是人机交互的一个桥梁,终端**
- shell的种类

~~~powershell
# cat /etc/shells 
/bin/sh				#是bash的一个快捷方式  == bash
/bin/bash			#bash是大多数Linux默认的shell，包含的功能几乎可以涵盖shell所有的功能
/sbin/nologin		#表示非交互，不能登录操作系统
/bin/dash			#小巧，高效，功能相比少一些

/bin/csh			#具有C语言风格的一种shell，具有许多特性，但也有一些缺陷
/bin/tcsh			#是csh的增强版，完全兼容csh
~~~

**思考：终端和shell有什么关系？**  

答：终端即shell

![01_shell介绍](./01_shell介绍.png)

##3. shell脚本

### ㈥ shell脚本的基本写法

1）**脚本第一行**，魔法字符`#!`指定解释器

`#!/bin/bash`  ==表示以下内容使用/bin/bash解释器解析==

**注意：**
如果直接将解释器路径写死在脚本里，可能在某些系统就会存在找不到解释器的兼容性问题，所以可以使用:`#!/bin/env bash`

==2）**脚本第二部分**，注释==

3）**脚本第三部分**，脚本要实现的具体代码内容

~~~powershell
#!/bin/env bash

# 以下内容是对脚本的基本信息的描述
# Name: 名字
# Desc:描述describe
# Path:存放路径
# Usage:用法
# Update:更新时间

#下面就是脚本的具体内容
commands
...
~~~



### ㈦ shell脚本的执行方法

1. ` ./first_shell.sh`（标准脚本执行方法,建议）
2. 直接指定解释器执行

```powershell
# bash first_shell.sh
# sh first_shell.sh

-x:一般用于排错，查看脚本的执行过程
# bash -x first_shell.sh
-n:用来查看脚本的语法是否有问题
```

3. 使用`source`命令读取脚本文件,执行文件里的代码

```shell
# source first_shell.sh  也等于 . first_shell.sh 
```

# 二、变量
## ==1. 定义变量的方式==

注：==等号两边不能有空格，shell中只有变量定义的时候=两边是不需要空格，其他时候都需要==

### ㈠ 基本方式

**变量名=变量值** 

```sh
# A=hello			定义变量A
# A="hello world"	#对于有空格的字符串给变量赋值时，要用引号引起来
# A='hello world'
# unset A			取消变量
```

### ㈡ 命令执行结果赋值给变量

```powershell
# B=`date +%F`
# C=$(uname -r)
# echo $C
2.6.32-696.el6.x86_64  --> 内核版本
```

### ㈢ 交互式定义变量(read)

**语法：**`read [选项] 变量名`

**常见选项：**

| 选项 | 释义                                                       |
| ---- | ---------------------------------------------------------- |
| -p   | 定义提示用户的信息                                         |
| -n   | 定义字符数（限制变量值的长度）                             |
| -s   | 不显示用户输入的内容                             |
| -t   | 定义超时时间，默认单位为秒（限制用户输入变量值的超时时间） |

**举例说明：**

```powershell
用法1：用户自己定义变量值
# read -p "Input your name:" name
Input your name:tom
# echo $name
tom

用法2：变量值来自文件
# cat 1.txt 
10.1.1.1 255.255.255.0

# read ip mask < 1.txt 
# echo $ip
10.1.1.1
# echo $mask
255.255.255.0
```

### ㈣ 定义有类型的变量(declare)

默认情况下，shell中的变量时没有类型的。

**目的：**给变量做一些限制，固定变量的类型，比如：整型、只读

**用法：**`declare 选项 变量名=变量值`

**常用选项：**

| 选项   | 释义                       | 举例                                         |
| ------ | -------------------------- | -------------------------------------------- |
| ==-i== | 将变量看成整数             | declare -i A=123                             |
| ==-r== | 定义只读变量               | declare -r B=hello                           |
| -a     | 定义普通数组；查看普通数组 |                                              |
| -A     | 定义关联数组；查看关联数组 |                                              |
| ==-x== | 定义环境变量               | declare -x AAA=123456 等于 export AAA=123456 |

**举例说明：**

```powershell
# declare -i A=123
# echo $A
123
# A=hello	#整数型，赋值字符串，=0
# echo $A
0

# declare -r B=hello
# echo $B
hello
# B=world
-bash: B: readonly variable
# unset B
-bash: unset: B: cannot unset: readonly variable
```

## 2. 变量的定义规则

㈠ 变量名区分大小写

㈡ 变量名不能有特殊符号(*?@#)

㈢ 变量名不能以数字开头

```powershell
# *A=hello
-bash: *A=hello: command not found
# ?A=hello
-bash: ?A=hello: command not found
# @A=hello
-bash: @A=hello: command not found
```

## 3.调用变量

==`$A	和	echo ${A}`==

```powershell
${}可以截取变量中一部分
# echo ${A:2:4}		表示从A变量中第3个字符开始截取，截取4个字符
```


## ==6. 变量作用域==

### ㈠ 本地变量

- **==本地变量==**：当前用户自定义的变量。当前进程中有效，其他进程及**当前进程的子进程无效**。

  ```sh
  /bin/bash # 在当前进程下开一个子进程  exit可退出当前进程
  ps -auxf |grep bash # 查看进程父子关系
  ```

![image-20200328215035153](/image-20200328215035153.png)

### ㈡ 环境变量

- **环境变量**：当前进程有效，**并且能够被子进程调用**。

  - `export 定义环境变量`

  - `env`查看当前用户的环境变量
  - `set`查询当前用户的所有变量(本地变量与环境变量) 


~~~sh
export A=hello
env|grep ^A

永久生效：
vim /etc/profile 或者 ~/.bashrc

说明：系统中有一个变量PATH，环境变量
export PATH=/usr/local/mysql/bin:$PATH
~~~

### ㈢ 全局变量


- **全局变量**：所有进程都能调用

- **解读相关配置文件**

  /etc下全局，~/下是全局

| 文件名          | 说明                                   | 备注                                                       |
| --------------- | -------------------------------------- | ---------------------------------------------------------- |
| $HOME/.bashrc   | 当前用户的bash信息,用户**登录**时读取  | 定义别名、umask、函数等                                    |
| ~/.bash_profile | 当前用户的环境变量，用户**登录**时读取 |                                                            |
| ~/.bash_logout  | 当前用户**退出**当前shell时最后读取    | 定义用户退出时执行的程序等                                 |
| /etc/bashrc     | 全局的bash信息，所有用户都生效         | bash run config                                            |
| /etc/profile    | 全局环境变量信息                       | 系统和所有用户都生效                                       |
| ~/.bash_history | 用户的历史命令                         | history -w   保存历史记录         history -c  清空历史记录 |

**说明：**以上文件修改后，都需要重新==source==让其生效或者退出重新登录。

- **用户登录**系统**读取**相关==文件的顺序==
  1. `/etc/profile`
  2. `$HOME/.bash_profile`
  3. `$HOME/.bashrc`
  4. `/etc/bashrc`
  5. `$HOME/.bash_logout`

### ㈣ 系统变量

- **系统变量(内置bash中变量)** ： shell本身已经固定好了它的名字和作用.

| 内置变量     | 含义                                                         |
| ------------ | ------------------------------------------------------------ |
| $?           | 上一条命令执行后返回的状态；状态值为0表示执行正常，==非0==表示执行异常或错误 |
| $0           | 当前执行的程序或脚本名                                       |
| $#           | 脚本后面接的参数的==个数==                                   |
| $*           | 脚本后面==所有参数==，==参数当成一个整体输出==，每一个变量参数之间以空格隔开 |
| $@           | 脚本后面==所有参数==，==参数是独立的==，也是全部输出         |
| \$1\~$9      | 脚本后面的==位置参数==，$1表示第1个位置参数，依次类推        |
| \${10}\~${n} | 扩展位置参数,第10个位置变量必须用{}大括号括起来(2位数字以上扩起来) |
| ==$$==       | 当前所在进程的进程号，如`echo $$`                            |
| $！          | 后台运行的最后一个进程号 (当前终端）                         |
| !$           | 调用最后一条命令历史中的==参数==                             |

- 案例

```powershell
#!/bin/bash
#了解shell内置变量中的位置参数含义
echo "\$0 = $0"
echo "\$# = $#"
echo "\$* = $*"
echo "\$@ = $@"
echo "\$1 = $1" 
echo "\$2 = $2" 
echo "\$3 = $3" 
echo "\$11 = ${11}" 
echo "\$12 = ${12}" 
echo "\$$ = $$" 
```

- 进一步了解\$*和​\$@的区别

`$*`：表示将变量看成一个整体
`$@`：表示变量是独立的

```powershell
#!/bin/bash
for i in "$@"
do
echo $i
done

echo "======我是分割线======="

for i in "$*"
do
echo $i
done

# bash 3.sh a b c
a
b
c
======我是分割线=======
a b c
```

# 三、简单四则运算

==默认情况下，shell就只能支持简单的整数运算==

运算内容：加(+)、减(-)、乘(*)、除(/)、求余数（%）

## 1. 表达式

| 表达式  | 举例          |
| ------- | ------------- |
| $((  )) | echo $((1+1)) |
| $[ ]    | echo $[10-5]  |

另外两个计算的命令：

`expr`:expr 10 / 5  expr 10 \\* 5 (==符号左右需空格，expr表达式的格式，*需要转移义)

`let 用于计算变量，所以前提是要先定义变量`:n=1;let n+=1  等价于  let n=$n+1    (\$可省略)，==let 使用较多==

==备注：==
==$() = ``== ：执行命令
==\$A=\${A}== ： 引用变量
==\$(())=\$[]==：运算表达式

# 四、数组

## 1. 数组定义

### ㈠ 数组分类

- ==普通数组==：只能使用整数作为数组索引
- ==关联数组==：可以使用字符串/整数作为数组索引

### ㈡ 普通数组定义

- 一次赋予一个值

```powershell
array[0]=v1
array[1]=v2
array[2]=v3
array[3]=v4
```

- 一次赋予多个值

```powershell
数组名=(值1 值2 值3 ...)

array1=(`cat /etc/passwd`)			将文件中每一行赋值给array1数组
array2=($(ls /root))
array3=(harry amy jack "Miss Hou")
array4=(1 2 3 4 "hello world" [10]=linux)
```

### ㈢ 关联数组定义

#### ①声明关联数组（可省略）

```powershell
declare -A asso_array1
declare -A asso_array2
declare -A asso_array3
```

#### ② 数组赋值

- 一次赋一个值

```powershell
数组名[索引or下标]=变量值
# asso_array1[linux]=one
# asso_array1[java]=two
# asso_array1[2]=three
```

- 一次赋多个值

```powershell
# asso_array2=([name1]=harry [name2]=jack [name3]=amy [name4]="Miss Hou")
```

- 其他定义方式

```powershell
# declare -A books
# let books[linux]++
# declare -A|grep books
declare -A books='([linux]="1" )'
# let books[linux]++
# declare -A|grep books
declare -A books='([linux]="2" )'
```

### ㈣ 数组的读取

```powershell
${数组名[元素下标]}

echo ${array[0]}			获取数组里第一个元素，关联数组还可以用string
echo ${array[*]}			获取数组里的所有元素
echo ${#array[*]}			获取数组里所有元素个数
echo ${!array[@]}    	获取数组元素的索引下标
echo ${array[@]:1:2}    访问指定的元素；1代表从下标为1的元素开始获取；2代表获取后面几个元素

# declare -a	查看所有普通数组
# declare -A	查看所有关联数组
```

### 

# 五. 其他常用小命令

- `dirname ： 取出目录`
- `basename : 取出文件` 

```powershell
# A=/root/Desktop/shell/mem.txt 
# dirname $A   取出目录
/root/Desktop/shell
# basename $A  取出文件
mem.txt
```

- 变量"内容"的删除和替换

```powershell
一个“%”代表从右往左去掉一个/key/
两个“%%”代表从右往左最大去掉/key/
一个“#”代表从左往右去掉一个/key/
两个“##”代表从左往右最大去掉/key/

举例说明：
# url=www.taobao.com
# echo ${#url}		     获取变量的长度
# echo ${url#*.}
# echo ${url##*.}
# echo ${url%.*}
# echo ${url%%.*}
```

- 以下了解，自己完成

```powershell
替换：/ 和 //
 1015  echo ${url/ao/AO}
 1017  echo ${url//ao/AO}   贪婪替换
 
替代： - 和 :-  +和:+
 1019  echo ${abc-123}
 1020  abc=hello
 1021  echo ${abc-444}
 1022  echo $abc
 1024  abc=
 1025  echo ${abc-222}

${变量名-新的变量值} 或者 ${变量名=新的变量值}
变量没有被赋值：会使用“新的变量值“ 替代
变量有被赋值（包括空值）： 不会被替代

 1062  echo ${ABC:-123}
 1063  ABC=HELLO
 1064  echo ${ABC:-123}
 1065  ABC=
 1066  echo ${ABC:-123}

${变量名:-新的变量值} 或者 ${变量名:=新的变量值}
变量没有被赋值或者赋空值：会使用“新的变量值“ 替代
变量有被赋值： 不会被替代

 1116  echo ${abc=123}
 1118  echo ${abc:=123}

# unset abc
# echo ${abc:+123}

# abc=hello
# echo ${abc:+123}
123
# abc=
# echo ${abc:+123}

${变量名+新的变量值}
变量没有被赋值或者赋空值：不会使用“新的变量值“ 替代
变量有被赋值： 会被替代
# unset abc
# echo ${abc+123}

# abc=hello
# echo ${abc+123}
123
# abc=
# echo ${abc+123}
123
${变量名:+新的变量值}
变量没有被赋值：不会使用“新的变量值“ 替代
变量有被赋值（包括空值）： 会被替代

# unset abc
# echo ${abc?123}
-bash: abc: 123

# abc=hello
# echo ${abc?123}
hello
# abc=
# echo ${abc?123}

${变量名?新的变量值}
变量没有被赋值:提示错误信息
变量被赋值（包括空值）：不会使用“新的变量值“ 替代

# unset abc
# echo ${abc:?123}
-bash: abc: 123
# abc=hello
# echo ${abc:?123}
hello
# abc=
# echo ${abc:?123}
-bash: abc: 123

${变量名:?新的变量值}
变量没有被赋值或者赋空值时:提示错误信息
变量被赋值：不会使用“新的变量值“ 替代

说明：?主要是当变量没有赋值提示错误信息的，没有赋值功能
```

---
《流程控制篇》
===

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

# 《循环篇》
# 一、==for循环语句==

## 1. 语法结构

### ㈠ ==列表循环==

> 列表for循环：用于将一组命令执行**==已知的次数==**

- **基本语法格式**

```powershell
for variable in {list}
     do
          command 
          …
     done
```
或者
```powershell
for variable in a b c
     do
         command
         …
     done
```

- **举例说明**

```powershell
# for var in {1..10};do echo $var;done
# for var in 1 2 3 4 5;do echo $var;done
# for var in $(seq 10);do echo $var;done

# for var in {0..10..2};do echo $var;done #2表示步长
# for var in {10..1..-2};do echo $var;done
# for var in `seq 10 -2 1`;do echo $var;done
```

- ==continue==：继续；表示==循环体==内下面的代码不执行，重新开始下一次循环
- ==break==：打断；马上停止执行本次循环，执行==循环体==后面的代码
- ==exit==：表示直接跳出程序
- ==shift==：使位置参数向左移动，默认移动1位，可以使用shift 2

```shell
#!/bin/bash
for i in {1..5}
do
	test $i -eq 2 && break || touch /tmp/file$i
done
echo hello hahahah
```
**shift举例说明：**

```powershell
以下脚本都能够实现用户自定义输入数字，然后脚本计算和：
#!/bin/bash
sum=0
while [ $# -ne 0 ]
do
let sum=$sum+$1
shift
done
echo sum=$sum
```

### ㈡ ==不带列表循环==

>  不带列表的for循环:==循环的是$@,隐藏了==

- 基本语法格式

```powershell
for variable
    do
        command 
        command
        …
   done
```
==其实会默认补全(用bash -x查看)==：

for var ==in $@==

- **举例说明**

```powershell
#!/bin/bash
for var
do
	echo $var
done
echo "脚本后面有$#个参数"
```

###  ㈢ ==类C风格的for循环==

- **基本语法结构**

```powershell
for (( expr1;expr2;expr3 ))	#注意是(())
	do
		command
		command
		…
	done
```

- **举例说明**

```powershell
 for (( i=1;i<=5;i++))
	do
		echo $i
	done
	
 # for ((i=1;i<=5;i++));do echo $i;done
```
## 2. 案例

### ㈠ 脚本==计算==1-100奇数和

#### ① 落地实现

```powershell
#!/bin/env bash
# 计算1-100的奇数和
# 定义变量来保存奇数和
sum=0

#for循环遍历1-100的奇数，并且相加，把结果重新赋值给sum

for i in {1..100..2}  或者 for ((i=1;i<=100;i+=2))
do
	let sum=sum+i  或者  sum=$[$i+$sum]
done
echo "1-100的奇数和是:$sum"
---------------------------

方法3：
#!/bin/bash
sum=0
for ((i=1;i<=100;i++))
do
	if [ $[$i%2] -ne 0 ];then
		let sum=$sum+$i
	fi
	或者	test $[$i%2] -ne 0 && let sum=sum+i  #let后面的变量可以不用加$
done
---------------------------

#!/bin/bash
sum=0
for ((i=1;i<=100;i++))
do
	test $[$i%2] -eq 0 && continue || let sum=sum+i
done
echo "1-100的奇数和是:$sum"

```


### ㈡ 判断所输整数是否为质数

**质数(素数)：**==只能==被1和它本身==整除==的数叫质数。
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

#### ① 思路

1. 让用户输入一个数，保存到一个变量里   `read -p "请输入一个正整数:" num`
	. 如果能被其他数整除就不是质数——>`$num%$i `是否等于0	`$i=2到$num-1`
3. 如果输入的数是1或者2取模根据上面判断又不符合，所以先排除1和2
4. 测试序列从2开始，输入的数是4——>得出结果`$num`不能和`$i`相等，并且`$num`不能小于`$i`

#### ② 落地实现

```powershell
#!/bin/env bash
#定义变量来保存用户所输入数字
read -p "请输入一个正整数字:" number

#先排除用户输入的数字1和2
[ $number -eq 1 ] && echo "$number不是质数" && exit
[ $number -eq 2 ] && echo "$number是质数" && exit

#循环判断用户所输入的数字是否质数

for i in `seq 2 $[$number-1]`
	do
	 [ $[$number%$i] -eq 0 ] && echo "$number不是质数" && exit
	done
echo "$number是质数"

优化思路：没有必要全部产生2~$[$number-1]序列，只需要产生一半即可。

更好解决办法：类C风格完美避开了生成序列的坑
for (( i=2;i<=$[$number-1];i++))
do
        [ $[$number%$i] -eq 0 ] && echo "$number不是质数" && exit

done
echo "$number是质数"
```

### ㈢ 批量创建用户

**需求：**批量加5个新用户，以u1到u5命名，并统一加一个新组，组名为class,统一改密码为123

#### ① 思路

1. 添加用户的命令	`useradd -G class`
2. 判断class组是否存在  `grep -w ^class /etc/group` 或者`groupadd class`
3. 根据题意，判断该脚本循环5次来添加用户  `for`
4. 给用户设置密码，应该放到循环体里面

#### ② 落地实现

```powershell
#!/bin/env bash
#判断class组是否存在
grep -w ^class /etc/group &>/dev/null
test $? -ne 0 && groupadd class

#循环创建用户
for ((i=1;i<=5;i++))
do
	useradd -G class u$i
	echo 123|passwd --stdin u$i
done
#用户创建信息保存日志文件












方法一：
#!/bin/bash
#判断class组是否存在
grep -w class /etc/group &>/dev/null
[ $? -ne 0 ] && groupadd class
#批量创建5个用户
for i in {1..5}
do
	useradd -G class u$i
	echo 123|passwd --stdin u$i
done

方法二：
#!/bin/bash
#判断class组是否存在
cut -d: -f1 /etc/group|grep -w class &>/dev/null
[ $? -ne 0 ] && groupadd class

#循环增加用户，循环次数5次，for循环,给用户设定密码
for ((i=1;i<=5;i++))
do
	useradd u$i -G class
	echo 123|passwd --stdin u$i
done


方法三：
#!/bin/bash
grep -w class /etc/group &>/dev/null
test $? -ne 0 && groupadd class
或者
groupadd class &>/dev/null

for ((i=1;i<=5;i++))
do
useradd -G class u$i && echo 123|passwd --stdin u$i
done
```

### ㈠ 批量创建用户

**需求1:**批量新建5个用户stu1~stu5，要求这几个用户的家目录都在/rhome.

```powershell
#!/bin/bash
#判断/rhome是否存在
[ -f /rhome ] && mv /rhome /rhome.bak
test ! -d /rhome && mkdir /rhome
或者
[ -f /rhome ] && mv /rhome /rhome.bak || [ ! -d /rhome ] && mkdir /rhome 

#创建用户，循环5次
for ((i=1;i<=5;i++))
do
	useradd -d /rhome/stu$i stu$i
	echo 123|passwd --stdin stu$i
done
```

### ㈡ 局域网内脚本检查主机网络通讯

**需求2：**

写一个脚本，局域网内，把能ping通的IP和不能ping通的IP分类，并保存到两个文本文件里

以10.1.1.1~10.1.1.10为例

```powershell
10.1.1.1~10.1.1.254

#!/bin/bash
#定义变量
ip=10.1.1
#循环去ping主机的IP
for ((i=1;i<=10;i++))
do
	ping -c1 $ip.$i &>/dev/null
	if [ $? -eq 0 ];then
		echo "$ip.$i is ok" >> /tmp/ip_up.txt
	else
		echo "$ip.$i is down" >> /tmp/ip_down.txt
	fi
	或者
	[ $? -eq 0 ] && echo "$ip.$i is ok" >> /tmp/ip_up.txt || echo "$ip.$i is down" >> /tmp/ip_down.txt
done

[root@server shell03]# time ./ping.sh         

real    0m24.129s
user    0m0.006s
sys     0m0.005s
```

**延伸扩展：shell脚本并发**

```powershell
并行执行：
{程序}&：表示将程序放到后台并行执行，如果需要等待程序执行完毕再进行下面内容，需要加wait

#!/bin/bash
#定义变量
ip=10.1.1
#循环去ping主机的IP
for ((i=1;i<=10;i++))
do
{

        ping -c1 $ip.$i &>/dev/null
        if [ $? -eq 0 ];then
                echo "$ip.$i is ok" >> /tmp/ip_up.txt
        else
                echo "$ip.$i is down" >> /tmp/ip_down.txt
        fi
}&
done
wait
echo "ip is ok...."

[root@server ~]# time ./ping.sh 
ip is ok...

real    0m3.091s
user    0m0.001s
sys     0m0.008s
```

### ㈢ 判断闰年

**需求3：**

输入一个年份，判断是否是润年（能被4整除但不能被100整除，或能被400整除的年份即为闰年）

```powershell
#!/bin/bash
read -p "Please input year:(2017)" year
if [ $[$year%4] -eq 0 -a $[$year%100] -ne 0 ];then
	echo "$year is leap year"
elif [ $[$year%400] -eq 0 ];then
	echo "$year is leap year"
else
	echo "$year is not leap year"
fi
```



#二、**==while循环语句==**

##1. while循环语法结构

~~~powershell
while 条件表达式
	do
		command...
	done
~~~

**循环打印1-5数字**

```powershell
while循环打印：
i=1
while [ $i -le 5 ]
do
	echo $i
	let i++
done
```

## 2. 案例

### ㈠ 脚本计算1-50偶数和

~~~powershell
#!/bin/env bash
sum=0
for ((i=0;i<=50;i+=2))
do
	let sum=$sum+$i  (let sum=sum+i)
done
echo "1-50的偶数和为:$sum"


#!/bin/bash
#定义变量
sum=0
i=2
#循环打印1-50的偶数和并且计算后重新赋值给sum
while [ $i -le 50 ]
do
	let sum=$sum+$i
	let i+=2  或者 $[$i+2]
done
#打印sum的值
echo "1-50的偶数和为:$sum"
~~~

### ㈡ 脚本同步系统时间

#### ① 具体需求

1. 写一个脚本，==30秒==同步一次系统时间，时间同步服务器10.1.1.1
2. 如果同步失败，则进行邮件报警,每次失败都报警
3. 如果同步成功,也进行邮件通知,但是==成功100次==才通知一次

#### ② 思路

1. 每隔30s同步一次时间，该脚本是一个死循环   while 循环

2. 同步失败发送邮件   1) ntpdate 10.1.1.1  2) rdate -s 10.1.1.1

3. 同步成功100次发送邮件   定义变量保存成功次数 

#### ③ 落地实现

~~~powershell
#!/bin/env bash
# 该脚本用于时间同步
NTP=10.1.1.1
count=0
while true  # 也可以用：来表示ture
do
	ntpdate $NTP &>/dev/null
	if [ $? -ne 0 ];then
		echo "system date failed" |mail -s "check system date"  root@localhost
	else
		let count++
		if [ $count -eq 100 ];then
		echo "systemc date success" |mail -s "check system date"  root@localhost && count=0
		fi
	fi
sleep 30
done


#!/bin/bash
#定义变量
count=0
ntp_server=10.1.1.1
while true
do
	rdate -s $ntp-server &>/dev/null
	if [ $? -ne 0 ];then
		echo "system date failed" |mail -s 'check system date'  root@localhost	
	else
		let count++
		if [ $[$count%100] -eq 0 ];then
		echo "system date successfull" |mail -s 'check system date'  root@localhost && count=0
		fi
	fi
sleep 3
done

以上脚本还有更多的写法，课后自己完成
~~~

#三、until循环

**特点**：==条件为假就进入循环；条件为真就退出循环==

## 1. until语法结构

```powershell
until 条件表达式
	do
		command
		...
	done
```

**打印1-5数字**

```powershell
i=1
until [ $i -gt 5 ]
do
	echo $i
	let i++
done
```

## 2. 应用案例

###㈠ 具体需求

1. 使用until语句批量创建10个用户，要求stu1—stu5用户的UID分别为1001—1005；
2. stu6~stu10用户的家目录分别在/rhome/stu6—/rhome/stu10

### ㈡ 思路

1. 创建用户语句  `useradd -u|useradd -d`
2. 使用循环语句(until)批量创建用户  `until循环语句结构`
3. 判断用户前5个和后5个  `条件判断语句`

### ㈢ 落地实现

```powershell
#！/bin/env bash
if [ -d /rhome ];then
    echo "/rhome目录已存在"
else
    mkdir /rhome
    echo "/rhome不存在，已完成创建"
fi

i=1
until [ $i -gt 10 ]
do
        if [ $i -le 5 ];then
                useradd -u $[1000+$i] stu$i
                echo 123|passwd --stdin stu$i

        else
                useradd -d /rhome/stu$i stu$i
                echo 123|passwd --stdin stu$i
        fi
let i++
done

==================================================

#!/bin/bash
i=1
until [ $i -gt 10 ]
do
	if [ $i -le 5 ];then
		useradd -u $[1000+$i] stu$i && echo 123|passwd --stdin stu$i
	else
		[ ! -d /rhome ] && mkdir /rhome
		useradd -d /rhome/stu$i stu$i && echo 123|passwd --stdin stu$i		
	fi
let i++
done
```

# 四、课后作业

1. 判断/tmp/run目录是否存在，如果不存在就建立，如果存在就删除目录里所有文件
2.  输入一个路径，判断路径是否存在，而且输出是文件还是目录，如果是链接文件，还得输出是  有效的连接还是无效的连接 
3. 交互模式要求输入一个ip，然后脚本判断这个IP 对应的主机是否 能ping 通，输出结果类似于：
   Server  10.1.1.20 is Down! 最后要求把结果邮件到本地管理员root@localhost mail01@localhost
4. 写一个脚本/home/program，要求当给脚本输入参数hello时，脚本返回world,给脚本输入参数world时，脚本返回hello。而脚本没有参数或者参数错误时，屏幕上输出“usage:/home/program hello or world”
5. 写一个脚本自动搭建nfs服务

