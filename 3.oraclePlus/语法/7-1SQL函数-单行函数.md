<!--单行函数-->

--1.字符函数 

```
字符串大小写转换函数

--initCap (待转换的字符串)：将字符串首字母转换成大写，其余的转换成小写
select initCap(ename) from emp;

--lower(待转换的字符串):将参数里面的字符串，转换成小写
select lower(ename) from emp where lower(ename) ='scott';

--upper(待转换的字符串):将参数里面的字符串，转换成大写
select upper('helloworld') from dual;
--concat(字符串1，字符串2):将字符串1和字符串2连接起来获得一个新的字符串
select concat(concat(concat('员工编号:',empno),'员工姓名：'),ename) from emp;
select  concat(concat('员工姓名：',ename),'薪资') from emp;

--substr(字符串，开始位置，数量):拆分字符串
select substr('hellowrold',6,5) from dual;（wrold）
/*
       下标1：代表从第几个字符开始拆分
       下标2：数量
	角标从1开始
*/

--lpad(补齐字符串，整体补齐的位数，不够位数就用指定的字符)：左补齐
select lpad('1',3,'0') from dual;

--rpad(补齐字符串，整体补齐的位数，不够位数就用指定的字符)：右补齐
select rpad(11,3,'0') from dual;

--instr(字符串，查找字符,起始位置):返回该字符在字符串中的第一个出现位置(绝对角标)
select instr('hello','e',2) from dual;

--length： 返回字符串的长度
select length('hellowrold') from dual;

--replace：替换
select replace(ename, 'A','a') name,job,hiredate from emp;
```



--2.数字函数

```
--ceil(待向上取整的值):天花板
select ceil(47.46) from dual;

--floor(待向下取整的值):地板
select floor(-47.46) from dual;

--mod (值1，值2):% 取余
select mod(1600,300) from dual;

--round(待四舍五入的值，保留小数点的位数):
select round(57.56,2) from dual;

--trunc(待截断的值，保留小数位)
select trunc(47.56666666,2) from dual;
```

--3.日期函数

```
--add_months(待增加的日期，要增加的月份数)：把增加月份数后的日期返回
select  to_date('2018-1-31','yyyy-mm-dd') +30 from dual;
select add_months(to_date('2018-1-31','yyyy-mm-dd'),1) from dual;

--next_day(指定的日期,星期几)：返回指定日期的下一个的星期几
select   next_day(sysdate,'星期一') from dual;

--last_day(指定的日期)：返回指定日期所在月份中的最后一天
select last_day(sysdate) from dual;

--trunc(指定的日期)------trunc(指定的日期,'指定字段')
select trunc(sysdate) from dual; /*截断时分秒，返回年月日*/
select trunc(sysdate,'yyyy') from dual;/*返回指定日期所在年份的第一天*/
select trunc(sysdate,'mm') from dual;/*返回指定日期所在月份的第一天*/
select trunc(sysdate,'dd') from dual;
select trunc(sysdate,'day') from dual;

--round :--对日期“四舍五入”
select round(to_date('2018-02-15','yyyy-mm-dd'),'mm') from dual;
select round(sysdate,'yyyy') from dual;
```

--4.转换函数 

```
--to_date（字符串--->日期）
select to_date('2018-04-29 12:22:22','yyyy/mm-dd hh24:mi:ss') from dual;

--to_char（日期-->字符串-）
select to_char(sysdate,'hh') from dual;
```

--5.其他函数

```
--nvl(值1，值2)： 如果值1为空，则返回值2,反之则返回值1
select nvl(comm,0)+100 from emp;
select empno,nvl(comm,0)+100 from emp;

--decode(值1，if1,then1,if2,then2,else )
select empno, ename,sal,deptno,decode(deptno,10,'ACCOUNTING' ,20,'RESEARCH' ,30,'SALES',40,'OPERATIONS') from emp;                   
```

