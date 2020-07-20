---
typora-copy-images-to: ../pictures
typora-root-url: ../pictures
---

# ==《工具篇》==

##一、文本处理工具

###1. grep工具

> grep是==**行过滤**==工具；用于根据关键字进行行过滤
>

#### **语法：**

```powershell
# grep [选项] '关键字' [文件名|路径]
```
#### **常见选项：**

~~~shell
OPTIONS:
    -i: 不区分大小写
    -v: 查找不包含指定内容的行,反向选择
    -w: 按单词搜索
    统计类：
        -o: 打印匹配关键字
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
# grep -o ftp passwd 						只输出匹配到的关键字，默认输出关键字的行，
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

##二、sed

### 简介

**作用**：sed是==S==tream ==Ed==itor（流编辑器）的缩写，简称流编辑器；用来==处理文件==的。

**原理**：sed是==一行一行读取==文件内容并==按照要求==进行==处理==，把处理后的结果==输出到屏幕==。

![sed](./sed.png)

1. 首先sed读取文件中的一行内容，把其保存在一个==临时缓存区中==（也称为模式空间）
2. 然后==根据需求==处理临时缓冲区中的行，完成后把该行==发送到屏幕上==

**总结：**

1. 由于sed把每一行都存在临时缓冲区中，对这个**副本**进行编辑，所以==不会直接修改原文件==
2. sed主要用来自动编辑一个或多个文件；简化对文件的反复操作,对文件进行过滤和转换操作

**使用:**

sed常见的语法格式有两种，一种叫==命令行==模式，另一种叫==脚本==模式。

### 1. 命令行格式

#### ㈠ 语法格式

==语法：sed  [options]     **'**定位+动作**'**    文件名 ， **无定位则是每一行**==

- **options**

| 选项   | 说明                         | 备注               |
| ------ | ---------------------------- | ------------------ |
| -e     | 进行多项(多次)编辑           |                    |
| ==-n== | 取消默认输出                 | 不自动打印模式空间 |
| ==-r== | 使用扩展==正则表达式==       |                    |
| -i     | 原地编辑（修改源文件，慎用） |                    |
| -f     | 指定sed脚本的文件名          |                    |

- **==常见动作==**

注意：以下所有的动作都要在**单引号**里

| 动作 | 说明                     | 备注 |
| ---- | ------------------------ | ---- |
| 'p'  | 打印                     | 查   |
| 'i'  | 在指定行==之前==插入内容 | 增   |
| 'a'  | 在指定行==之后==插入内容 | 增   |
| 'c'  | 替换指定行所有内容       | 改   |
| 'd'  | 删除指定行               | 删   |

#### ㈡ 举例说明

- 文件准备

```powershell
# vim a.txt 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
298374837483
172.16.0.254
10.1.1.1
```

##### ① 增、删、改、查

> ==sed option '定位+动作+内容' 文件名==

1）打印文件内容	p

> 如果不使用-n，则默认会输出全文件内容。p动作只是额外打印其他内容

```powershell
# sed ''  a.txt						对文件什么都不做，全文默认输出
# sed -n '2p' a.txt					取消默认输出,只打印第2行
# sed -n '1,5p'  a.txt				取消默认输出,打印1到5行
# sed -n '$p' a.txt 				取消默认输出,打印最后1行

实际场景：
1. 根据流水筛选出日志：
grep -ni '流水号' ./logfile | cut -d: -f | head -1   #得到流水出现的首行行号,如33011
grep -ni '流水号' ./logfile | cut -d: -f | tail -f   #得到流水出现的首行行号.如33901
sed -n '33011,33901p' ./logfile > xxx.file

2.截取一段时间内的日志：
sed -n '/2015-05-04 09:25:55/,/2015-05-04 09:28:55/p'  logfile
```

2）增加文件内容	i a

```powershell
# sed '$a99999' a.txt 				文件最后一行下面增加内容
# sed 'a99999' a.txt 				文件每行下面增加内容
# sed '5a99999' a.txt 				文件第5行下面增加内容
# sed '1i99999' a.txt 				文件第一行上增加内容
# sed '/^uucp/ihello'				以uucp开头的所有行上面插入内容
```

3）修改文件内容	c

```powershell
# sed '5chello world' a.txt 	替换文件第5行内容
# sed 'chello world' a.txt 		替换文件所有内容
# sed '1,5chello world' a.txt 	替换文件1到5行内容为hello world（5行变一行！！！）
# sed '/^user01/c888888' a.txt	替换以user01开头的行
```

4）删除文件内容	d

```powershell
# sed '1d' a.txt 					删除文件第1行
# sed '1,5d' a.txt 					删除文件1到5行
# sed '$d' a.txt						删除文件最后一行
```

##### ② ==搜索替换==

> 语法：==sed   选项   **'s/搜索的内容/替换的内容/动作'**==  需要处理的文件,默认只替换行中第一个匹配的
>
> ==s== ：表示search搜索定位
>
> ==g==：表示全局替换
>
> ==**/**==：表示分隔符

```powershell
# sed -n 's/root/ROOT/p' 1.txt 		#只替换每行第一个匹配的root，但只输出有匹配的行！！！
# sed -n 's/root/ROOT/gp' 1.txt 	#全局替换root，但只输出有匹配的行
# sed -n 's@/sbin/nologin@itcast@gp' a.txt	#这里使用@作为分隔符
# sed -n '1,5s/^/#/p' a.txt 		注释掉文件的1-5行内容
```

##### ③ 其他命令

| 命令 | 解释                                       | 备注         |
| ---- | ------------------------------------------ | ------------ |
| r    | 从另外文件中读取内容                       |              |
| w    | 内容另存为                                 |              |
| &    | 保存查找串以便在替换串中引用               | 和\\(\\)相同 |
| =    | 打印行号                                   |              |
| ！   | 对所选行以外的所有行应用命令，放到行数之后 | '1,5!'       |
| q    | 退出                                       |              |

**举例说明：**

~~~powershell
r	从文件中读取输入行
w	将所选的行写入文件
# sed '3r /etc/hosts' 2.txt 
# sed '$r /etc/hosts' 2.txt
# sed '/root/w a.txt' 2.txt 
# sed '/[0-9]{4}/w a.txt' 2.txt
# sed  -r '/([0-9]{1,3}\.){3}[0-9]{1,3}/w b.txt' 2.txt

!	对所选行以外的所有行应用命令，放到行数之后
# sed -n '1!p' 1.txt 
# sed -n '4p' 1.txt 
# sed -n '4!p' 1.txt 
# cat -n 1.txt 
# sed -n '1,17p' 1.txt 
# sed -n '1,17!p' 1.txt 

&   保存查找串以便在替换串中引用   \(\)

# sed -n '/root/p' a.txt 
root:x:0:0:root:/root:/bin/bash
# sed -n 's/root/#&/p' a.txt 
#root:x:0:0:root:/root:/bin/bash

# sed -n 's/^root/#&/p' passwd   注释掉以root开头的行
# sed -n -r 's/^root|^stu/#&/p' /etc/passwd	注释掉以root开头或者以stu开头的行
# sed -n '1,5s/^[a-z].*/#&/p' passwd  注释掉1~5行中以任意小写字母开头的行
# sed -n '1,5s/^/#/p' /etc/passwd  注释1~5行
或者
sed -n '1,5s/^/#/p' passwd 以空开头的加上#
sed -n '1,5s/^#//p' passwd 以#开头的替换成空

# sed -n '/^root/p' 1.txt 
# sed -n 's/^root/#&/p' 1.txt 
# sed -n 's/\(^root\)/#\1/p' 1.txt 
# sed -nr '/^root|^stu/p' 1.txt 
# sed -nr 's/^root|^stu/#&/p' 1.txt 


= 	打印行号
# sed -n '/bash$/=' passwd    打印以bash结尾的行的行号
# sed -ne '/root/=' -ne '/root/p' passwd 
# sed -n '/nologin$/=;/nologin$/p' 1.txt
# sed -ne '/nologin$/=' -ne '/nologin$/p' 1.txt

