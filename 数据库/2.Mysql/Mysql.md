---
typora-copy-images-to: ../assets
typora-root-url: ../assets
---

# ==高级语法==

## 1. help

```sql
help 关键字...
-- 需要在命令行界面执行
help show
help show processlist
help lock
help select
......
```

## 2. show

`help show`：查看show的所有用法。show指令的参数繁多，以下罗列几种常用的，[具体上网查询](https://www.cnblogs.com/saneri/p/6963583.html)。

### status--服务器状态信息

```sql
help show status
Syntax:
	SHOW [GLOBAL | SESSION] STATUS [LIKE 'pattern' | WHERE expr]
-- 常用like，where不常用where variable_name='%xxx%';共有400+个值
```

eg:

```sql
-- 表锁相关
table_locks_immediate	-- 立即获得表锁的次数
table_locks_waited		-- 不能立即获得表锁的次数，即锁等待，该值高表示性能有问题！
-- innodb行锁相关
innodb_row_lock_time	--等待总时长
innodb_row_lock_time_avg--等待平均时长
innodb_row_lock_waits	--等待总次数
......
-- 慢查询相关
slow_queries			-- 慢查询次数
```

### variables--服务器变量

![image-20200408002239845](/image-20200408002239845.png)

```sql
-- 慢查询相关
slow_query_log			-- 慢查询开关
slow_query_log_file 	-- 慢查询文件位置
long_query_time 		-- 慢查询阈值，单位秒，
slow_launch_time 		-- 创建线程的阈值,且Slow_launch_threads(慢建立线程数)+1
log_queries_not_using_indexes	-- 没有索引的查询是否记录到慢查询日志
......
```

修改变量：

1. set [session] xxx;	-- 只在当前会话生效
2. set global xxx;		-- 全局生效，但在设置之前打开的会话不生效，重启mysql后失效。**有些变量非全局,则不能添加global**。

3. 修改配置文件          -- 重启后生效。

结论：若想修改服务器变量但当下又不想重启服务，可以通过set global,同时应修改配置文件，避免重启后失效。

## 3. [load data infile](https://www.cnblogs.com/kiwi/archive/2012/11/29/2794124.html) 

> insert和mysql（执行文件）都可以插入数据，但本质都是执行sql。当==**大批量插入**==时使用load更快。load加载的文件里只有数据，没有sql命令。

```sql
load data  [low_priority] [local] infile 'file_name.tsv'   [replace | ignore]   into table tbl_name
[fields  [terminated by'\t']   [ [OPTIONALLY]  enclosed by '']  [escaped by'\\' ]  ]
[lines   terminated by'\n']
[ignore number lines]
[(col_name, )]
```

**以下为参数说明：**

- **low_priority**:	降低优先级，等读共享锁无使用时，才进行写
- **local**：文件在客户端，不在数据库的服务器上.如果是在windows上路径需加转义符。[local问题](https://www.iteye.com/blog/tangmingjie2009-889925)
- **replace|ignore**：控制唯一键重复处理。replace替换，ignore跳过
- **fields**：指定了每行数据字段之间的关系
  	- **terminated by**:描述字段间的分隔符，默认情况下是tab字符（\t）
   - **[OPTIONALLY] enclosed by**:描述的是字段的括起字符(eg: enclosed by '"' 即"xxx"，一般不指定),OPTIONALLY表示，只对char/varchar/text等等这些加enclose by字符
   - **escaped by**:描述的转义字符。默认的是反斜杠，所以一般也不指定
      	默认效果：fields terminated by'\t' enclosed by '' escaped by'\\'
- **lines**:指定了行与行之间关系
  	- **terminated by**:指定行与行之间的分隔符，默认\n;
- **ignore number lines**:忽略前几行，通常用来忽略首行字段名

==需注意的问题==：

- 文件权限：load data必须要对该文件有读的权限
- local_infile：该值是控制能否使用local参数，也即能否加载客户端文件。可以通过`set global local_infile = 'ON';`打开；
- null值问题：暂时只知道load data infile导入时是识别`\N`作为空值。所以在导出时也设置为`\N`就可以正确识别null值了。

## 4. select ... into outfile

> load data infile的逆操作

```sql
select... into outfile 'file_name' [Fields... lines...]
FIELDS和LINES的语法和load data...infile是相同的.
```

==需要注意的问题：==

1. **secure-file-priv**：用来限制LOAD DATA, SELECT ... OUTFILE, and LOAD_FILE()传到哪个指定目录的。
   三种值：

```sql
null	-- 禁止导入导出
/xx/xx/	--表示只允许导入导出该目录下文件（PS：测试子目录也不行）
空		--不限制导入导出
```
如果secure_file_priv有限制，则只能导出到mysql所在的服务器下的指定路径，并且需要具备写的权限。**针对此情况，可以用DataGrip**;

2. 空值问题：字段中的空值用**\N**表示

- select... into outfile默认导出为\N

- 用DataGrip导出数据时，控制如下：
  <img src="/image-20200414162531977.png" alt="image-20200414162531977" style="zoom:50%;" />

3. 字段中存在换行：fields的terminated和line的terminated最好取一些特殊符号，比如ElevenZ。字段之间取逗号或者tab都有风险，视情况而定。DataGrip如下：
   <img src="/image-20200414180011316.png" alt="image-20200414180011316" style="zoom: 67%;" />

4. DataGrip中的load data等价操作：

<img src="/image-20200517175849738.png" alt="image-20200517175849738" style="zoom: 50%;" />

## 5. 常用函数记录

instr：

```
schema() 或 database()：查询当前数据库名
```

## 6.regexp

mysql支持正则查询：

```sql
SELECT * FROM aps_packet WHERE trxn_date REGEXP '^2.*0$';
```

# ==常用命令==

**以下命令无法详细记录，只能在平时遇到一些特殊场景做登记。**

## 1.  mysql

1. 登录数据库功能
2. 执行sql文件功能
3. 导出查询结果功能（较少用）：

```sql
-- 把SQL查询结果导出到tsv文件(用的少，等价于select...into outfile，但功能单一，不能自定义分隔符等等)
mysql -uroot -p -P3306 -hlocalhost -Bxxx -e "select * from film_text" test > 8.tsv
-B: 指定数据库
-e: 指定sql
```

## 2. mysqldump

### 2.1 作用

**对数据库进行逻辑备份**

### 2.2 使用

```sql
mysqldump -uroot -p -hlocalhost -P3306 [options] [库名] [表名]> dump.sql
```

**[options] (常用)**:

> 以下有双选项的，建议选长的，见名知意。
> [参数详解](https://blog.csdn.net/loiterer_y/article/details/85091798)

```sql
--all-databases, -A	导出所有数据库
--databases, -B		导出指定数据库
--tables			导出指定表
--no-data, -d		不导出表数据，也即只有create table语句
--no-create-info	不导出create table语句
--where 			限制导出数据的条件，常用于导出指定表的指定数据，也可用--event代替
--comments			导出表的comment信息
--ignore-table		不导出指定表,--ignore-table=t1 --ignore-table=t2
....
一般反选项就是前面加skip，eg:
--skip-comments		就是comments的反选项，即不导出表的comment信息
--skip-add-drop-table	不导出删表语句
```

**注意点：**

- 导出的是**sql格式**；
- /*!  .... */ 这不是注释，是mysql为了保持导出sql文件的兼容性，但导入到数据库时，在mysql中会被执行，在其他数据库不会被执行；



## 3. ==mysqldumpslow==
### 3.1 日志内容

**注**：**DML**语句也会记录到日志中

``` sql
# Time(发生时间): 2017-06-03T06:48:27.030315Z
# User@Host: root[root] @ localhost（主机信息） []  Id:3
# Query_time（查询耗时）: 1.896889  Lock_time（等待锁耗时）: 0.000823 Rows_sent(返回客户端行总数): 100000  Rows_examined(扫描行总数): 200000
SET timestamp=1496472507; 
select * from z_order limit 100000;
```

### 3.2 使用

```shell
 mysqldumpslow --help  # 查看参数
 
 -s, 是表示按照何种方式排序
    c: 访问计数
 
    l: 锁定时间
 
    r: 返回记录
 
    t: 总查询时间，（即所有这句sql的总和时间，即Time=1.05s (200s)总的200s）
 
    al:平均锁定时间
 
    ar:平均返回记录数
 
    at:平均查询时间
 
-t, 是top n的意思，即为返回前面多少条的数据；
-g, 后边可以写一个正则匹配模式，大小写不敏感的！！！好用
-a ,不将数字抽象成N，字符串抽象成S
-r 反向排序，最大的在最后
--------------------------------
eg:
1.按时间排序，Top 10,包含join。
mysqldumpslow -s t -t 10 -g "join" /database/mysql/mysql06_slow.log

得到返回记录集最多的10个SQL。
mysqldumpslow -s r -t 10 /database/mysql/mysql06_slow.log
 
得到访问次数最多的10个SQL
mysqldumpslow -s c -t 10 /database/mysql/mysql06_slow.log
```

### 3.3 执行结果

````sql
Reading mysql slow query log from mysql-slow.log
Count: 2  Time=3.64s (17s)  Lock=0.00s (0s)  Rows=100000.0 (200000), root[root]@localhost
  select * from z_order left join z_league on z_order.league_id = z_league.id limit N

Count: 2  Time=1.05s (200s)  Lock=0.00s (0s)  Rows=55000.0 (110000), root[root]@localhost
  select * from z_order limit N
```
- Count：出现次数,
- Time：执行最长时间  和  执行总时间
- Lock：等待锁的最长时间 和  等待锁总时间
- Rows：单次查询返回的平均行数(累计返回的总行数≈count*单次查询返回的平均行数)

# ==事务==

## 1. 四个问题

这四个问题是针对**事务与事务**的概念提出的，一次连接开启，就相当于一个单独的事务，事务与事务之间，由于隔离级别的不同，导致的问题也不同

- 更新丢失
   非事务控制相关的问题，是锁相关/数据库连接相关/网络相关的问题
- 脏读
- 不可重复读
- 幻读
   **幻读与不可重复读的区别**：不可重复读是对**同一行数据**的前后不一致。幻读是对**不同行数据**的前后不一致。

## 2. 四种隔离级别

- read uncommitted-读未提交：
  session2 可以读到 session1 未提交的事务(脏读、不可重复读、幻读)；
  
- read committed- 读已提交:
  session2 不可以读到session1未提交的事务，但可能会因为session1提交后，导致出现读取的数据不一致（不可重复读、幻读）；
  
- repeatable read-可重复读：
  session2-->start transaction后，与其他事务是隔离状态（幻读）
  
  **InnoDB通过 MVCC和 NEXT-KEY Locks，解决了在可重复读的事务隔离级别下出现幻读的问题。**
  
- Serializable - 串行化

![image-20200408004145218](/image-20200408004145218.png)

## 3. 问题记录

1. 事务自动提交，导致事务不起作用？

查看数据库配置：

![image-20200320155136770](/image-20200320155136770.png)

可以看到autocommit是ON,
注：多数生产环境都必须配置为ON。
此时可以手动开启事务：

```sql
start transaction ;
```

2. 第三方客户端，一般都会对autocommit进行设置，所以可能导致autocommit=OFF，导致锁表。此时在客户端`show variables like '%auto'`，**查的是session级别的配置**，查询数据库配置建议在命令行界面查询。

3. 曾经面试问我“如何避免幻读？”

   其实这个是伪命题，首先幻读的概念是指不同行数据前后读取不一样，这在很多业务上本身是合理的。如果非要避免幻读的话，可重复读隔离级别是不行的，要么申请表写锁，要么序列化。
   或者：InnoDB通过 MVCC和 NEXT-KEY Locks，解决了在可重复读的事务隔离级别下出现幻读的问题。

---



---



# ==锁==

> 锁：是计算机协调多个进程/线程并发访问**同一个资源**的机制.在计算机资源中，CPU/RAM/IO都是争用的资源，数据也是，所以数据库的锁也至关重要。
>

MySQL 的锁机制：最显著的特点是**不同的存储引擎支持不同的锁机制**。
**MyISAM只支持表级锁；**
**InnoDB即支持表级锁，又支持行级锁，默认是行级锁**。

## 1. 锁分类：

### 1. 按粒度分

- **表级锁**：开销小，加锁快；**不会出现死锁**；锁定粒度大，发生锁冲突的概率最高,并发度最低。
- **行级锁**：开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低,并发度也最高。
- **页面锁**：开销和加锁时间都界于表锁和行锁之间；会出现死锁；锁定粒度界于表锁和行锁之间，并发度一般。可理解为连续多行的锁。

### 2. 按机制分

- **读锁**（Share Locks，记为S锁）
- **写锁**（eXclusive Locks，记为X锁。也称为独占锁/排它锁）

**总结**：由上分类，可得大致有四种锁：表读锁、表写锁、行读锁、行写锁

## 2. MyISAM表锁

> MyISAM只支持表锁，则MyISAM中有：表写锁和表读锁。

### 2.1 查询表级锁争用情况

```sql
show status like 'table_locks%';
-- Table_locks_immediate:直接获得表锁的次数
-- Table_locks_waited:等待表锁的次数。如果此值过高，则表锁争用情况严重。
```

### 2.2 表级锁的锁模式

兼容性如下（兼容性表示如果请求的锁模式与当前锁模式兼容，与允许获得该锁）：

<img src="/e64402386225815b657a00d092135ca3.png" alt="UTOOLS1590206412989.png" style="zoom: 67%;" />

**总结：只有读读共享，其他都是不兼容。**

| Session 1          | Session 2                       |
| ------------------ | ------------------------------- |
| lock table t1 read |                                 |
| DQL t1  √          | DQL t1 √                        |
| DQL t2   ×         | DQL t2 √                        |
| DML t1  or t2  ×   | DMl t1 阻塞, t2 is ok，t2没有锁 |

![image-20200627152752157](/image-20200627152752157.png)

| Session  1           | Session 2                   |
| -------------------- | --------------------------- |
| lock table t1 write; |                             |
| DQL or DML  t1 √     | DQL or DML  t1  is blocked. |
| DQL or DML  t2 ×     | DQL or DML  t2 √            |

![image-20200627152821412](/image-20200627152821412.png)

### 2.3 如何加表锁

#### 1. 自动加锁：

MyISAM在执行DQL前，会**自动**给**涉及的所有表**加读锁，在执行DML前，会**自动**给**涉及的所有表**加写锁。

#### 2. 手动加锁

`lock table xxx read/write [local];`（local选项作用：并发插入时，允许客户在表尾并发插入记录）

### 2.4 锁主要特性

- **不支持锁自动扩展**：MyISAM总是一次性获取到sql中涉及到的所有表的锁，如果获取不到就提示报错了，这也是MyISAM不会出现死锁的原因。只能访问加锁的这些表，不能访问未加锁的表;
- **读锁不会自动升级到写锁**：所以获取读锁就只能读，不能写。
- **出现几次锁几次**：同一张表在sql中出现几次就会锁定几次，理论上是表锁是自动加的，表别名也加锁，所以显式加锁时需要记得给别名加锁。

### 2.4 并发插入

MyISAM 存储引擎有一个系统变量 **concurrent_insert**

1. 当concurrent_insert设置为0时，不允许并发插入。
2. 当concurrent_insert设置为1时，如果MyISAM表中没有空洞（即表的中间没有被删除的行），MyISAM允许在一个进程读表的同时，另一个进程从表尾插入记录。这也是MySQL的默认设置。
3. 当concurrent_insert设置为2时，无论MyISAM表中有没有空洞，都允许在表尾并发插入记录。

注意：是指MyISAM引擎的表，加锁时需要加local选项。

![image-20200626211541382](/image-20200626211541382.png)

### 2.5 锁调度

一个进程要获取这张表的读锁时，另一个进程要获取写锁，则写锁会优先取得。

可以通过以下设置调节:

- 修改配置low-priority-updates=1重启，使MyISAM引擎默认给予读请求以优先的权利。
- 通过执行命令SET LOW_PRIORITY_UPDATES=1，使该session更新请求优先级降低。
- 通过指定INSERT、UPDATE、DELETE语句的LOW_PRIORITY属性，降低该语句的优先级。

## 3. InnoDB锁

> InnoDB 与 MyISAM 的最大**不同**有两点：一是支持事务（TRANSACTION）；二是支持行级锁。

### 3.1 获取 InnoDB行锁争用情况

```sql
show status like 'innodb_row_lock%'; 查看以下变量的值，来分析InnoDB行锁争用情况；
-- innodb_row_lock_time		--等待总时长
-- innodb_row_lock_time_avg	--等待平均时长
-- Innodb_row_lock_time_max --等待最大时长
-- innodb_row_lock_waits	--等待总次数

如果avg或者waits比较大，则系统锁需要优化。
```

（1）通过查询information_schema数据库中的表了解锁等待情况：

```sql
select * from information_schema.innodb_locks;查看Innodb锁的情况
```

（2）通过设置 InnoDB Monitors观察锁冲突情况：

```sql
CREATE TABLE innodb_monitor(a INT) ENGINE=INNODB;
Show engine innodb status\G;
DROP TABLE innodb_monitor; 	-- 停止监控。打开监视器以后，默认情况下每15秒会向日志中记录监控的内容，如果长时间打开会导致.err文件变得非常的巨大，所以用户在确认问题原因之后，要记得删除监控表以关闭监视器。
```

### 3.3 InnoDB的==锁模式==

InnoDB实现了以下两种类型的**行锁**。

- **共享锁**（S,Share Lock,**行读锁**）：如果事务T对数据A加上共享锁后，则其他事务只能对A再加共享锁，不能加排他锁。
- **排他锁**（X,eXclusive Lock,**行写锁**）：如果事务T对数据A加上排他锁后，则其他事务不能再对A加任何类型的锁。获准排他锁的事务既能读数据，又能修改数据。

另外，为了允许行锁和表锁共存，InnoDB 还有两种内部使用的意向锁（Intention Locks），这两种意向锁都是**表锁**。[InnoDB 的意向锁有什么作用？](https://www.zhihu.com/question/51513268)

- **意向共享锁**（IS）：表示事务准备申请表读锁，必须先取得该表的IS锁。

- **意向排他锁**（IX）：表示事务准备申请表写锁，必须先取得该表的IX锁。

  注意：申请意向锁的动作是数据库完成的，就是说，**事务A申请一行的行锁的时候，数据库会自动先开始申请表的意向锁(同时包括IS和IX)**。

**行锁兼容性**如下：**意向锁之间都是兼容的，共享锁与共享锁都是兼容的，其他都是不兼容的。**
如果一个事务请求的锁模式与当前的锁兼容，InnoDB 就将请求的锁授予该事务；反之，如果两者不兼容，该事务就要等待锁释放。

![image-20200626220801084](/image-20200626220801084.png)

### 3.4 加锁方法

- 意向锁是InnoDB**自动**加的，不需要用户干预；

- 排他锁（X）：对于DML语句，InnoDB会**自动**给涉及的数据加上；

- **对于一般的Select语句，InnoDB不会加任何锁**，所以某行有排他锁时，虽然其他事务不能再加任何锁，但不会影响读（但这还取决于隔离级别）；

- **手动加共享锁或排他锁**：
  - 共享锁：`SELECT ... LOCK IN SHARE MODE;`
    
  - 排他锁：`SELECT ... FOR UPDATE;`

### 3.5 InnoDB==行锁实现细节==

​	InnoDB行锁是依赖==**索引**==来实现的，如果没有用到索引，则会造成表锁。

### 3.6 InnoDB三种行锁形式

> https://www.cnblogs.com/Terry-Wu/p/12219019.html

- **Record lock（记录锁）**：

  ```sql
  SELECT * FROM table WHERE id = 1 FOR UPDATE;　
  ```

  id列必须为**唯一索引列或主键索引**，并且不能为 `>`、`<`、`like`等，否则上述语句加的锁就会变成**临键锁**。可以通explain查看是否用到唯一索引列或主键索引。

- **Gap lock（间隙锁）**：

  间隙锁基于**非唯一索引**（用explain查看是没用到主键索引的，这里的id用到了其他普通索引），它锁定一段范围内的索引记录。

  ```sql
  SELECT * FROM table WHERE 1 < id < 10 FOR UPDATE;
  ```

  即申请在`（1，10）`区间内的记录行排它锁，但不包括1 和 10 两条记录。

- **Next-key lock（临键锁）**：

  以下是对临键锁的解释截图，注意几个细节：

  1. 临键锁是在**可重复读**时有效，在**读已提交**就无效了；

  3. 临键锁只能解决锁住的区间内的幻读问题，但无法解决未锁住的区间幻读问题。
  

![image-20201208000328127](/image-20201208000328127.png)

![image-20201208000341136](/image-20201208000341136.png)

==！！！==：InnoDB这三种行锁实现特点意味着：行锁在 InnoDB 中是基于索引实现的，所以一旦某个加锁操作没有使用索引，那么该锁就会退化为表锁。

以下例子，用 for update 来显式模拟排它锁

**（1）在不通过索引条件查询时，InnoDB会锁定表中的所有记录。**

<img src="/image-20200627154945867.png" alt="image-20200627154945867" style="zoom:80%;" />

看起来session_1只给一行加了排他锁，但session_2在请求其他行的排他锁时，却出现了锁等待！原因就是在没有索引的情况下，InnoDB 会对所有记录都加锁。

当给其增加一个索引后，InnoDB就只锁定了符合条件的行，如表20-10所示:

<img src="/image-20200627155044268.png" alt="image-20200627155044268" style="zoom:80%;" />

**（2）由于 MySQL 的行锁是针对索引加的锁，不是针对记录加的锁，所以虽然是访问不同行的记录，但是如果是使用相同的索引键，是会出现锁冲突的。**

<img src="/image-20200627155241506.png" alt="image-20200627155241506" style="zoom:80%;" />

**（3）当表有多个索引的时候，不同的事务可以使用不同的索引锁定不同的行，不论是使用主键索引、唯一索引或普通索引，InnoDB都会使用行锁来对数据加锁。**

<img src="/image-20200627155419186.png" alt="image-20200627155419186" style="zoom:80%;" />



### 3.7 不同隔离级别下的一致性读及锁的差异

![image-20200627160749571](/image-20200627160749571.png)

### 3.8 InnoDB加表锁

```sql
Begin;
LOCK TABLES t1 WRITE, t2 READ, ...;
[do something with tables t1 and t2 here];
COMMIT;	-- COMMIT或ROLLBACK并不能释放用LOCK TABLES加的表级锁，必须用UNLOCK TABLES释放表锁。
UNLOCK TABLES;	-- 事务结束前，不要用 UNLOCK TABLES释放表锁，因为 UNLOCK TABLES会隐含地提交事务
```

### 3.9 死锁

死锁例子1：

<img src="/image-20200627162114810.png" alt="image-20200627162114810" style="zoom:80%;" />



死锁例子2：某条数据存在1个以上事务为**共享锁**模式时，如果这些事务又对该数据进行更新，则会导致死锁。演示如下：
所以设计更新时，应加排他锁（手动/自动）

<img src="/image-20200626225902911.png" alt="image-20200626225902911" style="zoom:80%;" />

发生死锁后，InnoDB 一般都能自动检测到，并使一个事务释放锁并回退，另一个事务获得锁，继续完成事务。

但在涉及外部锁或涉及表锁的情况下，InnoDB 并不能完全自动检测到死锁，这需要通过设置锁等待超时参数**innodb_lock_wait_timeout**来解决。需要说明的是，这个参数并不是只用来解决死锁问题，在并发访问比较高的情况下，如果大量事务因无法立即获得所需的锁而挂起，会占用大量计算机资源，造成严重性能问题，甚至拖垮数据库。我们通过设置合适的锁等待超时阈值，可以避免这种情况发生。

# ==索引数据结构==

**Q:数据库索引为什么要用树结构存储？**

A：因为树的查询效率高，并且有序。

**Q:那为什么没有用二叉查找树呢？**

A:从算法逻辑上看，二叉查找树的查询速度和比较次数都是最小的了，但是还有一个问题需要考量：**磁盘IO**。
索引文件通常都是几个G大小，无法将索引文件一次性读取到内存中来进行查找，所以**磁盘与内存之间就要进行多次的IO**,内存是通过逐一加载磁盘页来进行查找的。假设用二叉查找树来作为索引数据的存储结构，过程如下：

<img src="/image-20210407124241299.png" alt="image-20210407124241299" style="zoom:50%;" />

内存先加载第一个数据，在**绿色的磁盘页**,再比较大小决定下一个磁盘页,依次进行，如果用二叉查找树，树的高度可能很高，最严重的就是要查找的值在最底下，则内存与磁盘的IO次数等于树的高度。

所以，为了减少磁盘IO次数，就把“瘦高”的二叉树变为“矮胖”的B-Tree。

### [B-树](https://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653190965&idx=1&sn=53f78fa037386f85531832cd5322d2a0&chksm=8c9909efbbee80f90512f0c36356c31cc74c388c46388dc2317d43c8f8597298f233ca9c29e9&scene=21#wechat_redirect)

**定义**：Balance-Tree, 也叫B-树(这个就读B树，不读B减树)，**多路平衡查找树数据结构**。

**阶数**：一般用字母m表示阶数,一个节点最多有m-1个元素。当m取2时，就是我们常见的二叉树。

**一颗m阶的B树定义如下**：

1. 根节点：可以有1 ~ m-1个元素，至少有2个子节点；
2. 非根节点：可以有Math.ceil(m/2)-1 ~ m-1个元素；
3. 节点的子节点=节点元素个数+1；
4. 每个节点中的元素都按照从小到大的顺序排列，每个元素的左子树中的所有关键字都小于它，而右子树中的所有元素都大于它。
5. 所有叶子节点都位于同一层，也即根结点到每个叶子节点的长度都相同。
6. 每个节点都存有**索引数据**以及**对应的行数据在磁盘上逻辑地址（表数据）**。

#### B树的查询

<img src="/image-20210407213359931.png" alt="image-20210407213359931" style="zoom: 50%;" />

<img src="/image-20210407213443067.png" alt="image-20210407213443067" style="zoom:50%;" />

<img src="/image-20210407213524006.png" alt="image-20210407213524006" style="zoom:50%;" />

从上可以看出，B-Tree的比较次数相对于二叉树并没有多少优化，**但磁盘IO次数大大减少**，如果阶数越高则越明显。并且“比较大小“是在内存中进行的，这相对于磁盘IO完全可以忽略不计。只要节点的数据不要超过一个磁盘页即可。如果超过了就需要多加载一次磁盘页.

#### B树的插入

<img src="/image-20210407214027148.png" alt="image-20210407214027148" style="zoom:50%;" />

<img src="/image-20210407214106681.png" alt="image-20210407214106681" style="zoom:50%;" />

可以看出，插入是比较麻烦的，这也就是==**为什么索引不能是经常更改的数据**==的原因。



#### B树的删除

<img src="/image-20210407214314897.png" alt="image-20210407214314897" style="zoom:50%;" />

<img src="/image-20210407214329495.png" alt="image-20210407214329495" style="zoom:50%;" />



### [B+树](https://www.cxyxiaowu.com/3726.html)

B+树与B树大体相同，特征有一下几点：

1. 节点的子节点=节点元素个数；（B树是：节点的子节点=节点元素个数+1；）
2. 叶子节点存放**数据**，非叶子节点存放**键值+指针**(指针只指向下一页，所以还需要键值)。——中间节点所在磁盘块可以有更多存储空间，可以存储更多个中间节点，有利于减少磁盘IO次数。同时也让每次查询的磁盘IO次数都是一样的；
3. 中间元素同时也存在于子节点元素；
4. 页内数据根据用户记录的主键大小排列成的单向链表。而页和页之间是根据主键大小顺序排成一个双向链表。——有利于范围查询

![image-20210412142800474](/image-20210412142800474.png)

【**卫星数据**】：指的是索引元素指向的数据记录，比如数据库中的某一行。

<img src="/image-20210407225104680.png" alt="image-20210407225104680" style="zoom: 50%;" />

<img src="/image-20210407225129051.png" alt="image-20210407225129051" style="zoom:50%;" />

**聚集索引（Clustered Index）**中：叶子节点直接包含卫星数据（数据库一整行数据）。

**非聚集索引（NonClustered Index）**中：叶子节点只有**索引数据+主键数据+指针**，然后在从聚集索引中找对应的行记录，即**回表查询**。

<img src="/image-20210408103133851.png" alt="image-20210408103133851" style="zoom: 67%;" />



<img src="/image-20210408103150646.png" alt="image-20210408103150646" style="zoom:67%;" />

**总结B+树相对于B树的优势：**

1. 单一节点存储更多的元素，使得查询的IO次数更少。
2. 所有查询都要查找到叶子节点，查询性能稳定。
3. 所有叶子节点形成有序链表，便于范围查询。

### [B+树可以存放多少行数据？](https://www.cnblogs.com/leefreeman/p/8315844.html)

> 这只讨论**InnoDB**

扇区（通常为512byte）——磁盘块（通常由8个扇区组成，4k）——页（InnoDB存储引擎设置了自身的页值，通常为$4k*2^2=16k$）

![img](/352511-20180119104942115-967540552.png)

```mysql
mysql> show variables like 'innodb_page_size';
| Variable_name    | Value |
| innodb_page_size | 16384 |
```

**计算方法**（忽略了部分开销(页头...)，但对最终值影响不大）：

**1.叶子节点可存记录数** = 页Size/ 每行数据平均Size

​	每行数据平均Size (byte)：SELECT * FROM information_schema.TABLES WHERE TABLE_NAME like 'dpa_%';

**2.非叶子节点可存记录数** = 页Size/ ( 主键Size + 指针6byte)

​	主键Size (byte)：写一条用到了主键所有字段的简单sql，explain解析，ken_len就是主键长度。

**3.层高——>最大记录:**

​	2层：叶子max * 非叶子max

​	3层：叶子max * 非叶子max * 非叶子max，通常为3层，但超过这记录数时，可能就需要处理了，比如备份旧数据等等...



**综上可小总结出**建索引（主键）时常见的需要注意的问题：

1. 索引字段最好不为null：一是因为null占一个字节，占用了非叶子节点占用空间；二是索引失效问题；
2. 索引最好不要是频繁增删的字段：因为B+树的增删可能会很繁琐；
3. 索引尽量短：增大非叶子节点可存储的元素；

### 索引问题常用sql

```sql
-- 查看全表扫描的sql：
select * from sys.x$statements_with_full_table_scans where db = 'icoredb' order by exec_count desc ;

-- 查看file_sort的sql：
select * from sys.x$statements_with_sorting where db = 'icoredb';

-- 查看索引使用频率：
select * from sys.schema_index_statistics;

-- 查看冗余索引(不能随便删除,可能会有些特殊使用场景):
select * from sys. schema_redundant_indexes;

-- 查看库的索引
SELECT * FROM information_schema.STATISTICS WHERE table_schema='cbs_uat_cug2';
-- 查看未使用的索引
select * from sys.schema_unused_indexes;
-- 查看库中没有主键索引 or 唯一索引的表
SELECT tables.table_schema, tables.table_name, tables.table_rows
      FROM information_schema.tables
      LEFT JOIN (
        SELECT table_schema, table_name
        FROM information_schema.statistics
        GROUP BY table_schema, table_name, index_name
        HAVING
          SUM(
            CASE WHEN non_unique = 0 AND nullable != 'YES' THEN 1 ELSE 0 END
          ) = COUNT(*)
      ) puks
      ON tables.table_schema = puks.table_schema AND tables.table_name = puks.table_name
      WHERE puks.table_name IS NULL
        AND tables.table_schema NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys')
        AND tables.table_type = 'BASE TABLE' AND engine='InnoDB';


-- 虽然5.6以后支持insert,update的执行计划，但可能不准确，建议改成select后才分析
EXPLAIN select * from dpa_sub_account where cust_no ='100000028401’;
EXPLAIN update dpa_sub_account set sub_acct_name = '111' where cust_no ='100000028401’;

-- 查看正在执行sql的执行计划：
show PROCESSLIST；
EXPLAIN for CONNECTION ID;
```

# ==Explain==

**重点**：explain可以模拟服务层中的Query Optimizer来查看==Mysql执行计划==，也即**执行阶段**，非Query Optimizer分解sql进行**优化阶段**！

<img src="/20180831173911997" alt="img" style="zoom: 80%;" />

## 总览图

不同版本的Explain差异：

**5.5.x**

![image-20200331181524419](/image-20200331181524419.png)

**8.0.x**

==多了partitions/fitered==

![image-20200331181557503](/image-20200331181557503.png)

## 1. id-表的读取顺序

规律：**id越大，执行的优先级越高。id相同，则按从上到下的顺序**。
			为null的情况：Union/ Union all结果总是放在一张临时表中，而这张临时表不在sql中体现，所以为null。**null通常是最后执行**

经验：往往最里层的子查询id更大，即越优先执行。

![image-20200331190655049](/image-20200331190655049.png)

## 2. select_type-查询类型

​	查询类型主要是针对“子查询”、“union查询”来划分的。

1. ==**simple**==：简单查询，**可以是多表**，但==不包含子查询 或 union==等

   ![image-20200331184650383](/image-20200331184650383.png)

2. ==**primary**==：复杂查询中最外层的 select

   - 如两表做UNION,则第一个union前的select是primary；
   - 存在子查询的最外层的表操作为primary。
     ![image-20200331184930309](/image-20200331184930309.png)

   ![image-20200331185122213](/image-20200331185122213.png)

3. ==**subquery**==：包含在 <select list\>中的子查询（**不在 from 子句中**）

4. ==**derived**==：包含在 **from 子句中**的子查询。MySQL会将结果存放在一个临时表中，也称为派生表（derived）

   案例：primary、subquery、derived综合案例：==select **subquery** from **derived**==

   ![image-20200331191503511](/image-20200331191503511.png)

5. ==**union**==：在 union/union all中，除了第一张表的select_type为primary，后面的所有表的都为union

6. ==**union result**==：union/union all之后的结果（备：id值通常为NULL）

   ![image-20200331192207784](/image-20200331192207784.png)

7. **==dependent subquery==**(略)

## 3. table-表(别名)

特殊：

- 当某查询 from 子句中有子查询时，该查询的table列是 <derived N\> 格式，表示当前查询**依赖** id=N 的查询，于是先执行 id=N 的查询

![image-20200331192844388](/image-20200331192844388.png)

 

- 当有 union 时，UNION RESULT 的 table 列的值为 <union1,2>，1和2表示参与 union 的 select 行id。 

![image-20200331192922620](/image-20200331192922620.png)

## ==4. type-访问类型==

**从好到差**：system > const > ==eq_ref== > ==ref== > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > ==index== > ==ALL==。以及特殊：**null**
可能会因为一些原因，访问类型比预期要低，但一般不会高于预期。

1. **==null==**：mysql能够在优化阶段分解查询语句，并查到了想要的结果，在**执行阶段不用再访问表或索引**，所以访问类型为null。
   例如：**在索引列中选取最小值**，可以单独查找索引来完成，不需要在执行时访问表。

   ![image-20200331235919028](/image-20200331235919028.png)

2. ==**const, system**==：mysql能对查询的某部分进行优化并将其转化成一个常量（可以看**==show warnings==** 的结果）。
   常见场景：**==单表查询==用 ==primary key 或 unique key 的所有列==与常数比较时**，则**只会有一行匹配**，读取1次，速度比较快。

   ![image-20200401000827664](/image-20200401000827664.png)

3. **==eq_ref==**：相比const/system,  er_ref就是==**多表**==的情况。==primary key 或 unique key的所有列被使用==（通常就是使用到了**唯一索引/主键索引**的情况） ，最多只会返回一条符合条件的记录。

   ![image-20200401003401450](/image-20200401003401450.png)

4. **==ref==**：相比 `eq_ref`，ref是**使用普通索引或者唯一性索引的部分前缀，匹配不唯一**

   <img src="/image-20200401003645984.png" alt="image-20200401003645984" style="zoom:150%;" />

5. **ref_or_null**：相比ref,多了搜索值=null的行

   ![image-20200401011336914](/image-20200401011336914.png)

6. **index_merge**：表示使用了索引合并的优化方法。执行计划用到两个索引，mysql进行合并索引。
   例如下表：id是主键，tenant_id是普通索引。or 的时候没有用 primary key，而是使用了 primary key(id) 和 tenant_id 索引。

   ![image-20200401011636617](/image-20200401011636617.png)

7. **range**：用到了索引，搜索范围。
   常见：in(), between ,> ,<, >= ，like可能出现

8. **==index==**：用到了索引，只扫描索引树便得到了结果，但没有全表扫描（只使用索引文件）

   ![image-20200401012303621](/image-20200401012303621.png)

9. ==**ALL**==：全表扫描！！！(如果是数据量很大的表中出现这个，基本上必须**优化**)

## 5. possible_keys

## ==6. key==

​	**force index(inx_name)**：可强制使用指定索引
​	**ignore index(inx_name)**：可强制不使用指定索引

## 7. key_len

> 正常情况下，key_len越小 索引效果越好。

​	作用：通过这个值可以算出具体使用了索引中的哪些列，可助于**==定位索引失效部分==**，方法如下：
​	查看所用索引key，计算或者写一条使用到索引全字段的sql，计算出全索引的len值。再计算所用到的部分。[链接](https://www.cnblogs.com/xuanzhi201111/p/4554769.html)

## 8. ref

这一列显示了在key列记录的索引中，**表查找值所用到的列或常量**，可用来辅助判断:"用到了索引中的哪些列（但不准确，用key_len更准确）"
常见的有：const（常量），func，NULL，字段名（例：film.id）

## 9. rows

预计扫描多少行;

注：表分区这种情况,rows大小是明显比未分区的少的。

## ==10. extra==

1. ==**distinct**==：用到了distinct，表示：一旦mysql找到了与行相联合匹配的行，就不再搜索了。

2. ==**Using index**==：**相当高效**，使用了索引表即获得了想要的结果，无需访问表数据文件，即**==索引覆盖==**。

   例如：select list 中的内容都为所用索引中的字段。

   ![image-20200401110931503](/image-20200401110934580.png)

3. **==Using where==**：扫描了表数据文件

4. ==**Using temporary**==：出现临时表，效率非常低，**建议优化**.(group by , union，join 一般会产生临时表)

   ![image-20200401113058070](/image-20200401113058070.png)

5. ==**Using filesort**==：**排序字段未能用到索引时，Mysql使用“FileSort(文件排序)”策略**.mysql 会对结果使用一个外部索引排序，而不是按索引次序从表里读取行。此时mysql会根据联接类型浏览所有符合条件的记录，并保存排序关键字和行指针，然后排序关键字并按顺序检索行信息。这种情况下一般也是要考虑使用索引来优化的。**建议优化**.

   ![image-20200401113938970](/image-20200401113938970.png)

   ==**补充：**== 

     using index ：使用覆盖索引的时候就会出现
     using where：在查找使用索引的情况下，需要回表去查询所需的数据
     using index condition：查找使用了索引，但是需要回表查询数据
     using index & using where：查找使用了索引，但是需要的数据都在索引列中能找到，所以不需要回表查询数据

---

## sql优化

思路：定位--解析--优化

### **==面试答复==**：

1. 如果只是去优化一条sql，可以先利用==系统日志== or ==slow.log==去定位到此sql的执行时长，判断是否需要优化。
2. 确认需要优化后，用explain查看sql执行计划，讲一下expalin主要列的作用。
3. 如果没有能用到的索引，则考虑是否添加索引。需要对索引知识和==系统中的表和业务==都比较了解。==添加索引原则==：==越频繁查询的字段应排在索引列前列，有利于最左前缀原则的匹配==；添加索引要综合其合理性，是否可以唯一等等因素，需对系统业务有所了解。
4. 如果已经有索引，但却没有用到，也即==索引失效==，查找失效原因。补充常见索引失效的场景。
5. 如果sql上无法优化，则考虑是否可以在业务代码进行优化。其实在sql优化之前我们可以查看业务代码是否存在不合理的情况。
6. ==系统长期评估慢查询方案==：使用anemometer+pt-quert-digest搭建一套慢查询可视化的平台。相比mysqldumpslow更加的直观，更适用。定期备份slow.log，不应让slow.log文件过大，然后在该平台上进行分析判断。

### 1. 索引失效（部分/全部失效）

1. **最左前缀原则**：mysql使用索引时，会从索引的第一个字段开始匹配，中间哪个字段缺失，则从该字段开始失效。
   **比如**：索引列是 c1_c2_c3，如果用到了c2,c3，则全部失效。如果用c1,c3，则c2,c3失效。

   **所以**:建立索引时，==越频繁查询的字段应排在索引列前列，有利于最左前缀原则的匹配==

2. 使用索引列做查询时尽量不要在索引列上做**计算、函数、类型转换，把逻辑移到代码层中而不是数据库层**。
   如：select * from tbname where id+1=2;
           select * from tbname where left(id,2)=10;

   ![image-20200406233040015](/image-20200406233040015.png)
   类型转换的例子：

   ![image-20200406232552408](/image-20200406232552408.png)

   ![image-20200406232718305](/image-20200406232718305.png)

3. mysql的索引分类方式很多，其中一种分法：**聚簇索引Clustered Index**(PK-->not null unique-->rowid)和**非聚簇索引Secondary Index**。
   **聚簇索引优于非聚簇索引**，因为聚簇索引不会[回表查询](https://www.cnblogs.com/yanggb/p/11252966.html)。非聚簇索引的叶子节点存储的是主键值/唯一值。
   ![image-20200409152014416](/image-20200409152014416.png)

4. 范围之后全失效
   ![image-20200407000801926](/image-20200407000801926.png)

5. !=,<>,is null,is not null很大可能导致索引失效。（索引建表时，应尽量+ not null）

6. like以通配符开头会索引失效
   ![image-20200407002104935](/image-20200407002104935.png)
   ==**如果非要%xx%或%xx,则可以使用覆盖索引原则解决。即select list中的字段都为索引的字段。**==

口诀：<img src="/image-20200407010115365.png" alt="image-20200407010115365" style="zoom: 67%;" />

### 2. join语句优化：

left join:先加载左表，**左表外循环**出每条数据，到**右表（内循环）**中查找。类似上述的eq_ref例子。
		所以右表最好要在关联字段上加索引。左表在允许的情况下也加索引。右连接同理。
所以：**左连接，索引建右表；右连接，索引建左表。最好就是全都建。**

规律：永远是**==小表驱动大表==**,先优化内循环。

### 3. exist 和 in

in （subquery），如果这个subquery查出的数据量很小就用in。否则用exist.

### 4. order by优化

排序字段只有和where用到的字段一致时，mysql才能使用这个索引来排序。

### 5. 大批量insert优化

1. 用load代替mysql/insert.
   用select ... into outfile或DataGrip导出数据

   ```sql
   select * from mss_packet into outfile '/var/lib/mysql-files/mss_packet.tsv.bak' fields terminated by '\t' enclosed by '"' lines terminated by 'fuck';
   
   load data infile '/var/lib/mysql-files/mss_packet.tsv.bak' into table mss_packet fields terminated by '\t' enclosed by '"' lines terminated by 'fuck';
   ```

### 6.update...in优化

实战笔记：

```sql
-- 优化前
UPDATE dpa_deposit
SET max_remain_bal = '50000000.00'
WHERE sub_acct_no IN (SELECT sub_acct_no
                      FROM dpa_sub_account a, dpb_card_change b
                      WHERE a.acct_no = b.acct_no AND a.prod_id = 'VCC1' AND b.card_acct_mdy_type = 'C' AND
                            b.data_create_time > '20200402%');
```

![image-20200430172734682](/image-20200430172734682.png)

```sql
-- 优化后
explain update dpa_deposit a inner join dpa_sub_account b on a.sub_acct_no=b.sub_acct_no inner join dpb_card_change c
    on  b.acct_no=c.acct_no SET a.max_remain_bal = '50000000.00' where b.prod_id='VCC1' AND c.card_acct_mdy_type='C'
and c.data_create_time>'20200402%' ;
```

![image-20200430172653012](/image-20200430172653012.png)

**对比**：优化最主要差异在于：UPDATE。
原sql：update的type为index，rows=9917.即每次update都会扫描全索引树，所以rows=dpa_deposit表记录数，而子查询中dpb_card_chage无可用索引，不可避免的是ALL。导致总扫描数据=7137*9917=70777629。

优化后sql：update的type=ref，并且该数据是唯一的，如果加上org='098'，是可以达到eq_ref的效果，但数据已经唯一，无需再加。总扫描数据=7137*1=7137



# [==Partition==](https://www.cnblogs.com/xibuhaohao/p/10154281.html#_label1)

> 概念：在物理磁盘层面对数据进行分区管理，

## 参数查询

1. 是否支持分区

   ```sql
   -- 5.6之前版本
   SHOW VARIABLES LIKE '%partition%';
   
   -- 5.6及之后
   show plugins;
   ```

2. 从information_schema系统库中的partitions表中查看分区信息

   ```sql
   SELECT * FROM information_schema.PARTITIONS WHERE TABLE_SCHEMA='bay_mvp1_cbs' AND TABLE_NAME='dpa_account';
   ```

   

## 类型

### RANGE分区

> 根据连续的列值区间进行分区，这些区间要连续且不能相互重叠。

测试脚本：

```sql
1.新建dpa_sub_account_test:复制dpa_sub_account的建表sql，并补充：
	....原建表sql(并加了hash_value为主键)...
	partition by RANGE (hash_value)(-- hash_value必须是主键/唯一键字段，且只能是整数,RANGE分区只支持一个列作为分区的key
	PARTITION p0 VALUES less THAN (10),-- 0到10，但不包含10
	PARTITION p1 VALUES less THAN (20),
	PARTITION p2 VALUES LESS THAN (30),
	PARTITION p3 VALUES LESS THAN (40),
	PARTITION p4 VALUES LESS THAN MAXVALUE
	);
	
2.插入300条数据：
INSERT INTO dpa_sub_account_test SELECT * FROM dpa_sub_account LIMIT 300;
```

测试现象：

从information_schema系统库中的partitions表中查看分区信息如下：

![image-20210418175650086](/image-20210418175650086.png)

### LIST分区

> 基于列值匹配一个离散值集合中的某个值来进行选择

通过使用“PARTITION BY LIST(expr)”来实现，
expr: 可以是某个列，也可以是基于某个列能返回一个整数值的表达式。

```sql
create table t_key( a int(11), b datetime) .......
    PARTITION BY LIST(store_id)
    PARTITION pNorth VALUES IN (3,5,6,9,17),
    PARTITION pEast VALUES IN (1,2,10,11,19,20),
    PARTITION pWest VALUES IN (4,12,13,14,18),
    PARTITION pCentral VALUES IN (7,8,15,16)
);
```

LIST分区没有类似如“VALUES LESS THAN MAXVALUE”这样的包含其他值在内的定义。将要匹配的任何值都必须在值列表中找到。

### HASH分区

> 通过对表的一个或多个列的Hash Key进行计算，最后通过这个Hash码不同数值对应的数据区域进行分区。
>
> 可将数据均匀的分布到预先定义的各个分区中，保证各分区的数据量大致一致。

```sql
create table t_key( a int(11), b datetime) .......
partition by hash(year(b)) partitions 4;
-- year(b):需要返回一个整数值
-- partitions 4:partitions子句中的值是一个非负整数，不加的partitions子句的话，默认为分区数为1。
```

### KEY分区

> key分区和hash分区相似，不同在于hash分区是用户自定义函数进行分区，key分区使用mysql数据库提供的函数进行分区，NDB cluster使用MD5函数来分区，对于其他存储引擎mysql使用内部的hash函数。

```sql
create table t_key( a int(11), b datetime) .......
partition by key(b) partitions 4;
```

==注==：上面的RANGE、LIST、HASH、KEY四种分区中，分区的条件必须是整形，如果不是整形需要通过函数将其转换为整形。

### Columns分区

> mysql-5.5开始支持COLUMNS分区，可视为RANGE和LIST分区的进化，COLUMNS分区可以直接使用非整形数据进行分区。
>
> ==这里只简单说明，详情再查。==

1. **COLUMNS分区支持以下数据类型：**
   - 整形支持：tinyint,smallint,mediumint,int,bigint;不支持decimal和float
   - 时间类型支持：date,datetime
   - 字符类型支持：char,varchar,binary,varbinary;不支持text,blob

2. **COLUMNS可以使用多个列进行分区。**

```sql
1. 日期字段分区
CREATE TABLE members (
    id INT,
    joined DATE NOT NULL
).......略
PARTITION BY RANGE COLUMNS(joined) (
    PARTITION a VALUES LESS THAN ('1960-01-01'),
    PARTITION b VALUES LESS THAN ('1970-01-01'),
    PARTITION c VALUES LESS THAN ('1980-01-01'),
    PARTITION d VALUES LESS THAN ('1990-01-01'),
    PARTITION e VALUES LESS THAN MAXVALUE
);

2.多个字段组合分区

CREATE TABLE rcx (
    a INT,
    b INT
    )
PARTITION BY RANGE COLUMNS(a,b) (
     PARTITION p0 VALUES LESS THAN (5,10),
     PARTITION p1 VALUES LESS THAN (10,20),
     PARTITION p2 VALUES LESS THAN (15,30),
     PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE)
);
```

## 增删改



# ==开源工具==

## pt-query-digest

### 简介

**Percona Toolkit**是由**Percona**开发的高级**开源**命令行工具的集合，pt-query-digest属于**Percona Toolkit**中其中一款工具。
pt-query-digest可以分析binlog、General log、slowlog，也可以通过SHOWPROCESSLIST或者通过tcpdump抓取的MySQL协议数据来进行分析。

### 安装

可单独安装pt-query-digest，或安装percona-toolkit全套工具。需要perl模块支持。

### 使用

**SYNOPSIS**：`pt-query-digest [OPTIONS] [FILES] [DSN]`，具体参数直接百度

### 示例

**1.直接分析慢查询文件:**

```sh
pt-query-digest slow.log > slow_report.log
```

**2.分析最近n小时内的查询：**

==--since== : 指定起始时间，12h表示从12小时前，或指定时间'2017-01-07 09:30:00'

```shell
pt-query-digest --since=12h slow.log > slow_report2.log
```

**3.分析指定时间范围内的查询：**

==--unitl== :截止时间

```shell
pt-query-digest slow.log --since '2017-01-07 09:30:00' --until '2017-01-07 10:00:00'> > slow_report3.log
```

**4.分析指含有select语句的慢查询**

==--filter==：按指定的[字符串](http://www.php.cn/wiki/57.html)进行匹配过滤后再进行分析。关于--filter的细则，可查看[使用手册](F:\CodeDaily\3.数据库\Percona_Toolkit_3.1.0使用手册.pdf)

```shell
pt-query-digest --filter '$event->{fingerprint} =~ m/^select/i' slow.log> slow_report4.log
```

**5.针对某个用户的慢查询**

```shell
pt-query-digest --filter '($event->{user} || "") =~ m/^root/i' slow.log> slow_report5.log
```

**6.查询所有所有的全表扫描或full join的慢查询**

```shell
pt-query-digest --filter '(($event->{Full_scan} || "") eq "yes") ||(($event->{Full_join} || "") eq "yes")' slow.log> slow_report6.log
```

**7.把查询保存到query_review表**

==--review==：将分析结果保存到表中，这个分析只是对查询条件进行参数化，一个类型的查询一条记录，比较简单。当下次使用--review时，如果存在相同的语句分析，就不会记录到数据表中。
==--create-review-table==：当使用--review参数把分析结果输出到表中时，如果没有表就自动创建。

```shell
pt-query-digest --user=root --password=root --review h=localhost,D=slowdb,t=query_review --create-review-table slow.log
```

**8.把查询保存到query_history表**

==--history== ：将分析结果保存到表中，分析结果比较详细，下次再使用--history时，如果存在相同的语句，且查询所在的时间区间和历史表中的不同，则会记录到数据表中，可以通过查询同个**CHECKSUM**来比较某类型查询的历史变化。
==--create-history-table== 当使用--history参数把分析结果输出到表中时，如果没有表就自动创建。

```shell
pt-query-digest --user=root --password=root --history h=localhost,D=slowdb,t=query_review_history --create-history-table slow.log_0002
```

**9.通过tcpdump抓取mysql的tcp协议数据，然后再分析**

```shell
tcpdump -s 65535 -x -nn -q -tttt -i any -c 1000 port 3306 > mysql.tcp.txt 
pt-query-digest --type tcpdump mysql.tcp.txt> slow_report9.log
```

**10.分析binlog**

```shell
mysqlbinlog mysql-bin.000093 > mysql-bin000093.sql
pt-query-digest --type=binlog mysql-bin000093.sql > slow_report10.log
```

**11.分析general log**

```shell
pt-query-digest --type=genlog localhost.log > slow_report11.log
```

### 执行结果

> 可分为三部分查看：总体--分组统计--每组详情

**第一部分：总体统计情况**

```sql
# 100.3s user time, 2.6s system time, 59.05M rss, 251.50M vsz
# Current date: Sat Apr 11 20:38:34 2020
# Hostname: localhost.localdomain
# Files: ./slow/mysql_slow.log_00_aa
-- sql总数量，唯一的语句数量，QPS，并发数
# Overall: 509.03k total, 310 unique, 1.20 QPS, 0.45x concurrency ________
-- unique：表示对查询条件进行参数化以后，总共有多少个不同的查询。
# Time range: 2019-12-05T05:05:57 to 2019-12-10T03:00:21
# Attribute          total     min     max     avg     95%  stddev  median
# ============     ======= ======= ======= ======= ======= ======= =======
# Exec time        190691s    67us   2823s   375ms     8ms     17s   287us
# Lock time         54328s       0   2300s   107ms   204us     11s    89us
# Rows sent          1.38G       0  22.89M   2.84k    0.99 182.53k       0
# Rows examine       2.26G       0  22.89M   4.65k   7.68k 189.45k  143.84
# Query size       163.08M       6   9.58k  335.94  463.90  173.18  400.73
-- stddev 标准差
-- median 中位数
-- Exec time 语句执行时间;	
-- Lock time 锁占用时间;
-- Rows sent 发送到客户端的行数;	Rows examine 扫描行数; Query size 查询大小
-- 95%表示其中95%，eg:Exec time->95% 表示：有95%sql的平均执行时间=8ms
```

**第二部分：按分组统计情况**

```sql
# Profile
# Rank Query ID                  Response time    Calls  R/Call    V/M   I
# ==== ========================= ================ ====== ========= ===== =
#    1 0xE3C753C2F267B2D767A3... 71016.6935 37.2%   9936    7.1474 65... SELECT aps_packet_?
#    2 0x245FEB4272D98518DFE8... 26920.8060 14.1%    835   32.2405 57.14 UPDATE ksys_service_notify
#    3 0xFFFCA4D67EA0A7888130... 20960.6889 11.0%    231   90.7389 12... COMMIT
#    4 0x63AFE254C13E96BEBCF8... 20383.4016 10.7%     39  522.6513 88... SELECT

-- Rank          排名
-- Query ID      查询识别码
-- Response time 某类查询总响应时间，和百分比
-- Calls         总次数
-- R/Call        平均响应时间 = Response/Calls = 总响应时间/总次数
-- V/M           响应时间Variance-to-mean的比率
-- Item          sql
```

**第三部分：每组详细统计结果**

```sql
# Query 1: 0.03 QPS, 0.20x concurrency, ID 0xE3C753C2F267B2D767A347A2812914DF at byte 70971444
-- Query 就是第二部分的Rank排名
-- ID 也是第二部分的Query ID
# This item is included in the report because it matches --limit.
# Scores: V/M = 650.11
# Time range: 2019-12-05T17:00:14 to 2019-12-09T20:04:46
-- pct:该组查询占整体的百分比，total/total=9936/509.03k≈1.9%
# Attribute    pct   total     min     max     avg     95%  stddev  median
# ============ === ======= ======= ======= ======= ======= ======= =======
# Count          1    9936
# Exec time     37  71017s    67us   2230s      7s      4s     68s    23ms
# Lock time      0    343s       0    127s    34ms       0      2s       0
# Rows sent     99   1.38G       0  22.89M 145.33k  51.46k   1.27M    2.90
# Rows examine  61   1.38G       0  22.89M 145.33k  51.46k   1.27M    2.90
# Query size     0 549.94k      43      93   56.68   65.89    6.02   54.21
# String:
# Databases    cbs_uat_cu... (2415/24%), cbs_uat (2400/24%)... 15 more-- 各数据库的次数（占比）
# Hosts        localhost
# Users        mydbasql (9455/95%), los (481/4%)-- 各个用户执行的次数（占比）
# Query_time distribution	-- 查询时间分布
#   1us
#  10us  ###
# 100us  ################################################################
#   1ms  #################
#  10ms  ##############################################################
# 100ms  #############################################
#    1s  #########
#  10s+  ########
# Tables
#    SHOW TABLE STATUS FROM `cbs_uat_cug2` LIKE 'aps_packet_20191014'\G
#    SHOW CREATE TABLE `cbs_uat_cug2`.`aps_packet_20191014`\G
SELECT /*!40001 SQL_NO_CACHE */ * FROM `aps_packet_20191014`\G
# Converted for EXPLAIN
# EXPLAIN /*!50100 PARTITIONS*/
SELECT /*!40001 SQL_NO_CACHE */ * FROM `aps_packet_20191014`\G
```

---

## SQLAdvisor

[美团开源项目](https://github.com/Meituan-Dianping/SQLAdvisor)，索引优化建议。[sqladvisor-web](https://github.com/zyw/sqladvisor-web)提供了web界面操作	

```shell
sqladvisor --help
sqladvisor -h xx  -P xx  -u xx -p 'xx' -d xx -q "sql" -v 1
sqladvisor -f sqladvisor.cnf -v 1
```

### ==**优化过程备忘**：==

1. pt-query-digest分析slow.log到本地表
2. 支持远程，则sqladvisor直接执行，初步得到结果，但如果需要修改测试的话，还是需要复制到本地库。
3. 不支持远程，则复制数据到本地库。数据量大则用select...into outfile + load data infile.