---
typora-copy-images-to: ../pictures/
typora-root-url: ../pictures/
---

##一、文本处理工具

###1. grep工具

> grep是==**行过滤**==工具；用于根据关键字选择行，默认不修改源文件

#### **语法：**

```powershell
# grep [选项] '关键字' [文件名|路径...]
```

#### **常见选项：**

~~~shell
OPTIONS:
    -i: 不区分大小写
    -v: 反向选择
    -w: 按单词全词匹配
    统计类：
        -o: only打印匹配到关键字（可以用统计匹配到的个数）
        -c: 统计匹配到的行数
        -n: 显示行号
    -A: 显示匹配行及后面多少行	
    -B: 显示匹配行及前面多少行
    -C: 显示匹配行前后多少行
    文件夹类：
        -r: 逐层遍历目录查找
        -l：只列出匹配的文件名
        -L：列出不匹配的文件名
    -E:启用POSIX扩展正则表达式
    -P:启用perl正则
    	# POSIX扩展正则与perl正则的区别：
    		POSIX 是 UNIX 遵循的标准, PERL 正则在 POSIX 上做了扩展，实现了很多方便的功能。兼容 Perl 的正则，叫 PCRE(Perl Compatible Regular Expression)
    -o:只输出正则表达式匹配的内容
    ^key:以关键字开头
    key$:以关键字结尾
    ^$:匹配空行
    --color=auto ：可以将找到的关键词部分加上颜色的显示
~~~

#### 引号说明