q	退出
# sed '5q' 1.txt
# sed '/mail/q' 1.txt
# sed -r '/^yunwei|^mail/q' 1.txt
# sed -n '/bash$/p;10q' 1.txt
ROOT:x:0:0:root:/root:/bin/bash


综合运用：
# sed -n '1,5s/^/#&/p' 1.txt 
#root:x:0:0:root:/root:/bin/bash
#bin:x:1:1:bin:/bin:/sbin/nologin
#daemon:x:2:2:daemon:/sbin:/sbin/nologin
#adm:x:3:4:adm:/var/adm:/sbin/nologin
#lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

# sed -n '1,5s/\(^\)/#\1/p' 1.txt 
#root:x:0:0:root:/root:/bin/bash
#bin:x:1:1:bin:/bin:/sbin/nologin
#daemon:x:2:2:daemon:/sbin:/sbin/nologin
#adm:x:3:4:adm:/var/adm:/sbin/nologin
#lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
~~~

##### ④ 其他选项

```powershell
-e	多项编辑
-r	扩展正则
-i	修改原文件

# sed -ne '/root/p' 1.txt -ne '/root/='
root:x:0:0:root:/root:/bin/bash
1
# sed -ne '/root/=' -ne '/root/p' 1.txt 
1
root:x:0:0:root:/root:/bin/bash

在1.txt文件中的第5行的前面插入“hello world”;在1.txt文件的第8行下面插入“哈哈哈哈”

# sed -e '5ihello world' -e '8a哈哈哈哈哈' 1.txt  -e '5=;8='

sed -n '1,5p' 1.txt
sed -ne '1p' -ne '5p' 1.txt
sed -ne '1p;5p' 1.txt

过滤vsftpd.conf文件中以#开头和空行：
# grep -Ev '^#|^$' /etc/vsftpd/vsftpd.conf
# sed -e '/^#/d' -e '/^$/d' /etc/vsftpd/vsftpd.conf
# sed '/^#/d;/^$/d' /etc/vsftpd/vsftpd.conf
# sed -r '/^#|^$/d' /etc/vsftpd/vsftpd.conf

过滤smb.conf文件中生效的行：
# sed -e '/^#/d' -e '/^;/d' -e '/^$/d' -e '/^\t$/d' -e '/^\t#/d' smb.conf
# sed -r '/^(#|$|;|\t#|\t$)/d' smb.conf 

# sed -e '/^#/d' -e '/^;/d' -e '/^$/d' -e '/^\t$/d' -e '/^\t#/' smb.conf


# grep '^[^a-z]' 1.txt

# sed -n '/^[^a-z]/p' 1.txt

过滤出文件中的IP地址：
# grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' 1.txt 
192.168.0.254
# sed -nr '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' 1.txt 
192.168.0.254

# grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}' 2.txt 
10.1.1.1
10.1.1.255
255.255.255.0

# sed -nr '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' 2.txt
10.1.1.1
10.1.1.255
255.255.255.0
过滤出ifcfg-eth0文件中的IP、子网掩码、广播地址
[root@server shell06]# grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' ifcfg-eth0 
10.1.1.1
255.255.255.0
10.1.1.254
[root@server shell06]# sed -nr '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' ifcfg-eth0|cut -d'=' -f2
10.1.1.1
255.255.255.0
10.1.1.254
[root@server shell06]# sed -nr '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' ifcfg-eth0|sed -n 's/[A-Z=]//gp'
10.1.1.1
255.255.255.0
10.1.1.254

[root@server shell06]# ifconfig eth0|sed -n '2p'|sed -n 's/[:a-Z]//gp'|sed -n 's/ /\n/gp'|sed '/^$/d'
10.1.1.1
10.1.1.255
255.255.255.0
[root@server shell06]# ifconfig | sed -nr '/([0-9]{1,3}\.)[0-9]{1,3}/p' | head -1|sed -r 's/([a-z:]|[A-Z/t])//g'|sed 's/ /\n/g'|sed  '/^$/d'

[root@server shell06]# ifconfig eth0|sed -n '2p'|sed -n 's/.*addr:\(.*\) Bcast:\(.*\) Mask:\(.*\)/\1\n\2\n\3/p'
10.1.1.1 
10.1.1.255 
255.255.255.0

-i 选项  直接修改原文件
# sed -i 's/root/ROOT/;s/stu/STU/' 11.txt
# sed -i '17{s/YUNWEI/yunwei/;s#/bin/bash#/sbin/nologin#}' 1.txt
# sed -i '1,5s/^/#&/' a.txt
注意：
-ni  不要一起使用
p命令 不要再使用-i时使用
```

##### ⑤ ==sed结合正则使用==

> sed  选项  =='==sed==命令==或者==正则表达式==或者==地址定位===='==  文件名

1. 定址用于决定对哪些行进行编辑。地址的形式可以是数字、正则表达式、或二者的结合。
2. 如果没有指定地址，sed将处理输入文件的所有行。

| 正则          | 说明                                                         | 备注                             |
| ------------- | ------------------------------------------------------------ | -------------------------------- |
| /key/         | 查询包含关键字的行                                           | sed -n '/root/p' 1.txt           |
| /key1/,/key2/ | 匹配包含两个关键字之间的行                                   | sed -n '/\^adm/,/^mysql/p' 1.txt |
| /key/,x       | 从匹配关键字的行开始到==文件第x行==之间的行（包含关键字所在行） | sed -n '/^ftp/,7p'               |
| x,/key/       | 从文件的第x行开始到与关键字的匹配行之间的行                  |                                  |
| x,y!          | 不包含x到y行                                                 |                                  |
| /key/!        | 不包括关键字的行                                             | sed -n '/bash$/!p' 1.txt         |

###2. 脚本格式

#### ㈠ 用法

~~~powershell
# sed -f scripts.sh  file		//使用脚本处理文件
建议使用   ./sed.sh   file

脚本的第一行写上
#!/bin/sed -f
1,5d
s/root/hello/g
3i777
5i888
a999
p
~~~

#### ㈡ 注意事项

~~~powershell
１）　脚本文件是一个sed的命令行清单。'commands'
２）　在每行的末尾不能有任何空格、制表符（tab）或其它文本。
３）　如果在一行中有多个命令，应该用分号分隔。
４）　不需要且不可用引号保护命令
５）　#号开头的行为注释

~~~

#### ㈢举例说明

~~~powershell
# cat passwd
stu3:x:509:512::/home/user3:/bin/bash
stu4:x:510:513::/home/user4:/bin/bash
stu5:x:511:514::/home/user5:/bin/bash

# cat sed.sh 
#!/bin/sed -f
2a\
******************
2,$s/stu/user/
$a\
we inster new line
s/^[a-z].*/#&/

# cat 1.sed 
#!/bin/sed -f
3a**********************
$chelloworld
1,3s/^/#&/

# sed -f 1.sed -i 11.txt 
# cat 11.txt 
#root:x:0:0:root:/root:/bin/bash
#bin:x:1:1:bin:/bin:/sbin/nologin
#daemon:x:2:2:daemon:/sbin:/sbin/nologin
**********************
adm:x:3:4:adm:/var/adm:/sbin/nologin
helloworld

~~~

###3. 补充扩展总结

~~~powershell
1、正则表达式必须以”/“前后规范间隔
例如：sed '/root/d' file
例如：sed '/^root/d' file

2、如果匹配的是扩展正则表达式，需要使用-r选来扩展sed
grep -E
sed -r
+ ? () {n,m} | \d

注意：         
在正则表达式中如果出现特殊字符(^$.*/[]),需要以前导 "\" 号做转义
eg：sed '/\$foo/p' file

3、逗号分隔符
例如：sed '5,7d' file  				删除5到7行
例如：sed '/root/,/ftp/d' file	
删除第一个匹配字符串"root"到第一个匹配字符串"ftp"的所有行本行不找 循环执行
       
