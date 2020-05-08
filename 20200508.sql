���� ����
1. PRIMARY KEY
2. UNIQUE
3.FOREIGN KEY
4. CHECK
    -NOT NULL
5. NOT NULL
    CHECK ���� ���������� ���� ����ϱ� ������ ������ KEWORD�� ����
    
NOT NULL ��������
:�÷��� ���� NULL�� ������ ���� �����ϴ� ���� ����

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14) not null,
	loc varchar2(13)
);

dname �÷��� ������ not null �������ǿ� ���� �Ʒ� insert ������ �����Ѵ�
insert into dept_test values (99, null, 'daejeon');

���ڿ��� ��� ''�� null�� �ν��Ѵ�
�Ʒ��� insert ������ ����(test)
insert into dept_test values (99, '', 'daejeon');
---------------------------------------------------------------------------------------------------------
unique ����
�ش��÷��� ������ ���� �ߺ����� �ʵ��� ����
���̺��� ������� �ش� �÷��� ���� �ߺ����� �ʰ� �����ؾ���
ex : ���� ���̺��� ��� �÷�, �л� ���̺��� �й� �÷�

DROP TABLE dept_test;

select *
form dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14) unique,
	loc varchar2(13)
);

dept_test ���̺��� dname �÷��� unique ������ �ֱ� ������ ������ ���� �� �� ����
insert into dept_test values (99, 'ddit', 'daejeon');
insert into dept_test values (98, 'ddit', '����');

DROP TABLE dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14),
	loc varchar2(13),
    
    --constraint �������Ǹ� ��������Ÿ�� (�÷�,...)
      constraint u_dept_test unique (dname, loc)
);

dname�÷��� loc�÷��� ���ÿ� ������ ���̾�߸� �ߺ����� �ν�
�ؿ� �ΰ��� ������ ������ �ߺ��� �ƴϹǷ� ���� ����
insert into dept_test values (99,'ddit','deajeon');
insert into dept_test values (98,'ddit','����');

�Ʒ� ������ unique ���� ���ǿ� ���� �Էµ��� �ʴ´�
insert into dept_test values (97,'ddit','����');

select *
from dept_test;
---------------------------------------------------------------------------------------------------
foreign key ��������
�Է��ϰ��� �ϴ� �����Ͱ� �����ϴ� ���̺� ������ ���� �Է� ���
ex : emp ���̺� �����͸� �Է��� �� deptno �÷��� ���� dept ���̺� �����ϴ� deptno ���̾�� �Է� ����

������ �Է½�(emp) �����ϴ� ���̺�(dept)�� ������ ���� ������ ������ �˱� ���ؼ� 
�����ϴ� ���̺�(dept)�� �÷�(deptno)�� �ε����� �ݵ�� ���� �Ǿ� �־�߸�
foreign key ���������� �߰� �� �� �ִ�

unique ���������� ������ ��� �ش� �÷��� �� �ߺ� üũ�� ������ �ϱ� ���ؼ�
����Ŭ������ �ش� �÷��� �ε����� ���� ��� �ڵ����� �����Ѵ�

primary key �������� : unique ���� + not null
primary key �������Ǹ� �����ص� �ش� �÷����� �ε����� ���� ���ش�

foreign key ���������� �����ϴ� ���̺��� �ֱ� ������ �ΰ��� ���̺� �����Ѵ�

DROP TABLE dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0) primary key,
	dname varchar2(14),
	loc varchar2(13)
);

insert into dept_test values (99,'ddit','deajeon');
commit;

select *
from dept_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0) references dept_test (deptno)
);

���� �μ� ���̺��� 99�� �μ��� ����
foreign key �������ǿ� ���� emp ���̺��� deptno �÷����� 99�� �̿��� �μ���ȣ�� �Էµ� �� ����

99�� �μ��� ���� �ϹǷ� ���������� �Է� ����
insert into emp_test values (9999, 'brown', 99);

98�� �μ��� ���� ���� �����Ƿ� ���������� �Է��� �� ����
insert into emp_test values (9998, 'sally', 98);
-------------------------------------------------------------------------------------------------------
foreign key �������� ���̺� �������� ���

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0), 
    
    --constraint �������Ǹ� ��������Ÿ�� �÷� references �����ϴ� ���̺�(�÷�)
    constraint fk_emp_test_dept_test foreign key (deptno) references dept_test (deptno)
);

rollback;

