--创建一个触发器，如果emp发生delete，update操作时，把操作之前的数据备份到备份表中
create or replace  trigger  tri_emp_update_delete
before  update or delete  on emp 
for each row 
when (old.deptno =30 and old.job ='SALESMAN')begin外面的old不用打冒号
begin
    --把操作之前的记录保存到备份表中
    insert into emp_bak
    values
      (:old.empno,
       :old.ename,
       :old.job,
       :old.mgr,
       :old.hiredate,
       :old.sal,
       :old.comm,
       :old.deptno);

end;

--测试
insert into emp (empno,ename) values(1000,'test');

update emp  set sal =1000 where deptno =30;

delete from emp where empno =7698;

select * from emp_bak;


--语句级触发器
--对emp表执行insert，update，delete 操作时，把操作信息记录到日志表中
create table emp_log
(
     logid  varchar2(32),
     loguser  varchar2(30),
     logtype  varchar2(30),
     createDate  date
);


create or replace trigger  tri_dml
before  insert or update or delete on emp
begin
       --判断执行的是什么操作
       if(inserting)then
          insert into emp_log values(sys_guid(),user,'执行insert操作',sysdate);
       elsif(updating) then
          insert into emp_log values(sys_guid(),user,'执行update操作',sysdate);    
       elsif(deleting) then
          insert into emp_log values(sys_guid(),user,'执行delete操作',sysdate); 
       end if;                         

end;


--测试触发器
--insert:
       insert into emp (empno,ename) values(9999,'皮炎平');

--delete 
       delete from  emp   where empno in(9999,1000,1001,1002);       
--update
       update emp set comm =nvl(comm,0) +100 where empno=7499 ;       
       
select * from emp_log;

--通过字典表查询触发器
select *from user_triggers;



--更改触发器的状态
alter trigger  tri_emp_update_delete   disable;--禁用

alter trigger tri_emp_update_delete    enable; --启用