4、组合方式
例如：sed '1,/foo/d' file			删除第一行到第一个匹配字符串"foo"的所有行
例如：sed '/foo/,+4d' file			删除从匹配字符串”foo“开始到其后四行为止的行
例如：sed '/foo/,~3d' file			删除从匹配字符串”foo“开始删除到3的倍数行（文件中）
例如：sed '1~5d' file				从第一行开始删每五行删除一行
例如：sed -nr '/foo|bar/p' file	显示配置字符串"foo"或"bar"的行
例如：sed -n '/foo/,/bar/p' file	显示匹配从foo到bar的行
例如：sed '1~2d'  file				删除奇数行
例如：sed '0-2d'   file				删除偶数行 sed '1~2!d'  file

5、特殊情况
例如：sed '$d' file					删除最后一行
例如：sed '1d' file					删除第一行
	
6、其他：
sed 's/.//' a.txt						删除每一行中的第一个字符
sed 's/.//2' a.txt					删除每一行中的第二个字符
sed 's/.//N' a.txt					从文件中第N行开始，删除每行中第N个字符（N>2）
sed 's/.$//' a.txt					删除每一行中的最后一个字符


# cat 2.txt 
1 a
2 b
3 c
4 d
5 e
6 f
7 u
8 k
9 o
# sed '/c/,~2d' 2.txt 
1 a
2 b
5 e
6 f
7 u
8 k
9 o

~~~

###练习

1. 将任意数字替换成空或者制表符
2. 去掉文件1-5行中的数字、冒号、斜杠
3. 匹配root关键字替换成hello itcast，并保存到test.txt文件中
4. 删除vsftpd.conf、smb.conf、main.cf配置文件里所有注释的行及空行（不要直接修改原文件）
5. 使用sed命令截取自己的ip地址
6. 使用sed命令一次性截取ip地址、广播地址、子网掩码
7. 注释掉文件的2-3行和匹配到以root开头或者以ftp开头的行

~~~powershell

1、将文件中任意数字替换成空或者制表符
2、去掉文件1-5行中的数字、冒号、斜杠
3、匹配root关键字的行替换成hello itcast，并保存到test.txt文件中
4、删除vsftpd.conf、smb.conf、main.cf配置文件里所有注释的行及空行（不要直接修改原文件）
5、使用sed命令截取自己的ip地址
# ifconfig eth0|sed -n '2p'|sed -n 's/.*addr://pg'|sed -n 's/Bcast.*//gp'
10.1.1.1  
# ifconfig eth0|sed -n '2p'|sed 's/.*addr://g'|sed 's/ Bcast:.*//g'
6、使用sed命令一次性截取ip地址、广播地址、子网掩码
# ifconfig eth0|sed -n '2p'|sed -n 's#.*addr:\(.*\) Bcast:\(.*\) Mask:\(.*\)#\1\n\2\n\3#p'
10.1.1.1 
10.1.1.255 
255.255.255.0

7、注释掉文件的2-3行和匹配到以root开头或者以ftp开头的行
# sed -nr '2,3s/^/#&/p;s/^ROOT|^ftp/#&/p' 1.txt
#ROOT:x:0:0:root:/root:/bin/bash
#bin:x:1:1:bin:/bin:/sbin/nologin
#3daemon:x:2:2:daemon:/sbin:/sbin/nologin

# sed -ne '1,2s/^/#&/gp' a.txt -nre 's/^lp|^mail/#&/gp'
# sed -nr '1,2s/^/#&/gp;s/^lp|^mail/#&/gp' a.txt
~~~

---

1、写一个初始化系统的脚本
1）自动修改主机名（如：ip是192.168.0.88，则主机名改为server88.itcast.cc）

a. 更改文件非交互式 sed

/etc/sysconfig/network

b.将本主机的IP截取出来赋值给一个变量ip;再然后将ip变量里以.分割的最后一位赋值给另一个变量ip1

2）自动配置可用的yum源

3）自动关闭防火墙和selinux

2、写一个搭建ftp服务的脚本，要求如下：
1）不支持本地用户登录		local_enable=NO
2） 匿名用户可以上传 新建 删除	 anon_upload_enable=YES  anon_mkdir_write_enable=YES	
3） 匿名用户限速500KBps  anon_max_rate=500000

```powershell
仅供参考：
#!/bin/bash
ipaddr=`ifconfig eth0|sed -n '2p'|sed -e 's/.*inet addr:\(.*\) Bcast.*/\1/g'`
iptail=`echo $ipaddr|cut -d'.' -f4`
ipremote=192.168.1.10
#修改主机名
hostname server$iptail.itcast.com
sed -i "/HOSTNAME/cHOSTNAME=server$iptail.itcast.com" /etc/sysconfig/network
echo "$ipaddr server$iptail.itcast.cc" >>/etc/hosts
#关闭防火墙和selinux
service iptables stop
setenforce 0 >/dev/null 2>&1
sed -i '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
#配置yum源(一般是内网源)
#test network
ping -c 1 $ipremote > /dev/null 2>&1
if [ $? -ne 0 ];then
	echo "你的网络不通，请先检查你的网络"
	exit 1
else
	echo "网络ok."
fi
cat > /etc/yum.repos.d/server.repo << end
[server]
name=server
baseurl=ftp://$ipremote
enabled=1
gpgcheck=0
end

#安装软件
read -p "请输入需要安装的软件，多个用空格隔开：" soft
yum -y install $soft &>/dev/null

#备份配置文件
conf=/etc/vsftpd/vsftpd.conf
\cp $conf $conf.default
#根据需求修改配置文件
sed -ir '/^#|^$/d' $conf
sed -i '/local_enable/c\local_enable=NO' $conf
sed -i '$a anon_upload_enable=YES' $conf
sed -i '$a anon_mkdir_write_enable=YES' $conf
sed -i '$a anon_other_write_enable=YES' $conf
sed -i '$a anon_max_rate=512000' $conf
#启动服务
service vsftpd restart &>/dev/null && echo"vsftpd服务启动成功"

#测试验证
chmod 777 /var/ftp/pub
cp /etc/hosts /var/ftp/pub
#测试下载
cd /tmp
lftp $ipaddr <<end
cd pub
get hosts
exit
end

if [ -f /tmp/hosts ];then
	echo "匿名用户下载成功"
	rm -f /tmp/hosts
else
	echo "匿名用户下载失败"
fi
#测试上传、创建目录、删除目录等
cd /tmp
lftp $ipaddr << end
cd pub
mkdir test1
mkdir test2
put /etc/group
rmdir test2
exit
end

if [ -d /var/ftp/pub/test1 ];then
    echo "创建目录成功"
	if [ ! -d /var/ftp/pub/test2 ];then
    	echo "文件删除成功"
        fi
else
	if [ -f /var/ftp/pub/group ];then
	echo "文件上传成功"
        else
        echo "上传、创建目录删除目录部ok"
        fi 
fi   
[ -f /var/ftp/pub/group ] && echo "上传文件成功"
```

## 三、awk

### 简介

- awk是一种==编程语言==，主要用于在linux/unix下对==文本和数据==进行处理，是linux/unix下的一个工具。数据可以来自标准输入、一个或多个文件，或其它命令的输出。
- awk的处理文本和数据的方式：**==逐行扫描==文件**，默认从第一行到最后一行，寻找匹配的==特定模式==的行，并在这些行上进行你想要的操作。
- awk分别代表其作者姓氏的第一个字母。因为它的作者是三个人，分别是Alfred Aho、Brian Kernighan、Peter Weinberger。
- gawk是awk的GNU版本，它提供了Bell实验室和GNU的一些扩展。


- 下面介绍的awk是以GNU的gawk为例的，在linux系统中已把awk链接到gawk，所以下面全部以awk进行介绍。

**作用：**

