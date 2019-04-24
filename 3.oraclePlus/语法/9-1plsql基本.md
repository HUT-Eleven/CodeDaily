--根据员工编号7788查询出员工薪资，根据薪资进行加福利操作

```
declare
    --声明变量
    (三种方式：1.自己定义类型和长度，但必须和接受的类型一致。2.type字段类型，3.rowtype行级类型)
--方式一：
   /*v_empno number(4);
    v_ename varchar2(10);
    v_sal number(7,2); */
--方式二：
   /* v_empno emp.empno%type;
    v_ename emp.ename%type;
    v_sal emp.sal%type;  */
--方式三：
	v_emp  emp%rowtype;
begin
    --根据员工编号查询出员工信息
    select * into v_emp from emp where empno =7788;
--打印员工信息
dbms_output.put_line('员工编号：'|| v_emp.empno || '员工姓名：'|| v_emp.ename || '薪资：'|| v_emp.sal);

--根据员工薪资给员工加福利
if(v_emp.sal between 1000 and 2000) then 
        --给员工加200福利
        update emp set comm =nvl(comm,0)+200 where empno =v_emp.empno ; 
elsif(v_emp.sal between 2000 and 3000) then
       --给员工加300福利
        update emp set comm =nvl(comm,0)+300 where empno =v_emp.empno ;      
else 
        null;--null 是可执行的语句，但是不会做任何事；
end if;
end; 
```



--pl/sql 循环
declare
         

```
     --声明变量
     v_count  number :=1;
```

begin
         goto mygoto ;   --表示无条件的跳转到对应的标记位置；

```
     --loop循环
     loop
         --循环退出条件
        exit  when v_count >10 ;
        
        --打印循环的次数
        dbms_output.put_line('loop 循环次数：'|| v_count ); 
        
        --让v_count+1；
        v_count:=v_count+1;     
     
     end loop;
     
     --while 循环
     
     while(v_count <=20) loop
        
          --打印循环的次数
         dbms_output.put_line('while 循环次数：'|| v_count ); 

           --让v_count+1；
        v_count:=v_count+1;     
        
     end loop;
     
     --标签分隔符
     <<myGoto>> --定义标记名
     
     --for  in  循环
     for v_i  in  1..10 loop
         
          --打印循环的次数
         dbms_output.put_line('for in  循环次数：'|| v_i ); 
     
     end loop;
```

end;

--异常处理:
--1.预定义错误：
declare
         

```
     v_empno emp.empno%type;
     v_ename emp.ename%type;
```

begin
         --根据员工编号查询员工信息
         --select empno ,ename  into v_empno ,v_ename from emp where empno =8888;
         

```
     --根据员工姓名查找员工信息
     select empno,ename into v_empno,v_ename from emp where ename='SCOTT';
     
     dbms_output.put_line('员工编号：'|| v_empno || '员工姓名：'|| v_ename);

     --异常处理
     exception
         when  no_data_found   then dbms_output.put_line('该员工不存在');
         when too_many_rows then dbms_output.put_line('员工信息重复');                           
```

end;

--非预定义错误
declare
        --声明异常变量
        e_deptno_error exception;
        pragma  exception_init(e_deptno_error,-02291);     

begin
           --修改7788 所在部门编号
           update emp set deptno =50 where empno =7788; 
           

```
    --异常处理
    exception
       when  e_deptno_error  then  dbms_output.put_line('修改的部门编号不存在');
```

end;

--自定义错误:

declare

```
       v_sal emp.sal%type;
       
       e_sal_error  exception;
```

begin
         --查询员工7499的薪资
         select sal into v_sal from emp where empno =7499;
         

```
     --判断员工薪资是否低于3000
     if(v_sal <3000) then 
              
           --抛出异常
          -- raise e_sal_error;   
          
          raise_application_error(-20000,'薪资错误');
     end if;
     
     --异常处理
     exception
         when e_sal_error  then  dbms_output.put_line('薪资异常');
         when others   then dbms_output.put_line('系统异常');
```

end;



select 
       empno,
       ename,
       job,
       sal,
       (
              case   
                  when  sal between 500 and 1000    then   '初级' 
                  when  sal between 1000 and  2000  then '中级'
                  when  sal between 2000 and  3000  then ' 高级'
               else 
                  'BOSS'
              end
       ) 级别
from emp;