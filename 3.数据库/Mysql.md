---
typora-copy-images-to: /assets
typora-root-url: /assets
---

### ==高级语法==

#### 1. help

```sql
help 关键字...
-- 需要在命令行界面执行
help show
help show processlist
help lock
help select
......
```

#### 2. show

`help show`：查看show的所有用法。show指令的参数繁多，以下罗列几种常用的，[具体上网查询](https://www.cnblogs.com/saneri/p/6963583.html)。

##### status--服务器状态信息

```sql
help show status
Syntax:
	SHOW [GLOBAL | SESSION] STATUS [LIKE 'pattern' | WHERE expr]
-- 常用like，where不常用where variable_name='xxx%';共有400+个值
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
```

##### variables--服务器变量

![image-20200408002239845](/image-20200408002239845.png)

```sql
-- 慢查询相关
slow_query_log			-- 慢查询开关
slow_query_log_file 	-- 慢查询文件位置
long_query_time 		-- 慢查询阈值，单位秒，
slow_queries			-- 慢查询次数
slow_launch_time 		-- 创建线程的阈值,且Slow_launch_threads(慢建立线程数)+1
log_queries_not_using_indexes	-- 没有索引的查询是否记录到慢查询日志
......
```

修改变量：

1. set [session] xxx;	-- 只在当前会话生效
2. set global xxx;		-- 全局生效，但在设置之前打开的会话不生效，重启mysql后失效。**有些变量非全局,则不能添加global**。

3. 修改配置文件          -- 重启后生效。

结论：若想修改服务器变量但当下又不想重启服务，可以通过set global,同时应修改配置文件，避免重启后失效。

#### 3. [load data infile](https://www.cnblogs.com/kiwi/archive/2012/11/29/2794124.html) 

> insert和mysql（执行文件）都可以插入数据，但本质都是执行sql。当==**大批量插入**==时使用load更快。load加载的文件里只有数据，没有sql命令。

```sql
load data  [low_priority] [local] infile 'file_name.tsv'   [replace | ignore]   into table tbl_name
[fields  [terminated by'\t']   [ [OPTIONALLY]  enclosed by '']  [escaped by'\\' ]  ]
[lines   terminated by'\n']
[ignore number lines]
[(col_name, )]

low_priority:	降低优先级，等读共享锁无使用时，才进行写
local：	文件在客户端，不在数据库的服务器上https://www.iteye.com/blog/tangmingjie2009-889925
replace和ignore：控制唯一键重复处理。replace替换，ignore跳过
fields：指定了文件每行字段格式
	terminated by	描述字段间的分隔符，默认情况下是tab字符（\t）
	[OPTIONALLY] enclosed by	描述的是字段的括起字符(eg: enclosed by '"' 即"xxx"，一般不指定),OPTIONALLY表示，只对char/varchar/text等等这些加enclose by字符
	escaped by		描述的转义字符。默认的是反斜杠
	默认效果：fields terminated by'\t' enclosed by '' escaped by'\\'
lines:指定了行与行之间关系
	默认效果：lines terminated by'\n'
ignore number lines:忽略前几行，通常用来忽略首行字段名
```

==需要注意的问题：==

1. 权限问题：other用户+r

2. local问题：https://www.iteye.com/blog/tangmingjie2009-889925

3. **secure-file-priv**的值三种情况：

   ```sql
   null	-- 禁止导入导出
   /xx/xx/	--表示只允许导入导出该目录下文件（PS：测试子目录也不行）
   空		--不限制导入导出
   ```

4. ==空值问题==：==字段中的空值用**\N**表示==

   - select... into outfile默认导出为\N

   - 用DataGrip导出数据
     <img src="/image-20200414162531977.png" alt="image-20200414162531977" style="zoom:50%;" />

5. ==字段中存在换行==:

   - 导出文件时定义字段括起符和换行符：fields enclosed by '"' lines terminated by 'XFuckX'
     即：用双引号阔起字段值，用XFuckX作为换行标志符。导入时也同样如此。
     可以用select...into outfile 或者 DataGrip（DataGrip的这个功能完全等价于select...into outfile）
     <img src="/image-20200414180011316.png" alt="image-20200414180011316" style="zoom: 67%;" />

   

#### 4. select ... into outfile

`select... into outfile 'file_name' [Fields... lines...]`

是与load data 对应的逆操作。两个命令的FIELDS和LINES子句的语法是相同的.
select...into outfile对于null值导出后默认为**\\N**   (escaped by 没修改)

### ==命令==

**以下命令无法详细记录，只能在平时遇到一些特殊场景做登记。**

#### 1.  mysql

```sql
-- 把SQL查询结果导出到tsv文件(用的少，等于select...into outfile少了登录一步，但功能单一)
mysql -uroot -p -P3306 -hlocalhost -B -e "select * from film_text" test > 8.tsv
-B: 指定数据库
-e: 指定sql
```

#### 2. mysqldump

`mysqldump [options] > dump.sql`
但可能用户权限受限，所以可用第三方软件（DataGrip...），导出的是**sql格式**的。

[参数详解](https://www.cnblogs.com/flagsky/p/9762726.html)

#### 3. ==mysqldumpslow==
##### 3.1 日志内容

**注**：**DML**语句也会记录到日志中

``` sql
# Time(发生时间): 2017-06-03T06:48:27.030315Z
# User@Host: root[root] @ localhost（主机信息） []  Id:3
# Query_time（查询时间）: 1.896889  Lock_time（等待锁的时间）: 0.000823 Rows_sent(返回客户端行总数): 100000  Rows_examined(扫描行总数): 200000
SET timestamp=1496472507; 
select * from z_order limit 100000;
```

##### 3.2 使用

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

##### 3.3 执行结果

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

### ==事务==

#### 1. 四个问题

- 更新丢失
   非事务控制相关的问题，是锁相关的问题
- 脏读
- 不可重复读
- 幻读
   **幻读与不可重复读的区别**：不可重复读是对**同一行数据**的前后不一致。幻读是对**不同行数据**的前后不一致。

#### 2. 四种隔离级别

- read umcommitted-读未提交：
  session2 可以读到 session1 未提交的事务(脏读、不可重复读、幻读)；
- read committed- 读已提交:
  session2 不可以读到session1未提交的事务，但可能会因为session1提交后，导致出现读取的数据不一致（不可重复读、幻读）；
- repeatable read-可重复读：
  session2-->start transaction后，与其他事务是隔离状态（幻读）
- Serializable - 串行化

![image-20200408004145218](/image-20200408004145218.png)

#### 3. 问题记录

1.事务自动提交，导致事务不起作用？

查看数据库配置：

![image-20200320155136770](/image-20200320155136770.png)

可以看到autocommit是ON,
注：多数生产环境都必须配置为ON。
此时可以手动开启事务：

```sql
start transaction ;
```

---



---

### ==索引/Explain==

**重点**：explain可以模拟服务层中的Query Optimizer来查看==**Mysql执行计划**==，**也即执行阶段，非Query Optimizer分解sql进行优化的阶段！**所以，Explain显示的是执行计划。

#### 总览图

不同版本的Explain差异：

**5.5.x**

![image-20200331181524419](/image-20200331181524419.png)

**8.0.x**

==多了partitions/fitered==

![image-20200331181557503](/image-20200331181557503.png)

##### 1. id-表的读取顺序

规律：id越大，执行的优先级越高。id相同，则按从上到下的顺序。
			为null的情况：Union/ Union all结果总是放在一张临时表中，而这张临时表不在sql中体现，所以为null。null通常是最后执行

经验：往往最里层的子查询id更大，即越优先执行。			

![image-20200331190655049](/image-20200331190655049.png)

##### 2. select_type-查询类型

​	查询类型主要是针对“子查询”、“union查询”来划分的。

1. ==**simple**==：简单查询，**可以是多表**，但==不包含子查询 或 union==等

   ![image-20200331184650383](/image-20200331184650383.png)

2. ==**primary**==：复杂查询中最外层的 select

     如两表做UNION,则第一个union前的select是primary；
     存在子查询的最外层的表操作为primary。
      ![image-20200331184930309](/image-20200331184930309.png)

     ![image-20200331185122213](/image-20200331185122213.png)

3. ==**subquery**==：包含在 select 中的子查询（**不在 from 子句中**）

4. ==**derived**==：包含在 **from 子句中**的子查询。MySQL会将结果存放在一个临时表中，也称为派生表（derived）

   案例：primary、subquery、derived综合案例：==select **subquery** from **derived**==

   ![image-20200331191503511](/image-20200331191503511.png)

5. ==**union**==：在 union/union all中，除了第一张表的select_type为primary，后面的所有表的都为union

6. ==**union result**==：union/union all之后的结果（备：id值通常为NULL）

   ![image-20200331192207784](/image-20200331192207784.png)

7. **==dependent subquery==**(略)
##### 3. table-表

特殊：当 from 子句中有子查询时，table列是 <derivenN> 格式，表示当前查询**依赖** id=N 的查询，于是先执行 id=N 的查询。当有 union 时，UNION RESULT 的 table 列的值为 <union1,2>，1和2表示参与 union 的 select 行id。

![image-20200331192844388](/image-20200331192844388.png)

   	![image-20200331192922620](/image-20200331192922620.png)

##### 4. type-访问类型

**从好到差**：system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL。以及特殊：**null**
可能会因为一些原因，访问类型比预期要低，但一般不会高于预期。

1. **==null==**：mysql能够在优化阶段分解查询语句，并查到了想要的结果，在**执行阶段不用再访问表或索引**，所以访问类型为null。
   例如：**在索引列中选取最小值**，可以单独查找索引来完成，不需要在执行时访问表。

   ![image-20200331235919028](/image-20200331235919028.png)

2. ==**const, system**==：mysql能对查询的某部分进行优化并将其转化成一个常量（可以看**==show warnings==** 的结果）。常见场景：**==单表查询==用 primary key 或 unique key 的所有列与常数比较时**，则**只会有一行匹配**，读取1次，速度比较快。

   ![image-20200401000827664](/image-20200401000827664.png)

3. **==eq_ref==**：相比const/system,  er_ref就是**多表**的情况。primary key 或 unique key索引的所有列被使用 ，最多只会返回一条符合条件的记录。简单而言，就是外循环每次到内循环中遍历数据，都只有一条数据匹配。

   ![image-20200401003401450](/image-20200401003401450.png)

4. **==ref==**：相比 `eq_ref`，ref是**使用普通索引或者唯一性索引的部分前缀，匹配可能不唯一**

   <img src="/image-20200401003645984.png" alt="image-20200401003645984" style="zoom:150%;" />

5. ==**ref_or_null**==：相比ref,多了搜索值=null的行

   ![image-20200401011336914](/image-20200401011336914.png)

6. ==**index_merge**==：表示使用了索引合并的优化方法。执行计划用到两个索引，mysql进行合并索引。
   例如下表：id是主键，tenant_id是普通索引。or 的时候没有用 primary key，而是使用了 primary key(id) 和 tenant_id 索引。

   ![image-20200401011636617](/image-20200401011636617.png)

7. ==**range**==：用到了索引，搜索范围。
   常见：in(), between ,> ,<, >= ，like可能出现

8. ==**index**==：用到了索引，只扫描索引树便得到了结果，但没有全表扫描（使用索引文件）

   ![image-20200401012303621](/image-20200401012303621.png)

9. ==**ALL**==：全表扫描！！！(如果是数据量很大的表中出现这个，基本上必须**优化**)

##### 5. possible_keys-可能用到的索引

##### 6. key-用到的索引

​	**force index(inx_name)**：可强制使用指定索引
​	**ignore index(inx_name)**：可强制不使用指定索引

##### 7. key_len-索引里使用的字节数

​	作用：通过这个值可以算出具体使用了索引中的哪些列，可助于**==定位索引失效部分==**，方法如下：
​	查看所用索引key，计算或者写一条使用到索引全字段的sql，计算出全索引的len值。再计算所用到的部分。[链接](https://blog.csdn.net/fdipzone/article/details/55804684)

```mysql
key_len计算规则如下：
    字符串
        char(n)：n字节长度
        varchar(n)：2字节存储字符串长度，如果是utf-8，则长度 3n + 2
    数值类型
        tinyint：1字节
        smallint：2字节
        int：4字节
        bigint：8字节　　
    时间类型　
        date：3字节
        timestamp：4字节
        datetime：8字节
    如果字段允许为 NULL，需要1字节记录是否为 NULL；
	可变字符需要+2位
```

![image-20200401014734289](/image-20200401014734289.png)

##### 8. ref

这一列显示了在key列记录的索引中，**表查找值所用到的列或常量**，
常见的有：const（常量），func，NULL，字段名（例：film.id）

##### 9. rows

预计扫描多少行

##### 10. extra-额外信息

1. ==**distinct**==：用到了distinct，表示：一旦mysql找到了与行相联合匹配的行，就不再搜索了。

2. ==**Using index**==：**相当高效**，使用了索引表即获得了想要的结果，无需访问表数据文件，即**==索引覆盖==**。

   例如：select list 中的内容都为所用索引中的字段。

   ![image-20200401110931503](/image-20200401110934580.png)

3. **==Using where==**：扫描了表数据文件

4. ==**Using temporary**==：出现临时表，效率非常低，**建议优化**.(group by 一般会产生临时表)

   ![image-20200401113058070](/image-20200401113058070.png)

5. ==**Using filesort**==：**排序字段不是 或者不能使用索引时，Mysql使用“FileSort(文件排序)”策略**.mysql 会对结果使用一个外部索引排序，而不是按索引次序从表里读取行。此时mysql会根据联接类型浏览所有符合条件的记录，并保存排序关键字和行指针，然后排序关键字并按顺序检索行信息。这种情况下一般也是要考虑使用索引来优化的。**建议优化**.

   ![image-20200401113938970](/image-20200401113938970.png)

---

#### sql优化

思路：定位--解析--优化

##### **==面试答复==**：

1. 如果只是去优化一条sql，可以先利用==系统日志== or ==slow.log==去定位到此sql的执行时长，判断是否需要优化。
2. 确认需要优化后，用explain查看sql执行计划，讲一下expalin主要列的作用。
3. 如果没有能用到的索引，则考虑是否添加索引。需要对索引知识和==系统中的表和业务==都比较了解。==添加索引原则==：越频繁查询的字段应排在索引列前列，有利于最左前缀原则的匹配；添加索引要综合其合理性，是否可以唯一等等因素，需对系统业务有所了解。
4. 如果已经有索引，但却没有用到，也即==索引失效==，查找失效原因。补充常见索引失效的场景。
5. 如果sql上无法优化，则考虑是否可以在业务代码进行优化。其实在sql优化之前我们可以查看业务代码是否存在不合理的情况。
6. ==系统长期评估慢查询方案==：使用anemometer+pt-quert-digest搭建一套慢查询可视化的平台。相比mysqldumpslow更加的直观，更适用。定期备份slow.log，不应让slow.log文件过大，然后在该平台上进行分析判断。

##### 1. 索引失效（部分/全部失效）

1. **最左前缀原则**：如果(where/order by/group by后面)引用到了复合索引，要尽可能**按左到右的顺序**使用到索引。**索引哪一列开始没用上，索引就从哪里开始失效**。
   **比如**：索引列是 c1_c2_c3，如果用到了c2,c3，则全部失效。如果用c1,c3，则c2,c3失效。
   
2. 使用索引列做查询时尽量不要在索引列上做**计算、函数、类型转换，把逻辑移到代码层中而不是数据库层**。
   如：select * from tbname where id+1=2;
           select * from tbname where left(id,2)=10;

   ![image-20200406233040015](/image-20200406233040015.png)
   类型转换的例子：
   
   ![image-20200406232552408](/image-20200406232552408.png)
   
   ![image-20200406232718305](/image-20200406232718305.png)
   
3. mysql的索引分类方式很多，其中一种分法：**聚集索引**(PK-->not null unique-->rowid)和**非聚集索引**。
   **聚集索引优于非聚集索引**，因为聚集索引不会[回表查询](https://www.cnblogs.com/yanggb/p/11252966.html)。非聚集索引的叶子节点存储的是主键值/唯一值。
   ![image-20200409152014416](/image-20200409152014416.png)

4. 范围之后全失效
   ![image-20200407000801926](/image-20200407000801926.png)

5. !=,<>,is null,is not null很大可能导致索引失效。（索引建表时，应尽量+ not null）
6. like以通配符开头会索引失效
   ![image-20200407002104935](/image-20200407002104935.png)
   ==**如果非要%xx%或%xx,则可以使用覆盖索引原则解决。即select list中的字段都为索引的字段。==**

口诀：![image-20200407010115365](/image-20200407010115365.png)

##### 2. join语句优化：

left join:先加载左表，**左表外循环**出每条数据，到**右表（内循环）**中查找。类似上述的eq_ref例子。
		所以右表最好要在关联字段上加索引。左表在允许的情况下也加索引。右连接同理。
所以：左连接，索引建右表；右连接，索引建左表。最好就是全都建。

规律：永远是**==小表驱动大表==**,优先优化内循环。左连接：左边的永远是“大表”，右边是“小表”。小表驱动大表原则,在小表上建索引。

##### 3. exist 和 in

in （subquery），如果这个subquery查出的数据量很小就用in。否则用exist.

##### 4. order by优化

##### 5. 大批量insert优化

1. 用load代替mysql/insert.
   用select ... into outfile或DataGrip导出数据

   ```sql
   select * from mss_packet into outfile '/var/lib/mysql-files/mss_packet.tsv.bak' fields terminated by '\t' enclosed by '"' lines terminated by 'fuck';
   
   load data infile '/var/lib/mysql-files/mss_packet.tsv.bak' into table mss_packet fields terminated by '\t' enclosed by '"' lines terminated by 'fuck';
   ```

---

### ==锁==

锁：是计算机协调多个进程/线程并发访问**同一个资源**的机制.



读锁会阻塞写，但不会阻塞读。写锁会把读和写都阻塞。



innodb行锁变表锁？为什么？mysql8还有这么智障吗？





间隙锁？



### ==开源工具==

#### ==pt-query-digest==

##### 简介

**Percona Toolkit**是由**Percona**开发的高级**开源**命令行工具的集合，pt-query-digest属于**Percona Toolkit**中其中一款工具。
pt-query-digest可以分析binlog、General log、slowlog，也可以通过SHOWPROCESSLIST或者通过tcpdump抓取的MySQL协议数据来进行分析。

##### 安装

可单独安装pt-query-digest，或安装percona-toolkit全套工具。需要perl模块支持。

##### 使用

**SYNOPSIS**：`pt-query-digest [OPTIONS] [FILES] [DSN]`，具体参数直接百度

**示例：**

**1.直接分析慢查询文件:**

```sh
pt-query-digest slow.log > slow_report.log
```

**2.分析最近12小时内的查询：**

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
tcpdump -s 65535 -x -nn -q -tttt -i any -c 1000 port 3306 > mysql.tcp.txt``pt-query-digest --type tcpdump mysql.tcp.txt> slow_report9.log
```

**10.分析binlog**

```shell
mysqlbinlog mysql-bin.000093 > mysql-bin000093.sql``pt-query-digest --type=binlog mysql-bin000093.sql > slow_report10.log
```

**11.分析general log**

```shell
pt-query-digest --type=genlog localhost.log > slow_report11.log
```

##### 执行结果

> 可分为三部分查看：总体--分组统计--每组详情

**第一部分：总体统计结果**

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
-- Exec time语句执行时间;	Lock time 锁占用时间;
-- Rows sent发送到客户端的行数;	Rows examine扫描行数; Query size 查询大小
-- Exec time->95% 表示：有95%sql的执行时间小于8ms
```

**第二部分：分组统计结果**

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
-- V/M           响应时间Variance-to-mean的比率???
-- Item          提取的具体查询
```

**第三部分：每组详细统计结果**

```sql
# Query 1: 0.03 QPS, 0.20x concurrency, ID 0xE3C753C2F267B2D767A347A2812914DF at byte 70971444
-- Query 就是第二部分的Rank排名
-- ID 也是第二部分的ID
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
# Databases    cbs_uat_cu... (2415/24%), cbs_uat (2400/24%)... 15 more
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

#### ==SQLAdvisor==

[美团开源项目](https://github.com/Meituan-Dianping/SQLAdvisor)，索引优化建议。[sqladvisor-web](https://github.com/zyw/sqladvisor-web)提供了web界面操作	

```shell
sqladvisor --help
sqladvisor -h xx  -P xx  -u xx -p 'xx' -d xx -q "sql" -v 1
```