1. awk==用来处理文件和数据==的，是类unix下的一个工具，也是一种编程语言
2. 可以用来==统计数据==，比如网站的访问量，访问的IP量等等
3. 支持条件判断，支持for和while循环

### 1. ==命令行模式使用==

#### ㈠ 语法结构

```powershell
awk 选项 '命令部分' 文件名

特别说明：
引用shell变量需用双引号引起
```

####㈡ 常用选项介绍

- ==-F==  定义字段分割符号，默认的分隔符是==空格==
- -v  定义变量并赋值

####㈢  **=='==**命名部分说明**=='==**

- 正则表达式，地址定位

```powershell
'/root/{awk语句}'				sed中： '/root/p'
'NR==1,NR==5{awk语句}'			sed中： '1,5p'
'/^root/,/^ftp/{awk语句}'  	sed中：'/^root/,/^ftp/p'
```

- {awk语句1**==;==**awk语句2**==;==**...}

```powershell
'{print $0;print $1}'		sed中：'p'
'NR==5{print $0}'				sed中：'5p'
注：awk命令语句间用分号间隔
```

- BEGIN...END....

```powershell
'BEGIN{awk语句};{处理中};END{awk语句}'
'BEGIN{awk语句};{处理中}'
'{处理中};END{awk语句}'
```

### 2. 脚本模式使用

#### ㈠ 脚本编写

```powershell
#!/bin/awk -f 		定义魔法字符
以下是awk引号里的命令清单，不要用引号保护命令，多个命令用分号间隔
BEGIN{FS=":"}
NR==1,NR==3{print $1"\t"$NF}
...
```

#### ㈡ 脚本执行

```powershell
方法1：
awk 选项 -f awk的脚本文件  要处理的文本文件
awk -f awk.sh filename

sed -f sed.sh -i filename

方法2：
./awk的脚本文件(或者绝对路径)	要处理的文本文件
./awk.sh filename

./sed.sh filename
```

### 三、 awk内部相关变量

| 变量              | 变量说明                           | 备注                             |
| ----------------- | ---------------------------------- | -------------------------------- |
| ==$0==            | 当前处理行的所有记录               |  |
| ==\$1,\$2,\$3...\$n== | 文件中每行以==间隔符号==分割的不同字段 | awk -F: '{print \$1,\$3}' |
| ==NF==            | 当前记录的字段数（列数）           | awk -F: '{print NF}' |
| ==$NF==           | 最后一列                           | $(NF-1)表示倒数第二列            |
| ==FNR/NR==        | 行号                               |                                  |
| ==FS==            | 定义间隔符                         | 'BEGIN{FS=":"};{print \$1,$3}' |
| ==OFS==           | 定义输出字段分隔符，==默认空格==   | 'BEGIN{OFS="\t"};print \$1,$3}' |
| RS                | 输入记录分割符，默认换行           | 'BEGIN{RS="\t"};{print $0}'      |
| ORS               | 输出记录分割符，默认换行           | 'BEGIN{ORS="\n\n"};{print \$1,$3}' |
| FILENAME          | 当前输入的文件名                   |                                  |

#### 1、==常用内置变量举例==

```powershell
# awk -F: '{print $1,$(NF-1)}' 1.txt
# awk -F: '{print $1,$(NF-1),$NF,NF}' 1.txt
# awk '/root/{print $0}' 1.txt
# awk '/root/' 1.txt
# awk -F: '/root/{print $1,$NF}' 1.txt 
root /bin/bash
# awk -F: '/root/{print $0}' 1.txt      
root:x:0:0:root:/root:/bin/bash
# awk 'NR==1,NR==5' 1.txt 
# awk 'NR==1,NR==5{print $0}' 1.txt
# awk 'NR==1,NR==5;/^root/{print $0}' 1.txt 
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

```

#### 2、内置变量分隔符举例

```powershell
FS和OFS:
# awk 'BEGIN{FS=":"};/^root/,/^lp/{print $1,$NF}' 1.txt
# awk -F: 'BEGIN{OFS="\t\t"};/^root/,/^lp/{print $1,$NF}' 1.txt        
root            /bin/bash
bin             /sbin/nologin
daemon          /sbin/nologin
adm             /sbin/nologin
lp              /sbin/nologin
# awk -F: 'BEGIN{OFS="@@@"};/^root/,/^lp/{print $1,$NF}' 1.txt     
root@@@/bin/bash
bin@@@/sbin/nologin
daemon@@@/sbin/nologin
adm@@@/sbin/nologin
lp@@@/sbin/nologin
[root@server shell07]# 

RS和ORS：
修改源文件前2行增加制表符和内容：
vim 1.txt
root:x:0:0:root:/root:/bin/bash hello   world
bin:x:1:1:bin:/bin:/sbin/nologin        test1   test2

# awk 'BEGIN{RS="\t"};{print $0}' 1.txt
# awk 'BEGIN{ORS="\t"};{print $0}' 1.txt
```

###四、 awk工作原理

`awk -F: '{print $1,$3}' /etc/passwd`

1. awk使用一行作为输入，并将这一行赋给内部变量$0，每一行也可称为一个记录，以换行符(RS)结束

2. 每行被间隔符**==:==**(默认为空格或制表符)分解成字段(或域)，每个字段存储在已编号的变量中，从$1开始

   问：awk如何知道用空格来分隔字段的呢？

   答：因为有一个内部变量==FS==来确定字段分隔符。初始时，FS赋为空格

3. awk使用print函数打印字段，打印出来的字段会以==空格分隔==，因为\$1,\$3之间有一个逗号。逗号比较特殊，它映射为另一个内部变量，称为==输出字段分隔符==OFS，OFS默认为空格

4. awk处理完一行后，将从文件中获取另一行，并将其存储在$0中，覆盖原来的内容，然后将新的字符串分隔成字段并进行处理。该过程将持续到所有行处理完毕

### 五、awk使用进阶

#### 1. 格式化输出`print`和`printf`

```powershell
print函数		类似echo "hello world"
# date |awk '{print "Month: "$2 "\nYear: "$NF}'
# awk -F: '{print "username is: " $1 "\t uid is: "$3}' /etc/passwd


printf函数		类似echo -n
# awk -F: '{printf "%-15s %-10s %-15s\n", $1,$2,$3}'  /etc/passwd
# awk -F: '{printf "|%15s| %10s| %15s|\n", $1,$2,$3}' /etc/passwd
# awk -F: '{printf "|%-15s| %-10s| %-15s|\n", $1,$2,$3}' /etc/passwd

awk 'BEGIN{FS=":"};{printf "%-15s %-15s %-15s\n",$1,$6,$NF}' a.txt

%s 字符类型  strings			%-20s
%d 数值类型	
占15字符
- 表示左对齐，默认是右对齐
printf默认不会在行尾自动换行，加\n
```

#### 2. awk变量定义

~~~powershell
# awk -v NUM=3 -F: '{ print $NUM }' /etc/passwd
# awk -v NUM=3 -F: '{ print NUM }' /etc/passwd
# awk -v num=1 'BEGIN{print num}' 
1
# awk -v num=1 'BEGIN{print $num}' 
注意：
awk中调用定义的变量不需要加$
~~~

####3. awk中BEGIN...END使用

​	①==BEGIN==：表示在==程序开始前==执行

​	②==END== ：表示所有文件==处理完后==执行

​	③用法：`'BEGIN{开始处理之前};{处理中};END{处理结束后}'`

##### ㈠ 举例说明1

**打印最后一列和倒数第二列（登录shell和家目录）**

~~~powershell
awk -F: 'BEGIN{ print "Login_shell\t\tLogin_home\n*******************"};{print $NF"\t\t"$(NF-1)};END{print "************************"}' 1.txt

awk 'BEGIN{ FS=":";print "Login_shell\tLogin_home\n*******************"};{print $NF"\t"$(NF-1)};END{print "************************"}' 1.txt

