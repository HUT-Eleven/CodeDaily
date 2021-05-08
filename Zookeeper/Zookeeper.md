---
typora-copy-images-to: ./assets
typora-root-url: ./assets
---

## 1. 是什么

> 开源；是用java写的；为分布式应用提供协调服务的 Apache 项目；观察者设计模式。
>
> 文件系统 + 监听通知机制

### 1.1 文件系统

<img src="/9360a80fec827de30e216e324edee8a9e85.jpg" alt="9360a80fec827de30e216e324edee8a9e85" style="zoom:80%;" />

每个子目录项称为 znode(目录节点)

#### znode类型

有四种类型的znode：

- persistent-持久化目录节点
- persistent-sequential-持久化顺序编号目录节点
- ephemeral-临时目录节点
- ephemeral-sequential-临时顺序编号目录节点

持久与临时的区别：持久的话，客户端与zk服务端断开后，节点依旧存在，临时节点则会被删除；

### 1.3 监听通知机制

节点发生变化，zk会通知客户端

## 2. 能做什么

包括：统一命名服务、统一配置管理、统一集群管理、服务器节点动态上下线、软负载均衡等。
<img src="/image-20200719170227333.png" alt="image-20200719170227333" style="zoom:80%;" />

<img src="/image-20200719170237420.png" alt="image-20200719170237420" style="zoom:80%;" />

<img src="/image-20200719170250621.png" alt="image-20200719170250621" style="zoom:80%;" />

<img src="/image-20200719170301605.png" alt="image-20200719170301605" style="zoom:80%;" />

<img src="/image-20200719170310949.png" alt="image-20200719170310949" style="zoom:80%;" />

## 3. zoo.cfg配置解读

- **tickTime**=2000：这个时间是作为 Zookeeper **服务器之间**或**客户端与服务器之间**维持心跳的时间间隔，也就是每个 2000毫秒就会发送一个心跳。
- **initLimit**=10：集群中的Follower跟随者服务器与Leader领导者服务器之间初始连接时能容忍的最多心跳数（tickTime的数量），用它来限定集群中的Zookeeper服务器连接到Leader的时限。就是 10*2000=20 秒
- **syncLimit**=5：集群中Leader与Follower之间的最大响应时间单位，假如响应超过syncLimit * tickTime，Leader认为Follwer死掉，从服务器列表中删除Follwer。
- **dataDir**=/opt/zookeeper/data：数据文件目录+数据持久化路径。
- **clientPort**=2181
- **server.A=B：C：D**：其中 A 是一个数字，表示这个是第几号服务器；B 是这个服务器的 ip 地址；C 表示的是这个服务器与集群中的 Leader 服务器交换信息的端口；D 表示的是万一集群中的 Leader 服务器挂了，需要一个端口来重新进行选举，选出一个新的 Leader，而这个端口就是用来执行选举时服务器相互通信的端口。如果是伪集群的配置方式，由于 B 都是一样，所以不同的 Zookeeper 实例通信端口号不能一样，所以要给它们分配不同的端口号。

## 4. 使用

### 4.1 命令

zk命令较为简单，使用时通过`help`可基本了解作用，极简单命令不在下面列出。zk不同版本的命令可能有增删，以`help`为准。

**带watch表示监听，监听子节点变化（路径变化），只监听一次变化；**

| 命令                           | 功能                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| ls path [watch]                | 获取path下的有哪些子节点，即znode                            |
| ls2 path [watch]               | 比ls命令多输出节点的状态信息，即等价于  ls  + stat           |
| stat path [watch]              | 获取znode的状态信息                                          |
| get path [watch]               | 获取znode的状态信息 + znode的值                              |
| create [-s] [-e] path data acl | 创建节点;<br />-e表示临时节点（重启或者超时消失,没有-e则为持久节点）；<br />-s表示带有序号,如果原来没有序号节点，序号从 0 开始依次递增。如果原节点下已有 2 个节点，则再 |
| delete path                    | 排序时从 2 开始，以此类推删除znode                           |
| rmr path                       | 递归删除znode                                                |
| set path value [version]       | 设置znode的值                                                |

#### **Stat** 结构体：

![v2-9a24f27ba250869c5f18097bfff1a3fd_720w](/v2-9a24f27ba250869c5f18097bfff1a3fd_720w.jpg)

dataVersion初始值为0，修改1次则+1。

### 4.2 JavaAPI操作

> 方法较多，使用时百度，附带一个链接仅供参考。[zookeeper的javaAPI使用](https://www.cnblogs.com/tashanzhishi/p/10869136.html)

## 5. 选举机制

<img src="/image-20200720142609146.png" alt="image-20200720142609146" style="zoom: 67%;" />

<img src="/image-20200720142628203.png" alt="image-20200720142628203" style="zoom: 67%;" />

### 几个特点：

- 半数机制：**可用节点数量 > 总节点数量/2** 。注意 是 > , 不是 ≥。[zk集群奇数个节点的原因](https://blog.csdn.net/adorechen/article/details/82791280)
- 集群中只有一个Leader，多个Follower;
- 全局数据一致（也就是“强一致性”），从上图，可以看出Client可以连接任意一个节点，因为每个节点的数据都是一致的;
- 来自同一个Client的更新请求按其发送顺序依次执行；
- 数据更新原子性，一次数据更新要么成功，要么失败；

## 6. 写数据流程

<img src="/image-20200720142941823.png" alt="image-20200720142941823" style="zoom:80%;" />