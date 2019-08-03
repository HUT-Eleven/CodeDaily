​       PL/SQL

## 1.理解PL/SQL组成及其体系结构

###  1.1.  PL/SQL的体系结构

####   1.1.1  什么是PL/SQL?

定义： PL/SQL是过程语言(Procedural Language)与结构化查询语言(SQL)结合而成的编程语言

PL/SQL引擎驻留在Oracle服务器中，该引擎接受PL/SQL块并对其进行编译执行，PL/SQL引擎包括过程语句执行器和SQL语句执行器

###### 为什么要使用PL/SQL?优点：

a1.支持SQL:SQL是访问数据库的标准语言，通过SQL命令，用户可以操纵数据库中的数据，PL/SQL支持所有的SQL命令，游标控制命令，事务控制命令，SQL函数，运算符和伪列等

a2.PL/SQL支持所有的SQL数据类型和null值

a3.支持面向对象编程

a4.性能更好：SQL是非过程语言，只能一条一条的执行，而PL/SQL可以将过程语句和SQL语句的多行代码块统一编译，然后执行。同时还可以把编译好的PL/SQL块存储起来，以备以后再用，减少应用程序和服务器之间的通信时间。所以PL/SQL执行效率会更高

a5.可移植性好：使用PL/SQL编写的应用程序语言，可以移值到任何操作平台的oracle服务器上。同时还可以编写可移植性的程序库，在不同的环境中使用

#### 1.2. PL/SQL块

PL/SQL块是构成PL/SQL程序的基本单元，它将逻辑上相关的声明和语句组合在一起

PL/SQL分为三个部分：声明部分，可执行部分和异常部分

语法：

 [declare  声明部分]

begin

   可执行语句

[Exception  异常部分]

end;

注意：

a1. PL/SQL是一种编程语言，有自已独有的数据类型，变量的声明以及流程控制语句，

a2.对大小写不敏感，为了规范，关键字全部大写，其余部分小写

a3.每一条语句以分号结束

#### 1.3. 变量的声明和常量

声明变量方法一：  使用  := 来给变量赋值，

**语法： 变量名  数据类型(长度)[:=初始值];**

**声明常量语法： 变量名  CONSTANT 数据类型(长度):=常量值;**

如下例子：

```
declare
   v_stuno number(5,0);           --声明变量
   v_stuname varchar(20);
   v_sex char(2):='男';           --声明变量时就赋值
   c_num constant number(5,0):=5; --声明常量，并给常量赋值
begin
   v_stuno:=100;  --给变量赋值
   v_stuname:='张三';
   dbms_output.put_line('学号：'||v_stuno||'  姓名：'||v_stuname||' 性别：'||v_sex||' 常量        为:'||c_num);
end; 
```

声明变量并赋值方法二：select ... into ...

```
declare
   v_stuname varchar(20) ;
   v_sex char(4);
begin
  select stuname,sex into v_stuname,v_sex from student where stuno=101;
  dbms_output.put_line('姓名：'||v_stuname||' 性别：'||v_sex);
end;
```

#### 1.4  PL/SQL中的特殊符号：

| 类型       | 符号        | 说明                                |
| ---------- | ----------- | ----------------------------------- |
| 赋值运算符 | :=          | PL/SQL中表示给变量赋值              |
| 连接字符   | \|\|        | 字符串连接操作符，相当于Java中的+号 |
| 注释       | --          | PL/SQL中的单行注释                  |
| 注释       | /**/        | PL/SQL中的多行注释，不可嵌套        |
| 分隔符     | <<>>        | 标签分隔符，只为标识程序特殊位置    |
| 范围操作符 | ..          | 如 1..5 表示从1到5                  |
| 算术运算符 | +,-,*,/     |                                     |
| 幂运算符   | **          | 求幂运算如3**2=9                    |
| 关系运算符 | >,<,>=,<=,= | 其中=表示相等，不是赋值             |
| 关系运算符 | <> ，！=    | 不等关系                            |
| 逻辑运算符 | AND,OR,NOT  |                                     |



## 2.了解变量的数据类型

 2.1 PL/SQL支持的内置数据类型：

  数据类型:  

​     a1.标量类型  ：数字类型，字符类型，布尔类型，日期时间

​    a2.LOB类型：BLOB,CLOB,NCLOB,BFILE

​    a3.属性类型: %type :  表示某个变量或数据库表中列的数据类型