Login_shell		Login_home
************************
/bin/bash		/root
/sbin/nologin		/bin
/sbin/nologin		/sbin
/sbin/nologin		/var/adm
/sbin/nologin		/var/spool/lpd
/bin/bash		/home/redhat
/bin/bash		/home/user01
/sbin/nologin		/var/named
/bin/bash		/home/u01
/bin/bash		/home/YUNWEI
************************************
~~~

##### ㈡ 举例说明2

**打印/etc/passwd里的用户名、家目录及登录shell**

```powershell
u_name      h_dir       shell
***************************

***************************

awk -F: 'BEGIN{OFS="\t\t";print"u_name\t\th_dir\t\tshell\n***************************"};{printf "%-20s %-20s %-20s\n",$1,$(NF-1),$NF};END{print "****************************"}'


# awk -F: 'BEGIN{print "u_name\t\th_dir\t\tshell" RS "*****************"}  {printf "%-15s %-20s %-20s\n",$1,$(NF-1),$NF}END{print "***************************"}'  /etc/passwd

格式化输出：
echo		print
echo -n	printf

{printf "%-15s %-20s %-20s\n",$1,$(NF-1),$NF}
```

####4. awk和正则的综合运用

| 运算符 | 说明     |
| ------ | -------- |
| ==     | 等于     |
| !=     | 不等于   |
| >      | 大于     |
| <      | 小于     |
| >=     | 大于等于 |
| <=     | 小于等于 |
| ~      | 匹配     |
| !~     | 不匹配   |
| !      | 逻辑非   |
| &&     | 逻辑与   |
| \|\|   | 逻辑或   |

##### ㈠ 举例说明

~~~powershell
从第一行开始匹配到以lp开头行
awk -F: 'NR==1,/^lp/{print $0 }' passwd  
从第一行到第5行          
awk -F: 'NR==1,NR==5{print $0 }' passwd
从以lp开头的行匹配到第10行       
awk -F: '/^lp/,NR==10{print $0 }' passwd 
从以root开头的行匹配到以lp开头的行       
awk -F: '/^root/,/^lp/{print $0}' passwd
打印以root开头或者以lp开头的行            
awk -F: '/^root/ || /^lp/{print $0}' passwd
awk -F: '/^root/;/^lp/{print $0}' passwd
显示5-10行   
awk -F':' 'NR>=5 && NR<=10 {print $0}' /etc/passwd     
awk -F: 'NR<10 && NR>5 {print $0}' passwd 

打印30-39行以bash结尾的内容：
[root@MissHou shell06]# awk 'NR>=30 && NR<=39 && $0 ~ /bash$/{print $0}' passwd 
stu1:x:500:500::/home/stu1:/bin/bash
yunwei:x:501:501::/home/yunwei:/bin/bash
user01:x:502:502::/home/user01:/bin/bash
user02:x:503:503::/home/user02:/bin/bash
user03:x:504:504::/home/user03:/bin/bash

[root@MissHou shell06]# awk 'NR>=3 && NR<=8 && /bash$/' 1.txt  
stu7:x:1007:1007::/rhome/stu7:/bin/bash
stu8:x:1008:1008::/rhome/stu8:/bin/bash
stu9:x:1009:1009::/rhome/stu9:/bin/bash

打印文件中1-5并且以root开头的行
[root@MissHou shell06]# awk 'NR>=1 && NR<=5 && $0 ~ /^root/{print $0}' 1.txt
root:x:0:0:root:/root:/bin/bash
[root@MissHou shell06]# awk 'NR>=1 && NR<=5 && $0 !~ /^root/{print $0}' 1.txt
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin


理解;号和||的含义：
[root@MissHou shell06]# awk 'NR>=3 && NR<=8 || /bash$/' 1.txt
[root@MissHou shell06]# awk 'NR>=3 && NR<=8;/bash$/' 1.txt


打印IP地址
# ifconfig eth0|awk 'NR>1 {print $2}'|awk -F':' 'NR<2 {print $2}'    
# ifconfig eth0|grep Bcast|awk -F':' '{print $2}'|awk '{print $1}'
# ifconfig eth0|grep Bcast|awk '{print $2}'|awk -F: '{print $2}'


# ifconfig eth0|awk NR==2|awk -F '[ :]+' '{print $4RS$6RS$8}'
# ifconfig eth0|awk -F"[ :]+" '/inet addr:/{print $4}'
~~~

**课堂练习**

1. 显示可以登录操作系统的用户所有信息     从第7列匹配以bash结尾，输出整行（当前行所有的列）

```powershell
[root@MissHou ~] awk '/bash$/{print $0}'    /etc/passwd
[root@MissHou ~] awk '/bash$/{print $0}' /etc/passwd
[root@MissHou ~] awk '/bash$/' /etc/passwd
[root@MissHou ~] awk -F: '$7 ~ /bash/' /etc/passwd
[root@MissHou ~] awk -F: '$NF ~ /bash/' /etc/passwd
[root@MissHou ~] awk -F: '$0 ~ /bash/' /etc/passwd
[root@MissHou ~] awk -F: '$0 ~ /\/bin\/bash/' /etc/passwd
```

2. 显示可以登录系统的用户名 

```powershell
# awk -F: '$0 ~ /\/bin\/bash/{print $1}' /etc/passwd
```

3. 打印出系统中普通用户的UID和用户名

```powershell
500	stu1
501	yunwei
502	user01
503	user02
504	user03


# awk -F: 'BEGIN{print "UID\tUSERNAME"} {if($3>=500 && $3 !=65534 ) {print $3"\t"$1} }' /etc/passwdUID	USERNAME


# awk -F: '{if($3 >= 500 && $3 != 65534) print $1,$3}' a.txt 
redhat 508
user01 509
u01 510
YUNWEI 511
```

####5. awk的脚本编程

##### ㈠ 流程控制语句

##### ① if结构

```powershell
if语句：

if [ xxx ];then
xxx
fi

格式：
awk 选项 '正则，地址定位{awk语句}'  文件名

{ if(表达式)｛语句1;语句2;...｝}

awk -F: '{if($3>=500 && $3<=60000) {print $1,$3} }' passwd

# awk -F: '{if($3==0) {print $1"是管理员"} }' passwd 
root是管理员

# awk 'BEGIN{if('$(id -u)'==0) {print "admin"} }'
admin
```

##### ② if...else结构

```powershell
if...else语句:
if [ xxx ];then
	xxxxx
	
else
	xxx
fi

格式：
{if(表达式)｛语句;语句;...｝else｛语句;语句;...}}

awk -F: '{ if($3>=500 && $3 != 65534) {print $1"是普通用户"} else {print $1,"不是普通用户"}}' passwd 

awk 'BEGIN{if( '$(id -u)'>=500 && '$(id -u)' !=65534 ) {print "是普通用户"} else {print "不是普通用户"}}'

```

##### ③ if...elif...else结构

