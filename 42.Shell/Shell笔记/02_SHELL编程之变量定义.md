---
typora-copy-images-to: pictures
typora-root-url: ..\pictures
---

# 一、SHELL介绍

**前言：**

计算机只能认识（识别）机器语言(0和1)，如（11000000 这种）。但是，我们的程序猿们不能直接去写01这样的代码，所以，要想将程序猿所开发的代码在计算机上运行，就必须找"人"（工具）来翻译成机器语言，这个"人"(工具)就是我们常常所说的**编译器**或者**解释器**。

![编译和解释型语言区别](/编译和解释型语言区别.png)

##1. 编程语言分类

- **编译型语言：**

​    ==程序在执行之前需要一个专门的编译过程==，把程序编译成为机器语言文件，运行时不需要重新翻译，直接使用编译的结果就行了。程序执行效率高，依赖编译器，跨平台性差些。如C、C++、java

- **解释型语言：**

​    程序不需要编译，程序在运行时由**==解释器==**翻译成机器语言，每执行一次都要翻译一次。因此效率比较低。比如Python/JavaScript/ Perl /ruby/==Shell==等都是解释型语言。

![./语言分类](语言分类.png)

- **总结**

编译型语言比解释型语言==速度较快==，但是不如解释型语言==跨平台性好==。如果做底层开发或者大型应用程序或者操作系开发一==般都用编译型语言==；如果是一些服务器脚本及一些辅助的接口，对速度要求不高、对各个平台的==兼容性有要求==的话则一般都用==解释型语言==。

##2. shell简介

![00_shell介绍](/00_shell介绍.png)

**总结：**

- **shell就是人机交互的一个桥梁**
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

### ㈠ 什么是shell脚本？

- 一句话概括

简单来说就是将==需要执行的命令==保存到文本中，==**按照顺序执行**==。它是解释型的，意味着不需要编译。

- 准确叙述

**若干命令 + 脚本的基本格式 + 脚本特定语法 + 思想= shell脚本**

### ㈢ shell脚本能干啥?

 ①自动化软件部署	LAMP/LNMP/Tomcat...	

 ②自动化管理		系统初始化脚本、批量更改主机密码、推送公钥...

 ③==自动化分析处理==	 统计网站访问量

 ④==自动化备份==		数据库备份、日志转储...

 ⑤自动化监控脚本

### ㈥ shell脚本的基本写法

1）**脚本第一行**，魔法字符`#!`指定解释器

`#!/bin/bash`  表示以下内容使用bash解释器解析

**注意：**
如果直接将解释器路径写死在脚本里，可能在某些系统就会存在找不到解释器的兼容性问题，所以可以使用:`#!/bin/env 解释器`

2）**脚本第二部分**，注释

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

3）**脚本第三部分**，脚本要实现的具体代码内容

### ㈦ shell脚本的执行方法

- 标准脚本执行方法（建议）

```powershell
1) 编写人生第一个shell脚本
# cat first_shell.sh
#!/bin/env bash

# 以下内容是对脚本的基本信息的描述
# Name: first_shell.sh
# Desc: num1
# Path: /shell01/first_shell.sh
# Usage:/shell01/first_shell.sh
# Update:2019-05-05

echo "hello world"

2) 脚本增加可执行权限
 chmod +x first_shell.sh

3) 标准方式执行脚本
 ./first_shell.sh
```

- 非标准的执行方法（不建议）

1. 直接指定解释器执行

```powershell
# bash first_shell.sh
# sh first_shell.sh

-x:一般用于排错，查看脚本的执行过程
# bash -x first_shell.sh
-n:用来查看脚本的语法是否有问题
```

2. 使用`source`命令读取脚本文件,执行文件里的代码

```powershell
# source first_shell.sh
hello world
hello world
hello world
```



# 二、变量的定义

## 3.变量如何定义？

**变量名=变量值**  

```powershell
# A=hello			定义变量A
# echo $A			调用变量A
hello
# echo ${A}			还可以这样调用
hello
# A=world			重新赋值

# unset A			取消变量
```

## 4. 变量的定义规则

### ㈠ 变量名区分大小写

### ㈡ 变量名不能有特殊符号

```powershell
# *A=hello
-bash: *A=hello: command not found
# ?A=hello
-bash: ?A=hello: command not found
# @A=hello
-bash: @A=hello: command not found

特别说明：对于有空格的字符串给变量赋值时，要用引号引起来
# A=hello world
-bash: world: command not found
# A="hello world"
# A='hello world'
```