​	[grep 后加单引号、双引号和不加引号的区别，也即Bash中的引号区别，在其他命令中也同样适用](https://blog.csdn.net/cupidove/article/details/8783968)

1. **单引号**

   > 不识别变量和特殊符号，识别中间有空格的字符串。**所见即所得**。

2. **双引号**

   > 可以识别变量、命令、中间有空格的字符串。

3. **不带引号**

   > 可以识别变量、命令

如果关键字中带**特殊字符（$、\、`、"） or 有空格的字符串** 则用单引号即可，在此基础上又带有命令，则用双引号。否则不带引号即可，

**特殊字符注意点**：识别是分两部分的，一个shell本身识别，再传给引号识别。

```shell
e.g. 查找\
grep '\\' file		可以，shell直接传递\\给grep，grep转义后为\
grep "\\\\" file	可以，shell把四个\,转义成2个\传递给grep，grep再把2个\转义成一个\查找
```

#### **举例说明：**

```powershell
# grep -i root passwd						忽略大小写匹配包含root的行
# grep -v root passwd						匹配不包含root的行
# grep -w ftp passwd 						精确匹配ftp单词的行
# grep -r ftp /opt/* 						逐层遍历目录查找
# grep -o ftp passwd 						只输出匹配到的关键字
# grep -n root passwd 						显示行号
# grep -c root passwd						统计匹配的总行数
# grep ^root passwd 						以root开头的行
# grep bash$ passwd 						以bash结尾的行
# grep -n ^$ passwd 						匹配空行并打印行号
# grep -A 5 mail passwd 				 	匹配包含mail关键字及其后5行
# grep -B 5 mail passwd 				 	匹配包含mail关键字及其前5行
# grep -C 5 mail passwd 					匹配包含mail关键字及其前后5行
```

#### 实战常用

- find+grep：find筛选出指定文件后，grep在这些文件中检索。中间用xargs连接

  ```shell
  find . -type f -iname 'file_name' | xargs grep -irl '关键字'
  # 如果是.gz压缩文件，可以用zgrep代替grep，zgrep同时也可搜索普通文件
  ```
  
- 搜索出两个指定字符串之间的内容,：

  ```shell
  # 如result="abc123dhf" 取出result的值,或者是json格式result:"abc123dhf"
  grep -Po 'result[= "]+\K[^"]+' filename  \K在正则中的作用类似正后发断言
  ```

###2. cut工具

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



### 3. sort工具

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

###4.uniq工具

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

### 5.tee工具

> 双向覆盖重定向（屏幕输出|文本输入）

~~~powershell
选项：
-a append追加

# echo hello world|tee file1
# echo 999|tee -a file1
~~~

### 6.diff工具

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

### 7. paste工具

> 用于逐行合并文件

~~~powershell
常用选项：
-d：自定义间隔符，默认是tab
-s：横行处理，非并行
~~~

###8. tr工具

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

| 字符串             | 含义                 | 备注        |
| ------------------ | -------------------- | ----------- |
| ==a-z==或[:lower:] | 匹配所有小写字母     | [a-zA-Z0-9] |
| ==A-Z==或[:upper:] | 匹配所有大写字母     |             |
| ==0-9==或[:digit:] | 匹配所有数字         |             |
| [:alnum:]          | 匹配所有字母和数字   |             |
| [:alpha:]          | 匹配所有字母         |             |
| [:blank:]          | 所有水平空白         |             |
| [:punct:]          | 匹配所有标点符号     |             |
| [:space:]          | 所有水平或垂直的空格 |             |

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



## 进程

### ==1. ps==

> Process Status

ps -ef 与 ps aux：都能显示全部用户的进程，==只是风格差别==：

![image-20200324113245605](./image-20200324113245605.png)

![image-20200324113254007](./image-20200324113254007.png)

PID: process ID， 当前进程ID
PPID: parent process ID，父进程ID

![image-20200324113323431](./image-20200324113323431.png)

![image-20200324113329989](./image-20200324113329989.png)

### ==2. top==

[top命令详解](https://www.cnblogs.com/mushang1hao/p/10767062.html)

[top中的交互命令](https://www.jianshu.com/p/3f19d4fc4538)

## 网络

### 1. ping

测试TCP/IP (也就是传输层)是否畅通

### 2. telnet

明文传送报文，安全性不好

### ==3. netstat==

打印整个系统的网络情况

```sh
## 列举几个常用参数
-a 显示所有
-l 显示有在 Listen (监听) 的服务状态
-n 以网络IP地址代替域名
-p 显示程序名和PID
-t 显示TCP协议的连接情况
-u 显示UDP协议的连接情况

常用组合：netstat -anp
场景：查询zookeeper所用端口：
ps -ef | grep -i zookeeper # 查到zookeeper的PID
netstat -anp | grep PID # 有些内容可能因为权限无法看到，则加上sudo

连接状态(好像和三次握手四次挥手相关？)：
LISTEN　　监听中
SYN-SENT　　在发送连接请求后等待匹配的连接请求
SYN-RECEIVED　　在收到和发送一个连接请求后等待对方对连接请求的确认
ESTABLISHED　　代表一个打开的连接
TIME-WAIT　　等待足够的时间以确保远程TCP接收到连接中断请求的确认
CLOSED　　没有任何连接状态
CLOSED-WAIT　　等待从本地用户发来的连接中断请求
```



## 内存

### 1. free

![image-20200324144450375](./image-20200324144450375.png)

```sh
## 输出简介
			总	已用		剩余		被共享使用的	 buff/cache		可用
Mem(内存)
Swap(交换空间)

其中：available≈free+buff/cache,也就是如果free的内存不够用了，就会去buff/cache缓存中拿
```



## 扇区/磁盘块/磁盘页

### 扇区，sector

硬盘的读写以扇区为基本单位。磁盘上的每个磁道被等分为若干个弧段，这些弧段称之为扇区。通常情况下每个扇区的大小是 512 字节(0.5k)。linux 下可以使用 `fdisk -l` 了解扇区大小：

```shell
$ sudo /sbin/fdisk -l
Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7d9f5643
```

其中 Sector size，就是扇区大小，本例中为 512 bytes。

注意，扇区是磁盘物理层面的概念，操作系统是不直接与扇区交互的，而是与多个连续扇区组成的磁盘块交互。由于扇区是物理层面的概念，所以无法在系统中进行大小的更改。

### 磁盘块，IO Block

也叫磁盘簇,磁盘操作的基本单位。磁盘块是由几个Sector组在一起。每个磁盘块可以包括 2、4、8、16、32 或 64 个扇区。磁盘块是操作系统所使用的逻辑概念，而非磁盘的物理概念。磁盘块的大小可以通过命令 `stat /boot` 来查看：

```shell
$ sudo stat /boot
  File: /boot
  Size: 4096        Blocks: 8          IO Block: 4096   directory
Device: 801h/2049d  Inode: 655361      Links: 3
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-07-06 20:19:45.487160301 +0800
Modify: 2019-07-06 20:19:44.835160301 +0800
Change: 2019-07-06 20:19:44.835160301 +0800
 Birth: -
```

其中 **IO Block 就是磁盘块大小**，本例中是 **4096 Bytes（等于8个扇区组成）**，一般也是 4K。

为了更好地管理磁盘空间和更高效地从硬盘读取数据，**操作系统规定一个磁盘块中只能放置一个文件**，因此文件所占用的空间，只能是磁盘块的整数倍，那就意味着会出现文件的实际大小，会小于其所占用的磁盘空间的情况。磁盘块的大小是可以通过blockdev命令更改的。

![image-20210407121034555](/image-20210407121034555.png)

### 磁盘页，Page

内存操作的基本单位。页的大小通常为磁盘块大小的 2^n 倍，可以通过命令 `getconf PAGE_SIZE` 来获取页的大小：

```shell
$sudo getconf PAGE_SIZE
4096
```

本例中为 4096 Bytes，与磁盘块大小一致。

总结两个逻辑单位：

- 页，内存操作的基本单位
- 磁盘块，磁盘操作的基本单位





### 1. df -ha

### 2. du -ha

## 标准输入输出

### 1. 三种类型

| 类型 | 文件描述符 | 设备名(文件名)         |
| -------------- | ---------- | ------------ |
| 标准输入 | **0**      | /dev/stdin |
| 标准正确输出 | **1**      | /dev/stdout |
| 标准错误输出 | **2**      | /dev/stderr |

一般情况下，每个Unix/Linux命令都会打开这个文件，默认从这三个文件来输入和输出数据。

### 2. 符号

| 符号 | 类型/作用      |
| ---- | -------------- |
| <    | 标准输入       |
| >    | 标准正确输出覆盖。set –C：禁止覆盖；set +C：启用覆盖。前面省略1 |
| \>>  | 标准正确输出追加重定向。前面省略1                       |


### 3.常用组合举例

| 组合 | 作用 |
| ---- | ---- |
| 2>  ,  2>> | 标准错误输出重定向，追加。 |
| & | =1+2<br />&>:   1+2覆盖，   &>> :1+2追加 |
| 2>&1或者1>&2 | 这里&表示一个**文件描述符引用**，与上面的&不一样，把2输出重定向到1。<br /> ./a.sh **&>**  b.txt   等价于 ./a.sh >  b.txt **2>&1**，这里**2>&1**必须放在b.txt后面 |

<img src=".\image-20200622002730214.png" alt="image-20200622002730214" style="zoom:67%;" />

## xargs/exec/|

**|** ：用来将前一个命令的**标准输出**传递到下一个命令的**标准输入**

**xargs**：**xargs前面一定要加|**,|将标准输出->标准输入，xargs再将标准输入作为下一个命令的**参数**

格式：`command1 | xargs [-option] command2`   
将command1的标准输出作为command2的参数，**command2默认为echo**,参数之间默认以空格作为分界。{}用来表示command1传递过来的内容。

```shell
例举几种用法：
(1)多行输入单行输出
cat xargs.txt | xargs
(2)指定一次处理的参数个数：指定为5，多行输出
cat xargs.txt | xargs -n 5		# -n： 指定一次处理的参数个数
(3)将所有文件重命名，逐项处理每个参数
ls *.txt |xargs -t -i mv {} {}.bak  #-t：表示先打印传递的内容，然后再执行   -i：逐项处理
```

**|与xargs对比**：

```shell
#ls标准输出的结果作为cat的标准输入
ls | cat
#使用xargs将ls的结果作为cat的参数，ls的结果为文件名，所以cat 文件名即查看文件内容
ls | xargs cat
```

<img src="/image-20200628174837166.png" alt="image-20200628174837166" style="zoom:80%;" />

**xargs与exec对比**

exec固定格式：`command1 -exec command2 {} \;` 注意一定要有；而且需要加\转义。

1. exec参数是一个一个传递的，传递一个参数执行一次命令；xargs默认是一次性将参数全传给命令，可以使用-n控制参数个数

   ![image-20200628175342251](/image-20200628175342251.png)

2. **文件名有空格等特殊字符**推荐用exec，xargs也可以特殊文件名需要特殊处理。

   因为：xargs默认是以空格作为定界符，也即参数与参数之间默认是空格分开。

## wc

```shell
wc test.txt 
5  6 17 test.txt	# 5行    6单词(单词是以空格隔开为标准)    17字符
```

## find

`find [path...] [expression] [actions]  `

- path可以是多个路径,path不填则默认当前路径

| expression           | Desc                                                         | e.g.                                                         |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| -name（-iname）      | 文件名(忽略大小写),支持正则匹配                              | find . /home ~/ -name 'user*'                                |
| -type                | 文件类型                                                     | find . -type f                                               |
| -perm                | 权限                                                         | find . -perm '2644'<br />find /root -perm /g=r 所属组有读的权限 |
| -user  或者 -group   | 用户和组                                                     | find . -user 'vnr1cbs' 所属用户是vnr1cbs                     |
| -mtime/-atime/-ctime | 文件修改/访问/创建时间                                       | -n指n天以内，+n指n天以前                                     |
| -cmin/-mmin/-amin    | ...分钟                                                      |                                                              |
| -size(单位：c/k/M/G) | 文件大小，不能检索目录大小                                   | +1M 大于1M， -1M 小于1M， 1M 等于1M                          |
| -empty               | 空文件(-size 0)/空目录                                       | find -empty                                                  |
| !                    | 反向查找                                                     | find /root ! -empty                                          |
| -maxdepth/-mindepth  | 控制目录递归最大/小层级<br />(1表示当前目录下)               | find . -maxdepth 3 -mindepth 2                               |
| ==-a  -o==           | 逻辑组合,-a为and -o为or；多条件时，默认-a关系<br />还可以用()进行分组，但需要用单引号把括号引起来 | find . '(' -iname *aa -o -iname *ab ')' -a -size +69c        |



## [wget](https://segmentfault.com/a/1190000022301195)

> 一个下载工具，支持HTTP, HTTPS, and FTP协议，

`wget [option]... [URL]...`

| option                    | Desc                                 | e.g.              |
| ------------------------- | ------------------------------------ | ----------------- |
| -h                        | 帮助文档                             |                   |
| ==-c==                    | 断点续传,重新启动下载中断的文件      | wget -c url       |
| ==-b==                    | 后台下载                             |                   |
| ==--spider==              | 测试下载速度：可用来检查网站是否可用 |                   |
| -i                        | 下载本地或外部 FILE 中的 URLs        | wget -i urls_file |
| 日志和输入文件:....       |                                      |                   |
| 下载：...                 |                                      |                   |
| 目录：...                 |                                      |                   |
| HTTP 选项：...            |                                      |                   |
| HTTPS (SSL/TLS) 选项：... |                                      |                   |
| FTP 选项：...             |                                      |                   |
| WARC options:...          |                                      |                   |
| 递归下载：...             |                                      |                   |
| 递归接受/拒绝：...        |                                      |                   |



## curl

> **transfer a url** ,transfer data from or to a server，可以称为**命令行式postman**。
>  supported protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3,POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, TELNET and TFTP).比wget支持的协议多得多

`curl [options] [URL...]`

| options            | Desc                                                         | e.g.                               |
| ------------------ | ------------------------------------------------------------ | ---------------------------------- |
| 无参数             | 查看网页响应的源码,显示在"标准输出"（stdout）上面。          | curl www.sina.com                  |
| -o [文件名]        | Write output to file instead of stdout，相当于wget           | curl -o [文件名] www.sina.com      |
| -L                 | 有的网址是自动跳转的，-L就会自动跳转                         | curl -L www.sina.com               |
| ==-i==             | 显示response头信息以及网页信息                               |                                    |
| ==-I==             | 只显示response头信息                                         |                                    |
| ==-v==             | 显示一次http通信的整个过程，包括端口连接和http request头信息 |                                    |
| ==--trace [文件]== | 比-v更详细                                                   | curl --trace info.txt www.sina.com |
| -X                 | 使用指定的 http method，GET\|POST\|PUT\|DELETE...            |                                    |
| 发送表单信息       | GET：直接写url后面<br />其他方式：--data、--data-urlencode（表单编码） | curl -X POST --data "data=xxx" url |
| 上传文件           | curl --form upload=@localfilename --form press=OK [URL]      |                                    |
| --referer          | 模拟请求头中Referer                                          |                                    |
| --user-agent       | 模拟请求头中User Agent                                       |                                    |
| --cookie           | 发cookie。curl --cookie "name=xxx" www.example.com           |                                    |
| --header           | 模拟请求头信息，curl --header "Content-Type:application/json"  url |                                    |





```bash
# 调试类
-v, --verbose                          输出信息
-q, --disable                          在第一个参数位置设置后 .curlrc 的设置直接失效，这个参数会影响到 -K, --config -A, --user-agent -e, --referer
-K, --config FILE                      指定配置文件
-L, --location                         跟踪重定向 (H)

# CLI显示设置
-s, --silent                           Silent模式。不输出任务内容
-S, --show-error                       显示错误. 在选项 -s 中，当 curl 出现错误时将显示
-f, --fail                             不显示 连接失败时HTTP错误信息
-i, --include                          显示 response的header (H/F)
-I, --head                             仅显示 响应文档头
-l, --list-only                        只列出FTP目录的名称 (F)
-#, --progress-bar                     以进度条 显示传输进度

# 数据传输类
-X, --request [GET|POST|PUT|DELETE|…]  使用指定的 http method 例如 -X POST
-H, --header <header>                  设定 request里的header 例如 -H "Content-Type: application/json"
-e, --referer                          设定 referer (H)
-d, --data <data>                      设定 http body 默认使用 content-type application/x-www-form-urlencoded (H)
    --data-raw <data>                  ASCII 编码 HTTP POST 数据 (H)
    --data-binary <data>               binary 编码 HTTP POST 数据 (H)
    --data-urlencode <data>            url 编码 HTTP POST 数据 (H)
-G, --get                              使用 HTTP GET 方法发送 -d 数据 (H)
-F, --form <name=string>               模拟 HTTP 表单数据提交 multipart POST (H)
    --form-string <name=string>        模拟 HTTP 表单数据提交 (H)
-u, --user <user:password>             使用帐户，密码 例如 admin:password
-b, --cookie <data>                    cookie 文件 (H)
-j, --junk-session-cookies             读取文件中但忽略会话cookie (H)
-A, --user-agent                       user-agent设置 (H)

# 传输设置
-C, --continue-at OFFSET               断点续转
-x, --proxy [PROTOCOL://]HOST[:PORT]   在指定的端口上使用代理
-U, --proxy-user USER[:PASSWORD]       代理用户名及密码

# 文件操作
-T, --upload-file <file>               上传文件
-a, --append                           添加要上传的文件 (F/SFTP)

# 输出设置
-o, --output <file>                    将输出写入文件，而非 stdout
-O, --remote-name                      将输出写入远程文件
-D, --dump-header <file>               将头信息写入指定的文件
-c, --cookie-jar <file>                操作结束后，要写入 Cookies 的文件位置
```



## less

**例子**：

以-g为例，先举个less的使用方式，less多数命令都支持以下两种方式：
**-g: 标志关键词相关**

1. 放在命令后面：

   ```shell
   less -g file.txt
   ```

2. less打开文本之后：

   ```shell
   -g:切换"只高亮当前匹配"/"不高亮显示"
   -G:切换"高亮全部匹配"/"不高亮显示"
   ```

   

**常用参数：**

```shell
-i  忽略搜索时的大小写
-N  显示每行的行号
-g/-G  高亮显示选项切换
```





