```powershell
if [xxxx];then
	xxxx
elif [xxx];then
	xxx
....
else
...
fi


if...else if...else语句：

格式：
{ if(表达式1)｛语句;语句；...｝else if(表达式2)｛语句;语句；...｝else if(表达式3)｛语句;语句；...｝else｛语句;语句；...｝}

awk -F: '{ if($3==0) {print $1,":是管理员"} else if($3>=1 && $3<=499 || $3==65534 ) {print $1,":是系统用户"} else {print $1,":是普通用户"}}'


awk -F: '{ if($3==0) {i++} else if($3>=1 && $3<=499 || $3==65534 ) {j++} else {k++}};END{print "管理员个数为:"i "\n系统用户个数为:"j"\n普通用户的个数为:"k }'


# awk -F: '{if($3==0) {print $1,"is admin"} else if($3>=1 && $3<=499 || $3==65534) {print $1,"is sys users"} else {print $1,"is general user"} }' a.txt 

root is admin
bin is sys users
daemon is sys users
adm is sys users
lp is sys users
redhat is general user
user01 is general user
named is sys users
u01 is general user
YUNWEI is general user

awk -F: '{  if($3==0) {print $1":管理员"} else if($3>=1 && $3<500 || $3==65534 ) {print $1":是系统用户"} else {print $1":是普通用户"}}'   /etc/passwd


awk -F: '{if($3==0) {i++} else if($3>=1 && $3<500 || $3==65534){j++} else {k++}};END{print "管理员个数为:" i RS "系统用户个数为:"j RS "普通用户的个数为:"k }' /etc/passwd
管理员个数为:1
系统用户个数为:28
普通用户的个数为:27


# awk -F: '{ if($3==0) {print $1":是管理员"} else if($3>=500 && $3!=65534) {print $1":是普通用户"} else {print $1":是系统用户"}}' passwd 

awk -F: '{if($3==0){i++} else if($3>=500){k++} else{j++}} END{print i; print k; print j}' /etc/passwd

awk -F: '{if($3==0){i++} else if($3>999){k++} else{j++}} END{print "管理员个数: "i; print "普通用个数: "k; print "系统用户: "j}' /etc/passwd 

如果是普通用户打印默认shell，如果是系统用户打印用户名
# awk -F: '{if($3>=1 && $3<500 || $3 == 65534) {print $1} else if($3>=500 && $3<=60000 ) {print $NF} }' /etc/passwd
```

##### ㈡ 循环语句

##### ① for循环

```powershell
打印1~5
for ((i=1;i<=5;i++));do echo $i;done

# awk 'BEGIN { for(i=1;i<=5;i++) {print i} }'
打印1~10中的奇数
# for ((i=1;i<=10;i+=2));do echo $i;done|awk '{sum+=$0};END{print sum}'
# awk 'BEGIN{ for(i=1;i<=10;i+=2) {print i} }'
# awk 'BEGIN{ for(i=1;i<=10;i+=2) print i }'

计算1-5的和
# awk 'BEGIN{sum=0;for(i=1;i<=5;i++) sum+=i;print sum}'
# awk 'BEGIN{for(i=1;i<=5;i++) (sum+=i);{print sum}}'
# awk 'BEGIN{for(i=1;i<=5;i++) (sum+=i);print sum}'
```

##### ② while循环

```powershell
打印1-5
# i=1;while (($i<=5));do echo $i;let i++;done

# awk 'BEGIN { i=1;while(i<=5) {print i;i++} }'
打印1~10中的奇数
# awk 'BEGIN{i=1;while(i<=10) {print i;i+=2} }'
计算1-5的和
# awk 'BEGIN{i=1;sum=0;while(i<=5) {sum+=i;i++}; print sum }'
# awk 'BEGIN {i=1;while(i<=5) {(sum+=i) i++};print sum }'
```

##### ③ 嵌套循环

~~~powershell
嵌套循环：
#!/bin/bash
for ((y=1;y<=5;y++))
do
	for ((x=1;x<=$y;x++))
	do
		echo -n $x	
	done
echo
done

awk 'BEGIN{ for(y=1;y<=5;y++) {for(x=1;x<=y;x++) {printf x} ;print } }'


# awk 'BEGIN { for(y=1;y<=5;y++) { for(x=1;x<=y;x++) {printf x};print} }'
1
12
123
1234
12345

# awk 'BEGIN{ y=1;while(y<=5) { for(x=1;x<=y;x++) {printf x};y++;print}}'
1
12
123
1234
12345

尝试用三种方法打印99口诀表：
#awk 'BEGIN{for(y=1;y<=9;y++) { for(x=1;x<=y;x++) {printf x"*"y"="x*y"\t"};print} }'

#awk 'BEGIN{for(y=1;y<=9;y++) { for(x=1;x<=y;x++) printf x"*"y"="x*y"\t";print} }'
#awk 'BEGIN{i=1;while(i<=9){for(j=1;j<=i;j++) {printf j"*"i"="j*i"\t"};print;i++ }}'

#awk 'BEGIN{for(i=1;i<=9;i++){j=1;while(j<=i) {printf j"*"i"="i*j"\t";j++};print}}'

循环的控制：
break		条件满足的时候中断循环
continue	条件满足的时候跳过循环
# awk 'BEGIN{for(i=1;i<=5;i++) {if(i==3) break;print i} }'
1
2
# awk 'BEGIN{for(i=1;i<=5;i++){if(i==3) continue;print i}}'
1
2
4
5
~~~

####6. awk算数运算

~~~powershell
+ - * / %(模) ^(幂2^3)
可以在模式中执行计算，awk都将按浮点数方式执行算术运算
# awk 'BEGIN{print 1+1}'
# awk 'BEGIN{print 1**1}'
# awk 'BEGIN{print 2**3}'
# awk 'BEGIN{print 2/3}'
~~~

### 六、awk统计案例

#### 1、统计系统中各种类型的shell

```powershell
# awk -F: '{ shells[$NF]++ };END{for (i in shells) {print i,shells[i]} }' /etc/passwd

books[linux]++
books[linux]=1
shells[/bin/bash]++
shells[/sbin/nologin]++

/bin/bash 5
/sbin/nologin 6

shells[/bin/bash]++			a
shells[/sbin/nologin]++		b
shells[/sbin/shutdown]++	c

books[linux]++
books[php]++

```

#### 2、统计网站访问状态

```powershell
# ss -antp|grep 80|awk '{states[$1]++};END{for(i in states){print i,states[i]}}'
TIME_WAIT 578
ESTABLISHED 1
LISTEN 1

# ss -an |grep :80 |awk '{states[$2]++};END{for(i in states){print i,states[i]}}'
LISTEN 1
ESTAB 5
TIME-WAIT 25

# ss -an |grep :80 |awk '{states[$2]++};END{for(i in states){print i,states[i]}}' |sort -k2 -rn
TIME-WAIT 18
ESTAB 8
LISTEN 1

```

#### 3、统计访问网站的每个IP的数量

```powershell
# netstat -ant |grep :80 |awk -F: '{ip_count[$8]++};END{for(i in ip_count){print i,ip_count[i]} }' |sort


# ss -an |grep :80 |awk -F":" '!/LISTEN/{ip_count[$(NF-1)]++};END{for(i in ip_count){print i,ip_count[i]}}' |sort -k2 -rn |head
```

#### 4、统计网站日志中PV量

```powershell
统计Apache/Nginx日志中某一天的PV量 　<统计日志>
# grep '27/Jul/2017' mysqladmin.cc-access_log |wc -l
14519

统计Apache/Nginx日志中某一天不同IP的访问量　<统计日志>
# grep '27/Jul/2017' mysqladmin.cc-access_log |awk '{ips[$1]++};END{for(i in ips){print i,ips[i]} }' |sort -k2 -rn |head

# grep '07/Aug/2017' access.log |awk '{ips[$1]++};END{for(i in ips){print i,ips[i]} }' |awk '$2>100' |sort -k2 -rn

```

**名词解释：**

==网站浏览量（PV）==
名词：PV=PageView (网站浏览量)
说明：指页面的浏览次数，用以衡量网站用户访问的网页数量。多次打开同一页面则浏览量累计。用户每打开一个页面便记录1次PV。

名词：VV = Visit View（访问次数）
说明：从访客来到您网站到最终关闭网站的所有页面离开，计为1次访问。若访客连续30分钟没有新开和刷新页面，或者访客关闭了浏览器，则被计算为本次访问结束。

独立访客（UV）
名词：UV= Unique Visitor（独立访客数）
说明：1天内相同的访客多次访问您的网站只计算1个UV。

独立IP（IP）
名词：IP=独立IP数
说明：指1天内使用不同IP地址的用户访问网站的数量。同一IP无论访问了几个页面，独立IP数均为1

###七、课后作业

**作业1：**
1、写一个自动检测磁盘使用率的脚本，当磁盘使用空间达到90%以上时，需要发送邮件给相关人员
2、写一个脚本监控系统内存和交换分区使用情况