​                     %rowtype:   表示表中一行的记录类型

2.2.字符数据类型包括：

   a1.char

   a2.varchar2

​    a3.long

​    a4.raw

​    a5.long raw

2.3.SQL类型与PL/SQL类型的比较

| 数据类型 | SQL类型（字节）           | PL/SQL类型（字节） |
| -------- | ------------------------- | ------------------ |
| CHAR     | 1..2000                   | 1..32767           |
| LONG     | 1..32760                  | 1..2147483647      |
| LONG RAW | 1..2GB 固定长度二进行数据 | 1..32760           |
| RAW      | 1..2000                   | 1..32767           |
| VARCHAR2 | 1..4000                   | 1..32767           |

| 类型                 | 说明                                     |
| -------------------- | ---------------------------------------- |
| NVARCHAR2            | unicode编码可变长度数据                  |
| NCHAR                | unicode编码固定长度数据                  |
| DATE                 | 日期类型数据,不包含毫秒，7字节的列       |
| TIMESTAMP            | DATE子类型，包含日期和时间，时间包括毫秒 |
| NUMBER(精度，小数位) | 数字类型                                 |
| BOOLEAN              | 布尔类型，可设：TRUE,FALSE,NULL          |
| CLOB                 | 字符型大对象，最多4G                     |
| NCLOB                | 存unicode编码大文本数据，最多4G          |
| BLOB                 | 二进制数据，最大4G                       |
| BFILE                | 存储外部文件，最大4G                     |

2.4. 属性类型：

用于引用数据库列的数据类型以及表中记录行的类型

-%TYPE  

-%ROWTYPE

使用属性类型的优点：

a1.不需要知道被引用的表列的具体类型和长度

a2.如果被引用对象的数据类型发生改变，PL/SQL变量的数据类型也随之改变

优化上面的变量的数据类型：

```
declare
   v_stuname student.stuname%type ;
   v_sex student.sex%type;
begin
  select stuname,sex into v_stuname,v_sex from student where stuno=101;
  dbms_output.put_line('姓名：'||v_stuname||' 性别：'||v_sex);
end;
```

如果查询表中的列比较多的话，声明变量就很多，挨个select into赋值会很繁琐，再次优化

```
 declare
     v_stu student%rowtype; --声明一个变量为表中数据行的类型
 begin
     select * into v_stu from student where stuno=101 ;
     dbms_output.put_line('学号：'||v_stu.stuno||'姓名：'||v_stu.stuname);
 end;
```

## 3.使用控制语句进行编程

3.1.PL/SQL支持的流程控制结构

a1.条件控制：

​    b1.  IF语句

```
 --统计一年级学生的人数，改为用户手动输入数据
  declare
       v_num number;
       v_gradename grade.gradename%type:=&gradename;  --动态输入值以&变量名    
   begin
        select gradename ,count(*) into v_gradename,v_num from student s inner join grade g
           on s.gradeid=g.gradeid 
           group by gradename
           having gradename=v_gradename;
        if v_num>0 then
           dbms_output.put_line(v_gradename||'的人数为：'||v_num);
        else
           raise NO_DATA_FOUND;  --找不到记录抛出异常        
        end if; 
        exception
           when NO_DATA_FOUND then
              dbms_output.put_line(v_gradename||'暂无学生');
           when OTHERS then
              dbms_output.put_line('未知异常');            
  end;    
```

  

```
  --求学生的平均分的等级---多分支选择结构
  declare
        v_level char(10);--平均分的等级
        v_avgscore number; --平均分
        v_stuno number:=&stuid; --手动输入学号
  begin
       select avg(stuscore) into  v_avgscore
          from score 
          where stuno=v_stuno;
       if v_avgscore>90 then
          v_level:='优秀';
       elsif v_avgscore>80 then
          v_level:='中等';
       elsif v_avgscore>60 then
          v_level:='一般';
       else
          v_level:='差';
       end if;
       dbms_output.put_line(v_stuno||'的平均分为：'||v_avgscore||'等级：'||v_level); 
 end;
```

 b2. CASE语句

```
     declare
        v_level char(10);--平均分的等级
        v_avgscore number; --平均分
        v_stuno number:=&stuid; --手动输入学号
     begin
        select avg(stuscore) into  v_avgscore
         from score 
         where stuno=v_stuno;
       case
         when v_avgscore>90 then
            v_level:='优秀';
         when  v_avgscore>80 then
            v_level:='中等';  
         when  v_avgscore>60 then
            v_level:='中等'; 
         else
            v_level:='差'; 
      end case;
         dbms_output.put_line(v_stuno||'的平均分为：'||v_avgscore||'等级：'||v_level); 
   end;
```

