--����һ�������������emp����delete��update����ʱ���Ѳ���֮ǰ�����ݱ��ݵ����ݱ���
create or replace  trigger  tri_emp_update_delete
before  update or delete  on emp 
for each row 
when (old.deptno =30 and old.job ='SALESMAN')begin�����old���ô�ð��
begin
    --�Ѳ���֮ǰ�ļ�¼���浽���ݱ���
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

--����
insert into emp (empno,ename) values(1000,'test');

update emp  set sal =1000 where deptno =30;

delete from emp where empno =7698;

select * from emp_bak;


--��伶������
--��emp��ִ��insert��update��delete ����ʱ���Ѳ�����Ϣ��¼����־����
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
       --�ж�ִ�е���ʲô����
       if(inserting)then
          insert into emp_log values(sys_guid(),user,'ִ��insert����',sysdate);
       elsif(updating) then
          insert into emp_log values(sys_guid(),user,'ִ��update����',sysdate);    
       elsif(deleting) then
          insert into emp_log values(sys_guid(),user,'ִ��delete����',sysdate); 
       end if;                         

end;


--���Դ�����
--insert:
       insert into emp (empno,ename) values(9999,'Ƥ��ƽ');

--delete 
       delete from  emp   where empno in(9999,1000,1001,1002);       
--update
       update emp set comm =nvl(comm,0) +100 where empno=7499 ;       
       
select * from emp_log;

--ͨ���ֵ���ѯ������
select *from user_triggers;



--���Ĵ�������״̬
alter trigger  tri_emp_update_delete   disable;--����

alter trigger tri_emp_update_delete    enable; --����
