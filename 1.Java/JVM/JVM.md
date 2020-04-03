---
	typora-copy-images-to: ../assets
typora-root-url: ../assets
---

### ==JVM总览图==

![Snipaste_2020-03-21_17-18-04](/Snipaste_2020-03-21_17-18-04.png)

真正需要熟悉的部分是：==堆==。其余部分需了解，以串联知识面。

### 类装载器

#### 一、装载过程细则

<img src="/image-20200321130901781.png" alt="image-20200321130901781" style="zoom:80%;" />


1. ClassLoader就像快递员，加载.class文件，而不同的场景需要不同级别快递员（类加载器）来加载，来提高整体安全和效率；
2. 加载完之后就形成了==Class模板==，实例化对象就是根据这些模板，模板只有一个，对象是可以无数个的。
3. .class文件的开头有==特定的文件标示: cafe babe==，快递员就是根据这个标识来识别是不是他需要的快递。
4. Java类的加载是动态的，它并不会一次性将所有类,**==按需加载==**.

<img src="/image-20200321114717599.png" alt="image-20200321114717599" style="zoom: 67%;" />



#### 二、类加载器种类

==3+1种快递员==：<img src="/image-20200321121238110.png" alt="image-20200321121238110" style="zoom:90%;" />

1. Bootstrap：也称为“根加载器”，是C++语言编写的，
   加载内容：==jre/lib/rt.jar包中.class文件==。(rt=runtime)
   但是因为Bootstrap加载器是C++写的，看不到源码，所以==java中标志为null==，如下：

```java
Object obj = new Object();
String str = "abc123";
System.out.println(obj.getClass().getClassLoader());	// null，这些都是rt.jar中的类
System.out.println(str.getClass().getClassLoader());	// null
```

2. Extension：该ClassLoader是在sun.misc.Launcher里作为一个内部类ExtClassLoader定义的（即 sun.misc.Launcher$ExtClassLoader）
   加载内容：==jre/lib/ext文件夹下所有jar包==

<img src="/image-20200321135434618.png" alt="image-20200321135434618" style="zoom:80%;" />

3. AppClassLoader：
   加载内容：==java环境变量classpath所指定的路径下的类库==

```java
// 获取classpath所指定的路径（非常多，包括自己编写的类，还有依赖的第三方jar包）
System.out.println(System.getProperty("java.class.path"));	

dp01DataProcessor dp01 = new dp01DataProcessor();
System.out.println(dp01.getClass().getClassLoader());//sun.misc.Launcher$AppClassLoader@6d06d69c
```

4. 自定义加载器（略）

#### 三、双亲委派机制

当一个ClassLoader收到类加载请求时，会先把该请求委派给父类，直到Bootstrap ClassLoader,如果Bootstrap未加载到该类，则又原路依次返回，直至加载到未止。

---

### 本地方法栈

Java诞生初期，C/C++横行，java必须调用C/C++的程序。而这些==本地方法==就是为此而生，java中带有==native==的方法都是进==Native Method Stack==中，而多数时候我们讨论的栈是==Java Stack==.
此内容仅做了解，串联知识面

<img src="/image-20200321171101144.png" alt="image-20200321171101144" style="zoom:80%;" />

---

### 程序计数器

<img src="/image-20200322004018090.png" alt="image-20200322004018090" style="zoom: 50%;" />

---
### Java栈

> 以下“栈”都为Java栈，不包含本地方法栈

1. ==”栈“管运行，”堆“管存储==
2. 线程创建时创建，生命周期跟随线程，线程结束栈内存也就释放
3. 栈不存在垃圾回收问题，但可能出现==java.lang.StackOverflowError==，如递归场景。
4. 栈是==线程私有==，一个线程一个栈
5. 栈存放的内容：==8种基本数据类型（byte,short,int,long,float,double,boolean,char) + 对象引用(以及常量的引用) + 实例方法==
6. 方法进栈就叫==“栈帧”==

<img src="/image-20200322122359477.png" alt="image-20200322122359477" style="zoom: 50%;" />

