#### 1. 可能会用到的sql：
``` sql
show variables like '%slow_query_log%';
show variables like '%slow_query_log_file%';
show variables like '%long_query_time%';

-- 没有索引的查询是否记录到慢查询日志
show variables like '%log_queries_not_using_indexes%';

-- 数据库版本
show variables like '%version%';

-- 查看表索引
SHOW INDEX FROM dpb_froze;
-- 看库的所有索引
SELECT * FROM information_schema.STATISTICS WHERE table_schema='cbs_uat_cug2';
```
---
#### 2. mysql-slow.log文件内容如下：
``` sql
# Time(发生时间): 2017-06-03T06:48:27.030315Z
# User@Host: root[root] @ localhost（主机信息） []  Id:3
# Query_time（查询时间）: 1.896889  Lock_time（等待锁的时间）: 0.000823 Rows_sent(返回客户端行总数): 100000  Rows_examined(扫描行总数): 200000
SET timestamp=1496472507; 
select * from z_order limit 100000;

注：DML语句也会记录到日志中
```
---

#### 3. 执行  mysqldumpslow mysql-slow.log，查看内容如下：
````sql
Reading mysql slow query log from mysql-slow.log
Count: 2  Time=3.64s (17s)  Lock=0.00s (0s)  Rows=100000.0 (200000), root[root]@localhost
  select * from z_order left join z_league on z_order.league_id = z_league.id limit N

Count: 2  Time=1.05s (200s)  Lock=0.00s (0s)  Rows=55000.0 (110000), root[root]@localhost
  select * from z_order limit N
​```
- Count：出现次数,
- Time：执行最长时间和累计总耗费时间
- Lock：等待锁的时间
- Rows：单次查询返回的平均行数(累计返回的总行数≈count*单次查询返回的平均行数)
````
#### 4.常用的mysqldumpslow参数

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