a2.循环控制

​    b1.LOOP循环

```
  --求1+2+3+...+100=?
    declare
        v_i number:=1; --循环变量
        v_sum number:=0; --和
    begin
       loop
         v_sum:=v_sum+v_i;
         v_i:=v_i+1;
         exit when v_i>100; --结束循环
       end loop;
          dbms_output.put_line('1+2+..+100='||v_sum);
    end;  
```

​    b2.WHILE循环

```
 --求1+2+3+...+100=? while循环
  declare
        v_i number:=1; --循环变量
        v_sum number:=0; --和
  begin
        while v_i<=100 
        loop
             v_sum:=v_sum+v_i;
             v_i:=v_i+1;
        end loop;
           dbms_output.put_line('1+2+..+100='||v_sum);
  end;  
```

​    b3.FOR循环

```
     --求1+2+3+...+100=? for循环
  declare
        v_i number:=1; --循环变量
        v_sum number:=0; --和
  begin
        for v_i in 1..100 
        loop
             v_sum:=v_sum+v_i;
            -- v_i:=v_i+1;
         end loop;
           dbms_output.put_line('1+2+..+100='||v_sum);
  end;   
```

## 4.使用异常处理问题

#### 4.1 oracle预定义的异常类型有：

**TOO_MANY_ROWS : SELECT INTO返回多行**
**INVALID_CURSOR :非法指针操作(关闭已经关闭的游标)**
ZERO_DIVIDE :除数等于零
DUP_VAL_ON_INDEX :违反唯一性约束
ACCESS_INTO_NULL: 未定义对象 
CASE_NOT_FOUND: CASE 中若未包含相应的 WHEN ，并且没有设置 ELSE 时 
COLLECTION_IS_NULL: 集合元素未初始化 
CURSER_ALREADY_OPEN: 游标已经打开 
INVALID_NUMBER: 内嵌的 SQL 语句不能将字符转换为数字 
**NO_DATA_FOUND: 使用 select into 未返回行，或应用索引表未初始化的元素时** 
SUBSCRIPT_BEYOND_COUNT:元素下标超过嵌套表或 VARRAY 的最大值 
SUBSCRIPT_OUTSIDE_LIMIT: 使用嵌套表或 VARRAY 时，将下标指定为负数  
VALUE_ERROR: 赋值时，变量长度不足以容纳实际数据 
LOGIN_DENIED: PL/SQL 应用程序连接到 oracle 数据库时，提供了不正确的用户名或密码 
NOT_LOGGED_ON: PL/SQL 应用程序在没有连接 oralce 数据库的情况下访问数据 
PROGRAM_ERROR: PL/SQL 内部问题，可能需要重装数据字典＆ pl./SQL 系统包 
ROWTYPE_MISMATCH: 宿主游标变量与 PL/SQL 游标变量的返回类型不兼容 
SELF_IS_NULL: 使用对象类型时，在 null 对象上调用对象方法 
STORAGE_ERROR: 运行 PL/SQL 时，超出内存空间 
SYS_INVALID_ID: 无效的 ROWID 字符串 
TIMEOUT_ON_RESOURCE: Oracle 在等待资源时超时 

others可以代表所有异常，oracle预定义的异常在20000以内。

#### 4.2.oracle中异常：在运行程序时出现的错误叫做异常

当发生异常后，语句将停止执行，控制权转移动PL/SQL块的异常处理部分

#### 4.3.Oracle异常的三种分类：

##### 4.3.1.预定义异常：当PL/SQL程序违反Oracle规则或超越系统限制时隐式引发;用户不需要在程序中定义

##### 4.3.2.非预定义异常:  当PL/SQL程序违反Oracle规则或超越系统限制时  隐式  引发;用户需要在程序中定义

   语法：

 第一步：定义异常

<异常情况>  EXCEPTION;

 第二步：将定义好的异常情况与标准的oracle错误联系起来,使用EXCEPTION_INIT语句

PRAGMA EXCEPTION_INIT(<异常情况>,<错误代码>);

第三步：有EXCEPTION语句中处理异常

例：