--�ε���  : �˻� �� �� �ӵ������ �� �� �ְ� �ϴ� ��..����(�ӵ� ���� �����ϰ� ��)
------------------------------------------------------------------------------------------------------
�ܷ�Ű�� ������ ����

select *
from dept_test;

select *
from emp_test;

(9999, 'brown', 99) ==> (99, 'ddit', 'daejeon');
emp_test.deptno ==> dept_test.deptno ���� ��

dept_test ���̺��� 99�� �μ��� �����͸� ����� ��� �ɱ�?
(9999, 'brown', 99) ==> 

�θ� ���ڵ�(dept_test.deptno)�� �����ϰ� �ִ� �ڽ� ���ڵ�(emp_test.deptno)�� �����ϱ� ������ 
�ڽ� ���ڵ� ���忡���� ������ ���Ἲ�� ������ �Ǿ� ���������� ���� �� �� ����
delete dept_test
where deptno = 99;
-----------------------------------------------------------------------------------------------------------------
����Ű�� ���õ� �����͸� ������ �ο��� �� �ִ� �ɼ�

�θ� �����͸� ������..
foreign key �ɼǿ� ���� �ڽ� �����͸� ó���� �� �ִ� �ɼ�
1. defualt ==> �����ϰ� �ִ� �θ� ���� �� �� ����
2. on delete cascade ==> �θ� �����Ǹ� �����ϰ� �ִ� �ڽ� �����͵� ���� ����
3. on delete set null ==> �θ� �����Ǹ� �����ϰ� �ִ� �ڽ� �����͸� null�� ����

�� �ְ��� �ǰ� : default �� �´�..����
1.�����ڰ� ���̺��� ������ ��Ȯ�ϰ� �˰� �־������ ���� ������ �� ����
    ==>����ų�, �Է� �� �������� ������ �˰� �־�� ��
2.���̺� ������ ��Ȯ���� ������ �ű� �����ڴ� �ش� ������ �� ���� ����
    (java �ڵ� + ���̺� ���� Ȯ�� �ʿ�)
    java�ڵ忡�� dept���̺� �����ϴ� �ڵ尡 �ִµ�
    �ű��ϰԵ� emp���̺��� �����Ͱ� �����ǰų� null�� �����Ǵ� ��츦 �� �� ����
-------------------------------------------------------------------------------------------------------------------
check �������� : �÷��� ���� �����ϴ� ���� ����

emp ���̺��� �޿�����(sal)�� ���� �Ҷ� sal �÷��� ���� 0���� ���� ���� ���� ���� ���������� �̻���
sal �÷��� ���� ������ ���� �ʵ��� üũ ���� ������ �̿��Ͽ� ���� �� �� �ִ�

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    sal number(7, 2) check (sal > 0),
    deptno number(2, 0) references dept_test (deptno)
);

�Ʒ� ������ ���� ����
insert into emp_test values (9999, 'brown', 1000, 99);
�Ʒ� ������ sal �÷��� ������ check ��������(sal > 0 �� ���� ���������� ������� �ʴ´�)
insert into emp_test values (9998, 'sally', -1000, 99);

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    sal number(7, 2),
    deptno number(2, 0) references dept_test (deptno),
    --���̺� ���� sal üũ �������� ��� �� �׽�Ʈ
    --constraint �������Ǹ� ��������Ÿ�� �÷�
     constraint sal_check check (sal > 0) 
);
-----------------------------------------------------------------------------------------------
CTAS : create table as
select ����� �̿��Ͽ� ���̺��� �����ϴ� ���
not null �������� ������ �ٸ� ���������� ������� �ʴ´�
�뵵
    1. ������ ������ ���
    2. ������ ������ �׽�Ʈ
    
����
create table ���̺�� ([�÷���,...]) as
    select ����;

dept_test ���̺��� ���� ==> dept_test_copy
create table dept_test_copy as
select *
from dept_test;

������ ���� ���̺��� ���� �ϰ� ���� ��
create table dept_test_copy2 as
select *
from dept_test
where 1 != 1;

select *
from dept_test_copy2;

���� �˻� ����� ����
�䱸���� : ���� �̸����� �˻� or ��ü �˻� or �޿� �˻�..+���� �˻�

���� �̸� �˻�
select *
from emp
where ename like '%' || �˻� Ű���� || '%';

��ü �˻�
select *
from emp;

�޿� �˻�
select *
from emp
where sal > �˻���

