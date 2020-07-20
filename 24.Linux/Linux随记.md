---
typora-copy-images-to: ./assets
typora-root-url: ./assets
---

### 一、进程相关

#### ==1. ps==

> Process Status

ps -ef 与 ps aux：都能显示全部用户的进程，==只是风格差别==：

![image-20200324113245605](./image-20200324113245605.png)

![image-20200324113254007](./image-20200324113254007.png)

![image-20200324113323431](./image-20200324113323431.png)

![image-20200324113329989](./image-20200324113329989.png)

#### ==2. top==

[top命令详解](https://www.cnblogs.com/mushang1hao/p/10767062.html)

[top中的交互命令](https://www.jianshu.com/p/3f19d4fc4538)

### 二、网络相关

#### 1. ping

测试TCP/IP (也就是传输层)是否畅通

#### 2. telnet

明文传送报文，安全性不好

#### ==3. netstat==

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



### 三、内存相关

#### 1. free

![image-20200324144450375](./image-20200324144450375.png)

```sh
## 输出简介
			总	已用		剩余		被共享使用的	 buff/cache		可用
Mem 内存
Swap 交换空间

其中：available≈free+buff/cache,也就是如果free的内存不够用了，就会去buff/cache缓存中拿
```



### 四、磁盘空间相关

#### 1. df -ha

#### 2. du -ha

### 五、输入、输出、重定向

#### 1. 三种类型

| 类型 | 文件描述符 | 设备名(文件名)         |
| -------------- | ---------- | ------------ |
| 标准输入 | **0**      | /dev/stdin |
| 标准输出 | **1**      | /dev/stdout |
| 标准错误输出 | **2**      | /dev/stderr |

一般情况下，每个Unix/Linux命令都会打开这个文件，默认从这三个文件来输入和输出数据。

#### 2. 符号

| 符号 | 类型/作用      |
| ---- | -------------- |
| <    | 标准输入       |
| <<   | 标识符限定输入，EOF中有用到 |
| >    | 标准输出重定向-覆盖。set –C：禁止覆盖；set +C：启用覆盖。前面其实省略了1（标准输出），1> |
| \>>  | 标准输出重定向-追加                                 |
| 2>  ,  2>> | 标准错误输出重定向，追加。 |
| & | =1+2=标准输出+标准错误输出 |
| 2>&1 | 这里&表示一个**文件描述符引用**，与上面的&不一样，把2输出重定向到1。    **等价于&>** |
| &>   ，   &>> | 1+2重定向,追加 |

<img src=".\image-20200622002730214.png" alt="image-20200622002730214" style="zoom:67%;" />

### 六、xargs

**xargs**：将前一个命令的**标准输出**传递给下一个命令，作为它的**参数**

格式：`command1 | xargs   [-option]  command2`     将command1的标准输出作为command2的参数，**command2默认为echo**,空格是默认定界符。{}用来表示command1传递过来的内容。xargs前面一定要加|

```shell
例举几种用法：
(1)多行输入单行输出
cat xargs.txt | xargs
(2)指定一次处理的参数个数：指定为5，多行输出
cat xargs.txt | xargs -n 5		# -n： 指定一次处理的参数个数
(3)将所有文件重命名，逐项处理每个参数
ls *.txt |xargs -t -i mv {} {}.bak  #-t：表示先打印传递的内容，然后再执行   -i：逐项处理
```

#### xargs与|的区别

**|** ：用来将前一个命令的**标准输出**传递到下一个命令的**标准输入**

```shell
#ls标准输出的结果作为cat的标准输入
ls | cat
#使用xargs将ls的结果作为cat的参数，ls的结果为文件名，所以cat 文件名即查看文件内容
ls | xargs cat
```

<img src="/image-20200628174837166.png" alt="image-20200628174837166" style="zoom:80%;" />

#### **xargs与exec的区别**

exec固定格式：`command1 -exec command2 {} \;` 注意一定要有；而且需要加\转义。

1. exec参数是一个一个传递的，传递一个参数执行一次命令；xargs默认是一次性将参数全传给命令，可以使用-n控制参数个数

   ![image-20200628175342251](/image-20200628175342251.png)

2. **文件名有空格等特殊字符**推荐用exec，xargs也可以特殊文件名需要特殊处理。

   因为：xargs默认是以空格作为定界符，也即参数与参数之间默认是空格分开。

