**作业2：**
输入一个IP地址，使用脚本判断其合法性：
必须符合ip地址规范，第1、4位不能以0开头，不能大于255不能小于0

###八、企业实战案例

#### 1. 任务/背景

web服务器集群中总共有9台机器，上面部署的是Apache服务。由于业务不断增长，每天每台机器上都会产生大量的访问日志，现需要将每台web服务器上的apache访问日志**保留最近3天**的，3天以前的日志**转储**到一台专门的日志服务器上，已做后续分析。如何实现每台服务器上只保留3天以内的日志？

#### 2. 具体要求

1. 每台web服务器的日志对应日志服务器相应的目录里。如：web1——>web1.log（在日志服务器上）
2. 每台web服务器上保留最近3天的访问日志，3天以前的日志每天凌晨5:03分转储到日志服务器
3. 如果脚本转储失败，运维人员需要通过跳板机的菜单选择手动清理日志

#### 3. 涉及知识点

1. shell的基本语法结构
2. 文件同步rsync
3. 文件查找命令find
4. 计划任务crontab
5. apache日志切割
6. 其他


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

##3 、常用的通配符

~~~powershell
*:	匹配0或多个任意字符
?:	匹配任意单个字符
[list]:	匹配[list]中的任意单个字符,或者一组单个字符   [a-z]
[!list]: 反向选择
{string1,string2,...}：匹配string1,string2或更多字符串
~~~

# ==《变量篇》==

## 一、SHELL介绍

**前言：**

计算机只能认识（识别）机器语言(0和1)，如（11000000 这种）。但是，我们的程序猿们不能直接去写01这样的代码，所以，要想将程序猿所开发的代码在计算机上运行，就必须找"人"（工具）来翻译成机器语言，这个"人"(工具)就是我们常常所说的**编译器**或者**解释器**。

<img src="/编译和解释型语言区别.png" alt="编译和解释型语言区别" style="zoom: 67%;" />

###1. 编程语言分类

- **编译型语言：**

​    程序在执行之前需要一个专门的编译过程，把程序编译成为机器语言文件，运行时不需要重新翻译，直接使用编译的结果就行了。程序执行效率高，依赖编译器，跨平台性差些。如C、C++、java

- **解释型语言：**

​    程序不需要编译，程序在运行时由**==解释器==**翻译成机器语言，每执行一次都要翻译一次。因此效率比较低。比如Python/JavaScript/ Perl /ruby/==Shell==等都是解释型语言。

![./语言分类](语言分类.png)

- **总结**

编译型语言比解释型语言==速度较快==，但是不如解释型语言==跨平台性好==。如果做底层开发或者大型应用程序或者操作系开发一==般都用编译型语言==；如果是一些服务器脚本及一些辅助的接口，对速度要求不高、对各个平台的==兼容性有要求==的话则一般都用==解释型语言==。

###2. shell简介

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

###3. shell脚本

#### ㈥ shell脚本的三部分

1）**第一部分**：魔法字符`#!`指定解释器

`#!/bin/bash`  ==表示以下内容使用/bin/bash解释器解析==

**注意：**
如果直接将解释器路径写死在脚本里，可能在某些系统就会存在找不到解释器的兼容性问题，所以可以使用:`#!/bin/env bash`

==2）**第二部分：**注释==

3）**第三部分**：功能

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



#### ㈦ shell脚本的执行方法

1. ` ./first_shell.sh`（标准脚本执行方法,建议）
2. 指定解释器执行

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

## 二、变量
### ==1. 定义变量的方式==

注：==等号两边不能有空格，shell中只有变量定义的时候=两边是不需要空格，其他时候都需要==

#### ㈠ 基本方式

**变量名=变量值** 

```sh
# A=hello			定义变量A
# A="hello world"	#对于有空格的字符串给变量赋值时，要用引号引起来
# A='hello world'
# unset A			取消变量
```

#### ㈡ 命令执行结果赋值给变量

```powershell
# B=`date +%F`
# C=$(uname -r)
# echo $C
2.6.32-696.el6.x86_64  --> 内核版本
```

#### ㈢ 交互式定义变量(read)

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

#### ㈣ 定义有类型的变量(declare)

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

### 2. 变量的定义规则

㈠ 变量名区分大小写