### ㈢ 变量名不能以数字开头

### ㈣ 等号两边不能有任何空格

## ==5. 变量的定义方式有哪些？==

### ㈠ 基本方式

> 直接赋值给一个变量

```powershell
# A=1234567
# echo $A
1234567
# echo ${A:2:4}		表示从A变量中第3个字符开始截取，截取4个字符
3456

说明：
$变量名 和 ${变量名}的异同
相同点：都可以调用变量
不同点：${变量名}可以只截取变量的一部分，而$变量名不可以
```

### ㈡ 命令执行结果赋值给变量

```powershell
# B=`date +%F`
# echo $B
2019-04-16
# C=$(uname -r)
# echo $C
2.6.32-696.el6.x86_64  --> 内核版本
```

### ㈢ 交互式定义变量(read)

**目的：**让==用户自己==给变量赋值，比较灵活。

**语法：**`read [选项] 变量名`

**常见选项：**

| 选项 | 释义                                                       |
| ---- | ---------------------------------------------------------- |
| -p   | 定义提示用户的信息                                         |
| -n   | 定义字符数（限制变量值的长度）                             |
| -s   | 不显示（不显示用户输入的内容）                             |
| -t   | 定义超时时间，默认单位为秒（限制用户输入变量值的超时时间） |

**举例说明：**

```powershell
用法1：用户自己定义变量值
# read name
harry
# echo $name
harry
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

| 选项 | 释义                       | 举例                                         |
| ---- | -------------------------- | -------------------------------------------- |
| -i   | 将变量看成整数             | declare -i A=123                             |
| -r   | 定义只读变量               | declare -r B=hello                           |
| -a   | 定义普通数组；查看普通数组 |                                              |
| -A   | 定义关联数组；查看关联数组 |                                              |
| -x   | 将变量通过环境导出         | declare -x AAA=123456 等于 export AAA=123456 |

**举例说明：**

```powershell
# declare -i A=123
# echo $A
123
# A=hello
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

## ==6. 变量的分类==

### ㈠ 本地变量

- **==本地变量==**：当前用户自定义的变量。当前进程中有效，其他进程及**当前进程的子进程无效**。

  ```
  查看进程父子关系
  $ ps -auxf |grep bash
  ipnet    19447  0.0  0.0 115440  2000 pts/0    Ss   10:29   0:00         \_ -bash
  ipnet    20741  0.0  0.0 115440  1984 pts/1    Ss   10:43   0:00         \_ -bash
  root     20844  0.0  0.0 115440  2008 pts/1    S    10:44   0:00         |       \_ -bash
  ipnet    22356  0.0  0.0 115440  2028 pts/2    Ss   11:14   0:00         \_ -bash
  ipnet    27420  0.0  0.0 115440  1984 pts/2    S    23:50   0:00         |   \_ bash
  ipnet    27448  0.0  0.0 112708   948 pts/2    S+   23:50   0:00         |       \_ grep --color=auto bash
  ipnet    23420  0.0  0.0 115440  2016 pts/3    Ss+  11:29   0:00          \_ -bash

  ```

### ㈡ 环境变量

- **环境变量**：当前进程有效，**并且能够被子进程调用**。
  - `env`查看当前用户的环境变量
  - `set`查询当前用户的所有变量(临时变量与环境变量) 
  - `export 变量名=变量值`    或者  `变量名=变量值；export 变量名`

~~~powershell
# export A=hello		临时将一个本地变量（临时变量）变成环境变量
# env|grep ^A
A=hello

永久生效：
vim /etc/profile 或者 ~/.bashrc
export A=hello
或者
A=hello
export A

说明：系统中有一个变量PATH，环境变量
export PATH=/usr/local/mysql/bin:$PATH
~~~

### ㈢ 全局变量


- **全局变量**：全局所有的用户和程序都能调用，且继承，新建的用户也默认能调用.

- **解读相关配置文件**

