

--1.聚合函数和分组函数

```
--查询所有员工平均薪资
select avg (sal) from emp;

--查询所有员工薪资总和
select sum(sal) from emp;

--求出员工最大薪资
select max(sal) from emp;

select max(hiredate) from emp;

select max(ename) from emp;

--求出员工最小薪资
select  min(sal) from emp;

--统计员工人数(count里面可以是列名或者任意数字或者*，不建议用星号，建议用1，列名时，统计该列的行数，不指定列就是统计表的行数）
select count(1) from   emp;

--求每个部门的 人数，平均薪资，最大薪资，最小薪资，薪资总和
--筛选出部门平均薪资大于2000的部门

select 
       count(1) 部门人数,
       avg(sal) 平均薪资,
       max(sal) 最大薪资,
       min(sal) 最小薪资,
       sum(sal) 薪资总和,
       deptno 部门编号
from  emp  
group by deptno 
having  avg(sal) >2000;   
```

--2，分析函数：计算排名

```
--rank:存在并列的情况 ，会发生跳跃
--dense_rank:存在并列的情况 ，不会发生跳跃
--row_number:不存在并列的情况 ，不会发生跳跃--根据员工薪资在部门里面计算排名
```

```
select * from 
(select  
    empno,
    ename,
    job,
    deptno,
    sal,
    row_number()  over(partition by deptno order by sal desc,empno asc)  rn ,
    rank() over( partition by deptno  order by sal desc) rk ,
    dense_rank() over(partition by deptno order by sal desc) dr   
 from  emp )  t where t.rn=1;
```