```
--删除部门时先删除员工
declare
    v_deptno dept_bak.deptno%type:=&deptno;
    dept_error exception; --定义一个非预定性异常
    pragma exception_init(dept_error,-2292);  --将错误代码与指定异常关联
begin  
   delete from emp_bak where deptno=v_deptno;--先删除员工
   delete from dept_bak where deptno=v_deptno;--再删除部门
   commit;
 exception 
   when dept_error then
     dbms_output.put_line('违返外键约束异常');
     rollback;--回滚事务
   when others then
     dbms_output.put_line('其它异常');  
end;
```

##### 4.3.3.用户定义异常:  需要用户在程序中定义，显示地在程序中将其引发

a1.第一步：在PL/SQL中定义异常情况

​      异常变量  exception;

a2.RAISE <异常情况>;

a3.在PL/SQL的EXCEPTION 部分处理异常

如下例子：

```
--更新的记录找不到的自定义异常
declare
  v_empno emp_bak.empno%type:=&empno;
  v_ename emp_bak.ename%type:=&aa;
  no_result_error exception; --自定义异常类型
begin
     update emp_bak set ename=v_ename where empno=v_empno;    
     if SQL%ROWCOUNT<>1 then  --不等于1时 
        raise no_result_error;  ----显性引发异常
     end if;
     commit;
   exception 
       when no_result_error then
         dbms_output.put_line('没有找到要更新的记录');
         rollback;
       when others then
         dbms_output.put_line('其它异常');     
end;
    
```

## 5.游标

### 5.1.为什么使用游标？

   因为程序只能接收单个变量或一条记录，不能接收结果集，
   如何将结果集中的数据通过程接收呢？此时就需要游标，通过游标
   逐条读取结果集中的数据

### 5.2.什么是游标？

 游标是系统为用户开设的一个数据缓存区，用来存放执行后的结果
 每个游标区都有一个名字，用户可以通过游标逐一获得记录

### 5.3.游标的分类:静态游标和动态游标

​    1.3.1.静态游标分为：隐式游标和显示游标

​       隐式游标:pl/sql执行的DML(即增，删，改，查等操作)时自动创
                        建隐式游标，自动声明，打开和关闭

​      显示游标：用来处理返回多行的查询

​    1.3.2.动态游标分为：强类型和弱类型

​      强类型：必须指定游标变量的返回值类型

​      弱类型：定义时不指定游标变量的返回值类型

动态游标和静态游标的区别：

  a1.静态游标是在声明时就已知游标绑定的sql查询;而动态游标在运行时(open 时)才绑定sql查询

 a2.静态游标只能表示指定sql查询的结果，而动态可以多次指定不同sql查询的结果

 a3.动态游标要先定义游标类型，再定义游标变量，绑定sql,而静态声明时一次绑定sql,语法不同

### 5.4.游标的使用

#### 隐式游标：

```
  --用户输入学号，查询指定学生的学号，姓名，性别
  declare
       v_stuno student.stuno%type:=&stuno;
       v_stu student%rowtype;
  begin
        select * into v_stu from student where stuno=v_stuno;       
        dbms_output.put_line(v_stu.stuno||v_stu.stuname||v_stu.sex);
  end;
```

游标的属性：

 %FOUND     – SQL 语句影响了一行或多行时为 TRUE

%NOTFOUND     – SQL 语句没有影响任何行时为TRUE

%ROWCOUNT     – SQL 语句影响的行数

%ISOPEN      - 游标是否打开，始终为FALSE

#### 显示游标的使有以下操作:

   a1. 声明游标
   a2.打开游标
   a3.提取游标
   a4.关闭游标

```
 --查询所有的学生信息
  declare
       v_stu student%rowtype;
       --声明一个显示静态游标
       cursor cursor_stu is  select * from student; --声明一个游标
  begin
      open cursor_stu; --打开游标
      loop--开始循环
         fetch cursor_stu into v_stu; --提取游标数据
         dbms_output.put_line(v_stu.stuno||v_stu.stuname);
         exit when cursor_stu%NOTFOUND;--退出游标
     end loop;--结束循坏
     close cursor_stu;--关闭游标
    end; 
```

#### 动态游标：