---
### 方法区

> 方法区可以理解为一个放模板的地方，是共享的。

1. 存储每个类的结构信息（字节码形式），包括：==常量池(已移至元空间)==、字段、构造函数、普通函数等等

2. ==线程共享==

3. ==方法区=规范==，不同的JVM有不同的实现：HotSpot是永久代（PermGen），JRockit是元空间（Metaspace）。==jdk8开始，HotSpot用MetaSpace取代了PermGen==。

   ==!!!元空间与永久代最大的区别：==
   永久代用的是JVM的堆内存；
   元空间直接用本地物理内存，所以元空间的数据不再占用堆内存，原本在永久代中的==字符串常量池、静态常量==移到==堆==中

4. 方法区一般不涉及垃圾回收

---

### Heap

1. 堆：存放==对象实例==的内存区域
2. 堆是jvm中占用内存最大的，所谓垃圾回收，就是堆的垃圾回收。
3. ==线程共享==
4. 减少频繁GC的目的：==GC操作会暂停所有的应用程序线程==，而FGC耗时又长，如果系统频繁FGC,则可能导致系统出现故障（超时、卡顿、OOM等）

#### 一、堆内存划分

**==堆大小 = 新生代 + 老年代 = （Eden + S0 + S1）+ 老年代==**
两个比例：8：1：1；  1：2。其中新生代有效内存只有90%

<img src="/image-20200322164609247.png" alt="image-20200322164609247" style="zoom: 60%;" />

#### 二、YGC

1. YGC也称==MinorGC==, 是==新生代==的垃圾收集动作。
2. 整个过程：==**回收-->复制-->清空-->交换**==。
3. 新生代的垃圾回收算法是==复制算法==:总是空出一块内存，把存活下的复制到空存上面，原来的内存清空。==复制算法不会产生内存碎片==，但是会浪费空闲内存，所以适用于新生代，对象存活时间短的。

<img src="/image-20200322175033946.png" alt="image-20200322175033946" style="zoom: 50%;" />

具体如下：
YGC开始---> Eden区清理存活下来的对象被==复制==到Survivor To 区；From区清理存活下来的对象的根据年龄阈值（-XX:MaxTenuringThreshold）决定复制去Old区还是To区，年龄+1；
YGC结束---> Eden区和From区全部==清空==，To与From==交换==角色，所以To区一直是空的。也即==YGC之后有交换，谁空谁是To==。
==注：==对于一些==较大的对象== ( 即需要分配一块较大的连续内存空间 ) 则是直接进入到老年代

#### 三、FGC

1. ==触发FGC的可能==：
   - system.gc()，一般生产上会禁止。
   - 出现大对象，直接进入老年区，导致老年区空间不足：
     - 比如日志级别过低，导致日志对象很大，频繁FGC，FGC时间长（秒级别以上）。可以适当调高日志级别
     - mysql一次性查询出太多数据，（mysql查询出的数据会用对象装载），同样也会造成大对象直接进入老年区，进而触发FGC。
2. FGC也称==MajorGC==，是==新生代+老年代==的垃圾收集动作
3. 清空新生代,新生代中存活下来的直接进入老年代。
4. 老年代的垃圾回收算法是==标记-清除算法==，节约了空间，但标记过程耗时，且回收会产生内存碎片。
   <img src="/image-20200322233835256.png" alt="image-20200322233835256" style="zoom:50%;" />
5. FGC之后依然是满的，则出现OOM:==java.lang.OutOfMemoryError:Java heap space==
6. FGC的频率低，但时间长

#### 四、四种垃圾回收算法

1. 引用计数法(JVM中不会用到)
2. 复制算法----新生代
3. 标记清除---老年代
4. 标记压缩（比标记清除多了一步整理）

以上四种算法，除了引用计数法比较垃圾外，另外三种都各有优劣，都是==时间效率与空间效率中权衡==

#### 五、参数配置

