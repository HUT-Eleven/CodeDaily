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
- Rows：返回客户端行总数和扫描行总数
````