```
 --动态游标
 declare
    --定义一个动态游标类型
     type emp_cursor_type is ref cursor;
     --定义一个游标变量
     c1 emp_cursor_type;
     v_emp emp_bak%rowtype;
     v_dept dept_bak%rowtype;
 begin
      --查询部门编号为20的员工
      open c1 for select * from emp_bak where deptno=20;
      loop
         fetch c1 into v_emp ;
         dbms_output.put_line('编号：'||v_emp.empno||'名字'||v_emp.ename);
         exit when c1%NOTFOUND; 
       end loop; 
       --查询所有部门信息
       open c1 for select * from dept_bak;
       loop 
          fetch c1 into v_dept;
          dbms_output.put_line('部门编号：'||v_dept.deptno||'部门'||v_dept.dname||
                                '位置：'||v_dept.loc);
          exit when c1%NOTFOUND;
         end loop;
         close c1;--关闭游标
  end;
```

## 6.存储过程

定义：存储过程 procedure 是命名的完成特殊功能的 pl/sql 块，编译并存储在数据库中；

用户通过指定存储过程的名字并给出参数（如果该存储过程带有参数）来执行它。存储过程是数据库中的一个重要对象，任何一个设计良好的数据库应用程序都应该用到存储过程。

1、提高性能

SQL 语句在创建过程时进行分析和编译。 存储过程是预编译的，在首次运行一个存储过程时，查询优化器对其进行分析、优化，并给出最终被存在系统表中的存储计划，这样，在执行过程时便可节省此开销。

2、降低网络开销

存储过程调用时只需用提供存储过程名和必要的参数信息，从而可降低网络的流量。

3、便于进行代码移植

数据库专业人员可以随时对存储过程进行修改，但对应用程序源代码却毫无影响，从而极大的提高了程序的可移
植性。

4、更强的安全性

1）系统管理员可以对执行的某一个存储过程进行权限限制，避免非授权用户对数据的访问
2）在通过网络调用过程时，只有对执行过程的调用是可见的。 因此，恶意用户无法看到表和数据库对象名称、
嵌入自己的 Transact-SQL 语句或搜索关键数据。
3）使用过程参数有助于避免 SQL 注入攻击。 因为参数输入被视作文字值而非可执行代码，所以，攻击者将命令
插入过程内的 Transact-SQL 语句并损害安全性将更为困难。
4）可以对过程进行加密，这有助于对源代码进行模糊处理。
劣势：
1、存储过程需要专门的数据库开发人员进行维护，但实际情况是，往往由程序开发员人员兼职
2、设计逻辑变更，修改存储过程没有 SQL 灵活

存储过程与 SQL 语句如何选择

1、在一些高效率或者规范性要求比较高的项目，建议采用存储过程
2、对于一般项目建议采用参数化命令方式，是存储过程与 SQL 语句一种折中的方式

3、对于一些算法要求比较高，涉及多条数据逻辑，建议采用存储过程

####   6.1.创建存储过程语法：

```
CREATE [OR REPLACE] PROCEDURE <procedurename> [(<parameter list>)]
IS|AS
  <LOCAL variable declaration>
BEGIN
  <executeable statements>
  [EXCEPTION
  <Exception handlers>
  ]
END;
```

- OR  PERLACE:  可选，如果没有or  perlace语句，则仅仅是新建一个存储过程，如果系统存在这个存储过程，则会报错，如果包含or  perlace语句，则表示如果系统没有就新建，如果有就用现在的替换掉原来的存储过程，不会报错。
- Procedure_name:  存储过程的名称
- Parameter_list:  参数列表，可选
- Local_declarations: 局部声明，可选（--is部分即为声明部分,不需再用declare）
- Exectable_statements: 可执行语句, 逻辑代码,
- Exception_handlers:  异常处理程序，可选

#### 6.2 存储过程传递参数的三种模式

•in ： 用于接受调用程序的值(默认的参数模式)

•out : 用于向调用程序返回值 

•in out 用于接受调用程序的值，并向调用程序返回更新的值

例子：

```
create or replace procedure 存储过程名（param1 in type，param2 out type）
as
  变量 1 类型（值范围）;
  变量 2 类型（值范围）;
Begin
  Select count(*) into 变量 1 from 表 A where 列名=param1；
  If (判断条件) then
     Select 列名 into 变量 2 from 表 A where 列名=param1；
     Dbms_output。Put_line(‘打印信息’);
  Elsif (判断条件) then
     Dbms_output。Put_line(‘打印信息’);
  Else
     Raise 异常名（NO_DATA_FOUND）;
  End if;
Exception
  When others then
  Rollback;
End;

```

#### 6.3 创建和调用存储过程：