[参数含义](https://blog.csdn.net/albertfly/article/details/51623138)

##### ==案例==

**SME-DIT2-JVM配置（JDK1.8 , 8G内存）**

```sh
##1.基本配置##
-server			# 默认-client,两者有细微区别，生产用-server
-Xms2048m		# 初始堆内存
-Xmx2048m		# 最大堆内存。一般和Xms配置成一样以避免JVM多次重新分配内存产生额外的GC时间！
-XX:MetaspaceSize=256m		# 元空间初始内存
-XX:MaxMetaspaceSize=512m	# 元空间最大内存
-XX:+UseFastAccessorMethods	# 原始类型的快速优化
-XX:+UseCompressedOops		# http://www.yayihouse.com/yayishuwu/chapter/1956
-XX:+DisableExplicitGC		# 关闭显式FGC，即System.gc(),避免代码中调用gc方法影响性能
-XX:+ExplicitGCInvokesConcurrent #显式FGC改为并发进行
-XX:ParallelGCThreads=8		# 并行收集器的线程数
-XX:-UseAdaptiveSizePolicy	#自动选择年轻代区大小中Survivor区比例，使用并行收集器时建议打开
-Xmn1024m					#新生代的大小，这样新生代就占了堆的1/2
-XX:SurvivorRatio=6			#Eden:Survivor from: Survivor To=6:1:1

##2.CMS相关参数##
-XX:+UseConcMarkSweepGC		#使用CMS内存收集
-XX:+CMSParallelRemarkEnabled	#降低标记停顿
-XX:+UseCMSCompactAtFullCollection	#在FULL GC的时候， 对年老代的压缩
-XX:+UseCMSInitiatingOccupancyOnly	#使用手动定义初始化定义开始CMS收集
-XX:CMSInitiatingOccupancyFraction=70	#使用70％后开始CMS收集

##3.辅助信息##
-verbose:gc		#GC的详细情况
-XX:+PrintGCTimeStamps	#输出时间戳
-XX:+PrintGCDateStamps	#输出日期+时间，可读性比PrintGCTimeStamps更好
-XX:+HeapDumpOnOutOfMemoryError	#OOM时，dump出内存快照，可用于分析
-XX:HeapDumpPath=/tmp/heapdump.hprof #指定导出堆信息时的路径或文件名，结合上一条使用，未指定路径，则在根目录下
-XX:+PrintGCDetails		#打印GC信息
-Xloggc:/home/smemvp1/CBS/app/log/onl/gc.log	#gc日志位置

##4.利用-D配置其他信息，如log4j、系统信息等等##
-Dlog4j2.is.webapp=false
-Dlog4j2.enable.threadlocals=true
-DenableLog=true
-Dlog4j.initialReusableMsgSize=300
-DAsyncLoggerConfig.RingBufferSize=262144
-Dinternational.enable=true
-Dlanguage.conf=en
-classpath:/home/smemvp1/CBS/app/etc/onl:/home/smemvp1/CBS/app/lib/frw/*:/home/smemvp1/CBS/app/lib/app/*
-Dsetting.file=setting.properties
-Dplugin.global.conf.path=plugin-global-conf.properties
-Dlog4j.configurationFile=log4j.xml
-Dltts.vmid=onl
-Dltts.home=/home/smemvp1/CBS/app
-Dltts.log.home=/home/smemvp1/CBS/app/log
-Dinternational.enable=true
-Dlanguage.conf=en
-Dfile.encoding=UTF-8
```
**其他配置**
```sh
-Xss	每个线程的栈大小,一般不配置，栈不是很深的话，默认大小足够用。
-XX:PrintHeapAtGC	打印GC前后的详细堆栈信息

## 2.收集器设置
-XX:+UseSerialGC		设置串行收集器
-XX:+UseParallelGC		设置并行收集器,此配置仅对年轻代有效,而年老代仍旧使用串行收集
-XX:+UseParalledlOldGC	设置并行年老代收集器
	## 2.1 并行收集器设置
	-XX:ParallelGCThreads=n:并行收集器的线程数,即:同时多少个线程一起进行垃圾回收。此值最好配置与处理器数目相等
	-XX:MaxGCPauseMillis=n:设置并行收集最大暂停时间
	-XX:GCTimeRatio=n:设置垃圾回收时间占程序运行时间的百分比。公式为1/(1+n)
	## 2.2 并发收集器设置
	-XX:+CMSIncrementalMode:设置为增量模式。适用于单CPU情况。
	-XX:ParallelGCThreads=n:设置并发收集器年轻代收集方式为并行收集时，使用的CPU数。并行收集线程数。

## -D参数：设置系统属性值，场景设置log4j
-Dhello="abc" # System.getProperty("hello") // abc
```


#### 六、GC日志说明

<img src="/image-20200322220748442.png" alt="image-20200322220748442" style="zoom:200%;" />

==关于图的几点说明：==

1. 一个格式：GC前使用情况—>GC后使用情况（总大小）
2. 新生代内存总大小+老年代内存总大小=jvm堆内存总大小，38400k+86016k=124416k
   新生代显示的38400k ≈ 8/10 Eden + 1/10 Suvivor From(有误差), 即Xmn的90%才为**新生代可用的内存空间**，。
3. Full GC中最后一条的PSPermGen是指永久代，jdk8开始为==Metaspace==，其余一样。但是可以看出GC前后，元空间的内存使用情况不变，所以方法区是不涉及垃圾回收的。
4. Full GC耗时是MinorGC耗时的62倍！！！通常都是在10倍以上。
5. 观察发现，Full GC会清空新生代（600k—>0k），存活下的470k直接进入老年代.老年代（0—>470k）



### JVM工具

#### ==1. jps==

作用：==查看虚拟机的进程==（有权访问）,与linux上的ps类似

格式：jps [options] [hostid]  # 默认localhost

```sh
jps -l # list出当前虚拟机所有进程号+启动类全名
```

![image-20200327133552991](/image-20200327133552991.png)

```sh
jps -v # 输出传入JVM的参数（但不包含JVM一些默认配置信息）
```

![image-20200327133607470](/image-20200327133607470.png)

#### 2. jinfo

作用：查看虚拟机运行参数

#### ==3. jstat==

作用：==statistics，统计工具==，监视jvm内存内的各种堆和非堆的大小及其内存使用量

格式：jstat [options] [pid] [间隔时间/毫秒] [查询次数]

```sh
options:
	-gcutil:总结垃圾回收统计(偏显示的是内存使用率)
	-gc	:垃圾回收统计(偏显示的是内存大小)
	-class :类加载统计
	-compiler:编译统计
```

#### ==4. jstack==

作用：生成线程快照信息

格式：jstat [options] [pid] 

```sh
-l	#打印关于锁的附加信息
-m	#同时打印出native stack信息
```

打印出的文件中，线程一般存在如下几种状态：

```sh
1. 执行中，Runnable (正常)
2. 死锁，Deadlock（重点关注） 
3. 阻塞，Blocked（重点关注）    
4. 等待资源，Waiting on condition（重点关注） 
5. 等待获取监视器，Waiting on monitor entry（重点关注）
6. 暂停，Suspended
7. 对象等待中，Object.wait() 或 TIMED_WAITING
8. 停止，Parked
```

#### ==5. jmap==

格式：jmap [options] [pid] 

```sh
# 1. dump : 生成堆转储快照
jmap -dump:live,format=b,file=dump.hprof PID	#format=b ：binary format
注：-XX:+HeapDumpOnOutOfMemoryError可在OOM时自动生成dump文件

# 2. -finalizerinfo：打印等待回收对象的信息
# 3. -heap:堆的使用情况
# 4. -histo：堆中对象统计，生产环境慎用，live只统计活的。
jmap -histo:live PID>temp.txt
```

#### 6. jhat

JVM Heap Analysis Tool，建议使用MAT

#### 7. jconsole

监控平台



### JMM

### MAT

### Arthas