--JAVA + SQL
/*String sql = " select * ";
       sql += " from emp ";
       sql += " where 1 = 1"; 
if(����ڰ� �޿��˻��� ��û �ߴٸ�){
    sql += " and sal > " + ����ڰ� �Է��� �˻���;
}
if(����ڰ� �޿��˻��� ��û �ߴٸ�){
    sql += " and ename like '%' || " + ����ڰ� �Է��� �˻��� + " '%' ";
}*/

table ����
���ݱ��� ������ table ������ ����
�̹� ������ ���̺��� ���� �� ���� ����
    1. ���ο� �÷��� �߰�
       ******���ο� �÷��� ���̺��� ������ �÷����� �߰��� �ȴ�
       ******���� �����Ǿ� �ִ� �÷� �߰����� ���ο� �÷��� �߰��� ���� ����
            ===> ���� ���̺��� �����ϰ� �÷������� ������ ���ο� ���̺� ���� DDL�� ���Ӱ� ������ ��
                 ����̶�� �̹� �����Ͱ� �׿����� ���ɼ��� ������ ����
                 ==> ���̺��� ������ �� �����ϰ� �÷� ������ ���
    2. ���� �÷� ����, �÷� �̸� ����, �÷� ������ ����, (Ÿ�Ե� ���������� ���� ����)
        ����Ű�� �ɷ��ִ� ���̺��� �÷� �̸��� �����ϴ��� �����ϴ� ���̺��� ������ ���� ����(�˾Ƽ� �̸��� ���� ���ش�)
        emp_test.deptno ==> dept_test.deptno ����
        dept_test.deptno �̸������Ͽ� dept_test.dno�� �����ϴ��� fk(foreign key)�� ����� �̸����� �� ������ �ȴ�
    3. ���� �����߰�


���� ���̺� ���ο� �÷� �߰�
alter table ���̺�� add (�÷���, �÷�Ÿ��);

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0) references dept_test (deptno)
);

desc emp_test;
---------------
emp_test ���̺��� hp �÷�(varchar2(20)�� �űԷ� �߰�

--alter table ���̺�� add (�÷���, �÷�Ÿ��);
alter table emp_test add (hp varchar2(20));
---------------
�÷� ������, Ÿ�� ����
alter table ���̺�� modify (�÷��� �÷�Ÿ��)

������ �߰��� hp �÷��� �÷� ����� 20���� 30���� ����-->����� �ø��°� ���� �־ ����. ��Ҵ� �Ұ���
alter table emp_test modify (hp varchar2(30));

������ �߰��� hp �÷��� Ÿ���� varchar2(30)���� date�� ����-->hp �÷��� ���� ��� ��������. ���� ������ ����ȵ�
alter table emp_test modify (hp date);

�����Ͱ� �����ϴ� �÷��� ���ؼ��� Ÿ�� ������ �Ұ��� �ϴ�
insert into emp_test values (9999, 'brown', 99, sysdate);
alter table emp_test modify (hp varchar2(30));
-----------------
�÷� �̸� ����
alter table ���̺�� rename column �����÷��� to �ű��÷���;

������ �߰��� emp_test ���̺��� hp �÷��� hp_n���� �̸� ����
alter table emp_test rename column hp to hp_n;
-----------------
�÷� ����
alter table ���̺�� drop (������ �÷���)
alter table ���̺�� drop column ������ �÷���

������ �߰��� emp_test ���̺� hp_n �÷��� ����;
alter table emp_test drop (hp_n);
alter table emp_test drop column hp_n
---------------------------------------------------------------------------------------

SQL ����
DML : SELECT, INSERT, UPDATE, DELETE ==> Ʈ����� ���� ����(��� ����)
DDL : CREATE...., ALTER......==> Ʈ����� ���� �Ұ���(��Ұ� �ȵȴ�) / �ڵ� Ŀ��(���� ������ ������ DML���嵵 �� Ŀ�Ե�..����)

���� ename�� brown ==> sally�� ����
update emp_test set ename = 'sally'
where empno = 9999;

select *
from emp_test;

�ѹ� �Ǵ� Ŀ���� ����

alter table emp_test add (hp number);
 desc emp_test;
 
 rollback;
 
 select *
 from emp_test;
 
 DDL�� �ڵ� Ŀ���̱� ������ DML ���忡�� ������ �޴´�
 DDL�� ���� �� ��� ���Ǳ�� ������ �ߴ� �۾��� ���� �� �ʿ䰡 �ִ�
 SQLD ���� �ܰ� ����