㈡ 变量名不能有特殊符号(*?@#)

㈢ 变量名不能以数字开头

### 3.调用变量

`$A	和	echo ${A}`

```powershell
${}可以截取变量中一部分
# echo ${A:2:4}		表示从A变量中第3个字符开始截取，截取4个字符
```


### ==6. 变量作用域==

#### ㈠ 本地变量

- **==本地变量==**：当前用户自定义的变量。当前进程中有效，其他进程及**当前进程的子进程无效**。

  ```sh
  /bin/bash # 在当前进程下开一个子进程  exit可退出当前进程
  ps -auxf |grep bash # 查看进程父子关系
  ```

![image-20200328215035153](/image-20200328215035153.png)

#### ㈡ 环境变量

- **环境变量**：当前进程有效，**并且能够被子进程调用**。

  - `export 定义环境变量`

  - `env`查看当前用户的环境变量
  - `set`查询当前用户的所有变量(本地变量与环境变量) 


~~~sh
export A=hello
env|grep ^A

永久生效：
vim /etc/profile 或者 ~/.bashrc

临时添加环境变量：
export PATH=/usr/local/mysql/bin:$PATH
~~~

#### ㈢ 全局变量


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

#### ㈣ 内置变量

| 内置变量     | 含义                                                         |
| ------------ | ------------------------------------------------------------ |
| $?           | 上一条命令执行后返回的状态；状态值为0表示执行正常，==非0==表示执行异常或错误 |
| $0           | 当前执行的程序或脚本名                                       |
| $#           | 脚本后面接的参数的==个数==                                   |
| $*           | 脚本后面==所有参数==，==参数当成一个整体输出==，每一个变量参数之间以空格隔开 |
| $@           | 脚本后面==所有参数==，==参数是独立的==，也是全部输出         |
| \$1\~$9      | 脚本后面的==位置参数==，$1表示第1个位置参数，依次类推        |
| \${10}\~${n} | 扩展位置参数,第10个位置变量必须用{}大括号括起来(2位数字以上扩起来) |
| $$           | 当前所在进程的进程号，如`echo $$`                            |
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

## 三、简单四则运算

==默认情况下，shell就只能支持简单的整数运算==

运算内容：加(+)、减(-)、乘(*)、除(/)、求余数（%）

### 1. 表达式

| 表达式  | 举例          |
| ------- | ------------- |
| $((  )) | echo $((1+1)) |
| $[ ]    | echo $[10-5]  |

另外两个计算的命令：

`expr`:expr 10 / 5  expr 10 \\* 5 (符号左右需空格，expr表达式的格式，*需要转移义)

`let 用于计算变量，所以前提是要先定义变量`:n=1;let n+=1  等价于  let n=$n+1    (左边的n是变量，是个赋值过程，所以不需要加\$)，==let 使用较多==

==备注：==
==$() = ``== ：执行命令
==\$A=\${A}== ： 引用变量
==\$(())=\$[]==：运算表达式

## 四、数组

### 1. 数组定义

#### ㈠ 数组分类

- ==普通数组==：只能使用整数作为数组索引
- ==关联数组==：可以使用字符串/整数作为数组索引

#### ㈡ 普通数组定义

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

#### ㈢ 关联数组定义

##### ①声明关联数组（可省略）

```powershell
declare -A asso_array1
declare -A asso_array2
declare -A asso_array3
```

##### ② 数组赋值

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

#### ㈣ 数组的读取

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

## 五. 其他常用小命令

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
# ==《流程控制篇》==

## 一、条件判断语句

###1. 语法格式

- 格式1： ==**test**== 条件表达式
- 格式2： **[** 条件表达式 ]   
- 格式3： **[[** 条件表达式 ]] ,区别：可以用正则....

**特别说明：**

1）==[    ] 和[[    ]]两边都有空格==

2）更多判断，`man test`去查看，很多的参数都用来进行条件判断

3）[] 和[[]]特殊点：**非空返回** **true**，如：[ '' ]返回false,[ !  '' ]返回ture

### 2. 相关参数

==以下所有都可以用`man test`辅助记忆==

#### ㈠ ==判断文件==

| 判断参数 | 含义                                         |
| -------- | -------------------------------------------- |
| ==-e==   | 判断文件是否存在（任何类型文件）             |
| ==-f==   | 判断文件是否存在==并且==是一个file           |
| ==-d==   | 判断文件是否存在并且是一个目录               |
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

#### ㈡ 判断文件权限

| 判断参数 | 含义                       |
| -------- | -------------------------- |
| -r       | 当前用户对其是否可读       |
| -w       | 当前用户对其是否可写       |
| -x       | 当前用户对其是否可执行     |
| -u       | 是否有suid，高级权限冒险位 |
| -g       | 是否sgid，高级权限强制位   |
| -k       | 是否有t位，高级权限粘滞位  |

#### ㈢ 判断文件新旧

说明：这里的新旧指的是==文件的修改时间==。

| 判断参数         | 含义                                                         |
| ---------------- | ------------------------------------------------------------ |
| file1 -nt  file2 | 比较file1是否比file2新                                       |
| file1 -ot  file2 | 比较file1是否比file2旧                                       |
| file1 -ef  file2 | 比较是否为同一个文件，或者用于判断硬连接，是否指向同一个inode |

#### ㈣ ==判断整数==

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

#### ㈤ ==判断字符串==

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
#### ㈥ ==&&  ||==

==shell中&&和||没有优先级之分，从左往右依次看==

| 判断符号   | 含义   | 举例                                                         |
| ---------- | ------ | ------------------------------------------------------------ |
| -a 和 &&   | 逻辑与 | \[ 1 -eq 1 -a 1 -ne 0 ]         [ 1 -eq 1 ] && [ 1 -ne 0 ]   |
| -o 和 \|\| | 逻辑或 | \[ 1 -eq 1 -o 1 -ne 1 ]         [ 1 -eq 1 ] \|\| [ 1 -ne 1 ] |

&&	前面的表达式==为真==，才会执行后面的代码

||	 前面的表达式==为假==，才会执行后面的代码


## 二、if语句

### 1. 语法格式

#### ㈠ ==if结构==

格式如下：

```shell
if [ condition ];then # 在shell中，then和fi是不同的命令。如果要在同一行里面输入，则需分号隔开，不同不在同一行，分号可省略
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

#### ㈡ ==if...else结构==

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

#### ㈢ ==if...elif...else结构==

```powershell
if [ condition1 ];then
		command1  	
	elif [ condition2 ];then
		command2   	
	else
		command3
fi
```

### 2. 应用案例

#### **㈠ 判断两台主机是否ping通**

**需求：**判断==当前主机==是否和==远程主机==是否ping通

① 思路

1. 使用哪个命令实现

     `ping -c次数`

2. 根据命令的==执行结果状态==来判断是否通

   `$?`

3. 根据逻辑和语法结构来编写脚本(条件判断或者流程控制)

② 落地实现

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

#### ㈡ 判断一个进程是否存在

**需求：**判断web服务器中mysql进程是否存在

**① 思路**

1. 查看进程的相关命令   ps  或者  pgrep

   ```shell
   ps -ef | grep mysql | grep -v grep  #去掉grep这个进程
   或者
   pgrep mysql
   ```

2. 根据命令的返回状态值来判断进程是否存在

3. 根据逻辑用脚本语言实现

② 落地实现

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

**③ 补充命令**

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

#### ㈢ 判断一个服务是否正常

**需求：**判断门户网站是否能够正常访问

**① 思路**

1. 可以判断进程是否存在，用/etc/init.d/httpd status判断状态等方法

2. 最好的方法是==直接去访问==一下，通过访问成功和失败的返回值来判断,可以用以下命令：

   `wget` 

    `curl `

    `elinks -dump`

**② 落地实现**

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

#### ㈠ 判断用户是否存在

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

#### ㈢ 判断当前主机的内核版本

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

## 三、case语句

===java的switch==

### 1. 语法结构

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

### 2. 案例

#### ㈠ 脚本传不同值做不同事

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

#### ㈡ 根据用户需求选择做事

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

####㈢ 菜单提示让用户选择需要做的事

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
read -p "请输入需要操作的选项[h|f|d|m|u|q]:" var1
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

# ==《循环篇》==
## 一、==for循环语句==

### 1. 语法结构

#### ㈠ ==列表循环==

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
- ==exit==：表示直接跳出程序，**exit 0**：正常运行程序并退出程序；**exit 1**：非正常运行导致退出程序；
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

#### ㈡ ==不带列表循环==

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

####  ㈢ ==类C风格的for循环==

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
### 2. 案例

#### ㈠ 脚本==计算==1-100奇数和

**① 落地实现**

```powershell
#!/bin/env bash
# 计算1-100的奇数和
# 定义变量来保存奇数和
sum=0

#for循环遍历1-100的奇数，并且相加，把结果重新赋值给sum

for i in {1..100..2}  或者 for ((i=1;i<=100;i+=2))
do
	let sum=$sum+i  或者  sum=$[$i+$sum]
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


#### ㈡ 判断所输整数是否为质数

**质数(素数)：**==只能==被1和它本身==整除==的数叫质数。
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

**① 思路**

1. 让用户输入一个数，保存到一个变量里   `read -p "请输入一个正整数:" num`
	. 如果能被其他数整除就不是质数——>`$num%$i `是否等于0	`$i=2到$num-1`
3. 如果输入的数是1或者2取模根据上面判断又不符合，所以先排除1和2
4. 测试序列从2开始，输入的数是4——>得出结果`$num`不能和`$i`相等，并且`$num`不能小于`$i`

**② 落地实现**

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

#### ㈢ 批量创建用户

**需求：**批量加5个新用户，以u1到u5命名，并统一加一个新组，组名为class,统一改密码为123

**① 思路**

1. 添加用户的命令	`useradd -G class`
2. 判断class组是否存在  `grep -w ^class /etc/group` 或者`groupadd class`
3. 根据题意，判断该脚本循环5次来添加用户  `for`
4. 给用户设置密码，应该放到循环体里面

**② 落地实现**

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

#### ㈡ 局域网内脚本检查主机网络通讯

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

# time ./ping.sh 
ip is ok...

real    0m3.091s
user    0m0.001s
sys     0m0.008s
```

#### ㈢ 判断闰年

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



## 二、**==while循环语句==**

###1. while循环语法结构

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

### 2. 案例

#### ㈠ 脚本计算1-50偶数和

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

#### ㈡ 脚本同步系统时间

**① 具体需求**

1. 写一个脚本，==30秒==同步一次系统时间，时间同步服务器10.1.1.1
2. 如果同步失败，则进行邮件报警,每次失败都报警
3. 如果同步成功,也进行邮件通知,但是==成功100次==才通知一次

**② 思路**

1. 每隔30s同步一次时间，该脚本是一个死循环   while 循环

2. 同步失败发送邮件   1) ntpdate 10.1.1.1  2) rdate -s 10.1.1.1

3. 同步成功100次发送邮件   定义变量保存成功次数 

**③ 落地实现**

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

## 三、until循环

**特点**：==条件为假就进入循环；条件为真就退出循环==

### 1. until语法结构

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

### 2. 应用案例

**㈠ 具体需求**

1. 使用until语句批量创建10个用户，要求stu1—stu5用户的UID分别为1001—1005；
2. stu6~stu10用户的家目录分别在/rhome/stu6—/rhome/stu10

**㈡ 思路**

1. 创建用户语句  `useradd -u|useradd -d`
2. 使用循环语句(until)批量创建用户  `until循环语句结构`
3. 判断用户前5个和后5个  `条件判断语句`

**㈢ 落地实现**

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