```
--使用存储过程增加部门
create or replace procedure pro_addDept(
   v_dname varchar2,--输入参数，部门名
   v_loc varchar2 --输入参数，位置 
 )
is
begin   
   insert into dept_bak values (dept_bak_seq.nextval,v_dname,v_loc);
   commit;
end;
```

```
--pl/sql执行存储过程
begin
  pro_addDept('开发部','开发部办公室');
end;
```

```
 --增加异常处理
create or replace procedure pro_addDept(
   v_deptno number,--输入参数
   v_dname varchar2,--输入参数，部门名
   v_loc varchar2 --输入参数，位置   
 )
 is
   deptno_isnull exception;
   pragma exception_init(deptno_isnull,-1400);--违返非空异常
   dname_notUQ  exception;
   pragma exception_init(dname_notUQ,-1); --非预定异常，违反唯一约束
 begin   
   insert into dept_bak values (v_deptno,v_dname,v_loc);
   commit;
 exception 
   when deptno_isnull then
     dbms_output.put_line('部门编号不能为空');
   when dname_notUQ then
     dbms_output.put_line('部门名称不能重复');
   when others then
     dbms_output.put_line('未知异常');
 end; 
```

```
 ----根据查询学号员工信息,用存储过程来实现 ，结果是一行多列，
 create or replace procedure pro_getEmpByNo(
    v_empno number, --输入参数,注意是逗号隔开参数
    v_emp out emp_bak%rowtype --输出参数
  )
 is
 begin
      select * into v_emp from emp_bak where empno=v_empno;
 end;
```

```
----调用存储过程：
 declare
     v_emp emp_bak%rowtype;
 begin
     pro_getEmpByNo(7788,v_emp);
     dbms_output.put_line(v_emp.empno||' '||v_emp.ename||' '||v_emp.sal);
 end;
```

```
--存储过程执行查询，如果是  多行多列  的结果，  需要用游标
--查询编号为20的员工信息
create or replace procedure pro_getEmpByDeptno(
    v_deptno in out number,
    cursor_emp out sys_refcursor
)
is
begin
     open cursor_emp for select * from emp_bak where deptno=v_deptno;   
end; 

```

```
--执行存储过程
declare
     v_deptno emp_bak.deptno%type:=&deptno;
     v_emp emp_bak%rowtype;
     cursor_emp  sys_refcursor;
begin
     pro_getEmpByDeptno(v_deptno,cursor_emp);
     loop
       fetch cursor_emp into v_emp;
       exit when cursor_emp%NOTFOUND;
       dbms_output.put_line(v_deptno||' '||v_emp.empno||' '||v_emp.ename||' '||v_emp.sal);       
     end loop;
     close cursor_emp;
end;
```

```
 ---------根据员工编号查询,输出员工编号,员工部门,员工姓名,员工薪水--------   用结构体 ---
create or replace procedure getSalByEmpno2(
    v_empno in out number ,
    v_emp_cursor out sys_refcursor
)
is
begin 
     open v_emp_cursor for select empno,ename,dname,sal 
     from emp_bak e inner join dept_bak d on e.deptno=d.deptno where empno=v_empno;
exception
     when no_data_found then 
         dbms_output.put_line('该员工不存在!');
end;
```

```
----------调用存储过程------
declare 
    v_empno emp_bak.empno%type :='&emptno';
    v_emp_cursor sys_refcursor;
    type v_emp_record is record(  --------定义一个结构体 类型
         v_empno number(5,0),
         v_ename varchar2(30),
         v_dname varchar2(30),
         v_sal number(5,0)
     );
    v_emp_re  v_emp_record;  -------定义一个结构体变量
begin
    getSalByEmpno2(v_empno,v_emp_cursor);
    loop
      fetch v_emp_cursor into v_emp_re ; 
      exit when v_emp_cursor%notfound;
      dbms_output.put_line('员工编号:'||v_emp_re.v_empno||'  姓名: '||v_emp_re.v_ename||  
                              '部门:'||v_emp_re.v_dname||'  工资: '||v_emp_re.v_sal);
    end loop ;
    close v_emp_cursor;--关闭游标 
end;
```

#### 6.4. 如何将过程的执行权限授予其他用户

```
SQL> GRANT EXECUTE ON find_emp TO MARTIN;
SQL> GRANT EXECUTE ON swap TO PUBLIC;
```

#### 6.5 .删除存储过程

语法：

```
DROP PROCEDURE procedure_name;
```