| 文件名               | 说明                                   | 备注                                                       |
| -------------------- | -------------------------------------- | ---------------------------------------------------------- |
| $HOME/.bashrc        | 当前用户的bash信息,用户**登录**时读取  | 定义别名、umask、函数等                                    |
| $HOME/.bash_profile  | 当前用户的环境变量，用户**登录**时读取 |                                                            |
| $HOME/.bash_logout   | 当前用户**退出**当前shell时最后读取    | 定义用户退出时执行的程序等                                 |
| /etc/bashrc          | 全局的bash信息，所有用户都生效         |                                                            |
| /etc/profile         | 全局环境变量信息                       | 系统和所有用户都生效                                       |
| \$HOME/.bash_history | 用户的历史命令                         | history -w   保存历史记录         history -c  清空历史记录 |

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
| $*           | 脚本后面==所有参数==，参数当成一个整体输出，每一个变量参数之间以空格隔开 |
| $@           | 脚本后面==所有参数==，参数是独立的，也是全部输出             |
| \$1\~$9      | 脚本后面的==位置参数==，$1表示第1个位置参数，依次类推        |
| \${10}\~${n} | 扩展位置参数,第10个位置变量必须用{}大括号括起来(2位数字以上扩起来) |
| ==$$==       | 当前所在进程的进程号，如`echo $$`                            |
| $！          | 后台运行的最后一个进程号 (当前终端）                         |
| !$           | 调用最后一条命令历史中的==参数==                             |

- 进一步了解位置参数`$1~${n}`

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

算术运算：默认情况下，shell就只能支持简单的==整数==运算

运算内容：加(+)、减(-)、乘(*)、除(/)、求余数（%）

## 1. 表达式

| 表达式  | 举例                                                         |
| ------- | ------------------------------------------------------------ |
| $((  )) | echo $((1+1))                                                |
| $[ ]    | echo $[10-5]                                                 |
| expr    | expr 10 / 5  expr 10 \\* 5 (==符号左右需空格，expr表达式的格式，*需要转移==) |
| let     | n=1;let n+=1  等价于  let n=n+1                              |

==备注：==
==$() = ``== ：执行命令
==\$A=\${A}== ： 引用变量
==\$(())=\$[]==：运算表达式



# 四、扩展补充

## 1. 数组定义

### ㈠ 数组分类

- 普通数组：只能使用整数作为数组索引(元素的下标)
- 关联数组：可以使用字符串作为数组索引(元素的下标)

### ㈡ 普通数组定义

- 一次赋予一个值

```powershell
数组名[索引下标]=值
array[0]=v1
array[1]=v2
array[2]=v3
array[3]=v4
```

- 一次赋予多个值

```powershell
数组名=(值1 值2 值3 ...)
array=(var1 var2 var3 var4)

array1=(`cat /etc/passwd`)			将文件中每一行赋值给array1数组
array2=(`ls /root`)
array3=(harry amy jack "Miss Hou")
array4=(1 2 3 4 "hello world" [10]=linux)
```

### ㈢ 数组的读取

```powershell
${数组名[元素下标]}

echo ${array[0]}			获取数组里第一个元素
echo ${array[*]}			获取数组里的所有元素
echo ${#array[*]}			获取数组里所有元素个数
echo ${!array[@]}    	获取数组元素的索引下标
echo ${array[@]:1:2}    访问指定的元素；1代表从下标为1的元素开始获取；2代表获取后面几个元素

查看普通数组信息：
# declare -a
```

### ㈣ 关联数组定义

#### ①首先声明关联数组

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
# asso_array1[php]=three
```

- 一次赋多个值

```powershell
# asso_array2=([name1]=harry [name2]=jack [name3]=amy [name4]="Miss Hou")
```

- 查看关联数组

```powershell
# declare -A
declare -A asso_array1='([php]="three" [java]="two" [linux]="one" )'
declare -A asso_array2='([name3]="amy" [name2]="jack" [name1]="harry" [name4]="Miss Hou" )'
```

- 获取关联数组值

```powershell
# echo ${asso_array1[linux]}
one
# echo ${asso_array1[php]}
three
# echo ${asso_array1[*]}
three two one
# echo ${!asso_array1[*]}
php java linux
# echo ${#asso_array1[*]}
3
# echo ${#asso_array2[*]}
4
# echo ${!asso_array2[*]}
name3 name2 name1 name4
```

- 其他定义方式

```powershell
[root@MissHou shell05]# declare -A books
[root@MissHou shell05]# let books[linux]++
[root@MissHou shell05]# declare -A|grep books
declare -A books='([linux]="1" )'
[root@MissHou shell05]# let books[linux]++
[root@MissHou shell05]# declare -A|grep books
declare -A books='([linux]="2" )'
```



## 2. 其他变量定义

- 取出一个目录下的目录和文件：`dirname`和 `basename` 

```powershell
# A=/root/Desktop/shell/mem.txt 
# echo $A
/root/Desktop/shell/mem.txt
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

