�θ�-�ڽ� ���̺� ����

1. ���̺� ������ ����
 1]�θ�(dept)
 2]�ڽ�(emp)

2.������ ������(insert) ����
 1]�θ�(dept)
 2]�ڽ�(emp)

3.������ ������(delete) ����
 1]�ڽ�(emp)
 2]�θ�(dept)
----------------------------------------------------------------------------
���̺� �����(���̺��� �̹� �����Ǿ� �ִ� ���) �������� �߰� ����

drop table emp_test;

create table emp_test(
    empno number(4),
    ename varchar2(10),
    deptno number(2)
);

���̺� ������ ���������� Ư���� �������� ����

���̺� ������ ���� primary key �߰�

���� : alter table ���̺�� add constraint �������Ǹ� �������� Ÿ�� (������ �÷�[,]);
�������� Ÿ�� : primary key, unique, foreign key, check

alter table emp_test add constraint pk_emp_test primary key (empno);

--primary key�� ���� ����? �ߺ��� �����Ϸ���!

���̺� ����� �������� ����
���� : alter table ���̺� �̸� drop constraint �������Ǹ�;

������ �߰��� �������� pk_emp_test ����
alter table emp_test drop constraint pk_emp_test;
-------------------------------------------------------------------------------------------------------------
���̺� �������� �ܷ�Ű �������� �߰� �ǽ�
emp_test.deptno ====> dept_test.deptno

dept_tes���̺��� deptno�� �ε��� ���� �Ǿ��ִ��� Ȯ��

alter table ���̺�� add constraint �������Ǹ� ��������Ÿ�� (�÷�) references �������̺�� (�������̺� �÷���)

alter table emp_test add constraint fk_emp_test_dept_test foreign key (deptno) references dept_test (deptno);

������ ����;
----------------------------------------------------------------------------------------------------------------
�������� Ȱ��ȭ ��Ȱ��ȭ
���̺� ������ ���������� ���� �ϴ� ���� �ƴ϶� ��� ����� ����, �Ѵ� ����
���� : alter table ���̺�� enable | disable constraint �������Ǹ�;

������ ������ fk_emp_test_dept_test foreign key ���������� ��Ȱ��ȭ

alter table emp_test disable constraint fk_emp_test_dept_test;

dept(�θ�)���̺��� 99�� �μ��� �����ϴ� ��Ȳ
select *
from dept_test;

fk_emp_test_dept_test ���������� ��Ȱ��ȭ�Ǿ� �ֱ� ������ emp_test ���̺��� 99�� �̿��� ���� �Է� ������ ��Ȳ

dept_test ���̺� 88�� �μ��� ������ �Ʒ� ������ ���������� ����
insert into emp_test values (9999,'brown',88);

���� ��Ȳ : emp_test ���̺� dept_test ���̺� �������� �ʴ� 88�� �μ��� ����ϰ� �ִ� ��Ȳ
            fk_emp_test_dept_test ���������� ��Ȱ��ȭ�� ����
            
�������� ���Ἲ�� ���� ���¿��� fk_emp_test_dept_test�� Ȱ��ȭ��Ű��??
==> ������ ���Ἲ�� ��ų �� �����Ƿ� Ȱ��ȭ �� �� ����

alter table emp_test enable constraint fk_emp_test_dept_test; --����
-----------------------------------------------------------------------------------------------------------
emp,dept ���̺��� ���� primary key, foreign key ������ �ɷ� ���� ���� ��Ȳ
emp ���̺��� empno�� key��
dept���̺��� deptno�� key�� �ϴ� primary key ������ �߰��ϰ�

emp.deptno ==> dept.deptno�� �����ϵ��� foreign key�� �߰�

�������� ���� �����ð��� �ȳ��� ������� ���

emp pk, dept pk, emp.deptno ==> dept.deptno fk

alter table emp add constraint pk_emp primary key (empno); 
alter table dept add constraint pk_dept primary key (deptno);
alter table emp add constraint fk_emp_dept foreign key (deptno) references dept (deptno);
-----------------------------------------------------------------------------------------------------------
�������� Ȯ��
1.������ �������ִ� �޴�(���̺� ����==>�������� tab)
2.user_constraints : �������� ����(master);
3.user_cons_columns : �������� �÷� ����(����);

select *
from user_constraints;

select *
from user_cons_columns;

�÷�Ȯ��
1.��
2.select *
3.desc
4.user_tab_columns(data dictionary, ����Ŭ���� ���������� �����ϴ� view);

select *
from user_tab_columns
where table_name = 'emp';

select 'select * from ' || table_name || ';'
from user_tables;
--------------------------------------------------------------------------------------------------------------
�ּ�
/**/
select * /*�׽�Ʈ*/
from emp;

���̺�,�÷� �ּ� : user_tab_comments, user_col_comments;

���� ���񽺼� ���Ǵ� ���̺��� ���� ���ʰ��� ������ �ʴ� ��찡 ����
���̺��� : ī�װ� + �Ϸù�ȣ

select *
from user_tab_comments;

���̺��� �ּ� �����ϱ�
���� : comment on table ���̺�� is '�ּ�';

emp���̺� �ּ� �����ϱ�
comment on table emp is '����';

�÷� �ּ� Ȯ��
select *
from user_col_comments
where table_name = 'EMP'; --���̺�� �빮�ڷ� �ؾ���..���� �ҹ����ϸ� �ƹ��͵� �ȶ�

�÷� �ּ� ����
comment on column ���̺��.�÷��� is '�ּ�';

empno : ���, ename : �̸�, hiredate : �Ի����� ���� �� user_col_comments�� ���� Ȯ��
comment on column emp.empno is '���';
comment on column emp.ename is '�̸�';
comment on column emp.hiredate is '�Ի�����';

--�ּ��� �����սô�!

--comments �ǽ�1
select *
from user_col_comments
where table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select *
from user_tab_comments
where table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select tab.TABLE_NAME, tab.TABLE_TYPE, tab.COMMENTS as tab_comment, col.COLUMN_NAME, col.COMMENTS as col_comment
from user_tab_comments tab, user_col_comments col
where tab.table_name = col.table_name
    and tab.table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select tab.*, col.COLUMN_NAME, col.COMMENTS
from user_tab_comments tab, user_col_comments col
where tab.table_name = col.table_name
    and tab.table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');
-------------------------------------------------------------------------------------------------------------
View�� ������
������ ������ ���� = SQL
�������� ������ ������ �ƴϴ�

view ��� �뵵
- ������ ����(���ʿ��� �÷� ������ ����)
- ���� ����ϴ� ������ ���� ����
    IN LINE VIEW �� ����ص� ������ ����� ����� �� �� ������
    MAIN ������ ������� ������ �ִ�

view�� �����ϱ� ���ؼ��� create view ������ ���� �־�� �Ѵ�(DBA����)

system ������ ����
grant create view to ����������� �ο��� ������;

���� : create [or replace] view ���̸� [�÷���Ī1, �÷���Ī2...] as
        select ����;

emp���̺��� sal, comm �÷��� ������ 6���� �÷��� ��ȸ�� ������ v_emp view�� ����

create or replace view v_emp as
select empno, ename, job, mgr, hiredate, deptno
from emp;

view (v_emp)�� ���� ������ ��ȸ
select *
from v_emp;

v_emp view�� YOON���� ����
HR�������� �λ� �ý��� ������ ���ؼ� EMP���̺��� �ƴ� SAL,COMM��ȸ�� ���ѵ�
v_emp view�� ��ȸ�� �� �ֵ��� ������ �ο�

[hr�������� ����]���Ѻο��� hr �������� v_emp�� ��ȸ
select *
from YOON.v_emp;

[YOON�������� ����]YOON�������� hr�������� v_emp view�� ��ȸ�� �� �ִ� ���� �ο�
grant select on v_emp to hr;

[hr�������� ����]V_emp view ������ hr �������� �ο��� ���� ��ȸ �׽�Ʈ
select *
from YOON.v_emp;

select *
from YOON.emp; --�� ������ ����. ���� �������ϱ�...����

--�ǽ�
v_emp_dept �並 ����
emp, dept ���̺��� deptno�÷����� �����ϰ�
emp.empno, ename, dept.deptno, dname 4���� �÷����� ����

create or replace view v_emp_dept as
select emp.empno, ename, dept.deptno, dname
from emp, dept
where emp.deptno = dept.deptno;

--in line view
select *
from
   ( select emp.empno, ename, dept.deptno, dname
    from emp, dept
    where emp.deptno = dept.deptno);

--view
select *
from v_emp_dept;

view ����
���� : drop view ������ �� �̸�;

drop view v_emp;

�ζ��κ� ==> ��ȸ��
�� ==> ���� ���� ����
------------------------------------------------------------------------------------------------------------
view�� ���� DML ó��
simple view�� ���� ����

simple view : ���ε��� �ʰ�, �Լ�, group by, rownum�� ������� ���� ������ ������ view
complex view : simple view�� �ƴ� ����

v_emp : simple view

select *
from v_emp;

v_emp�� ���� 7369 SMITH ����� �̸��� brown���� ����
update v_emp set ename = 'brown'
where empno = 7369;

select *
from emp;

v_emp �÷����� sal �÷��� �������� �ʱ� ������ ����
update v_emp set sal =1000
where empno = 7369;

rollback;
-----------------------------------------------------------------------------------------------------------
SEQUENCE
������ �������� �������ִ� ����Ŭ ��ü
���� �ĺ��� ���� ������ �� �ַ� ���

�ĺ��� ==> �ش� ���� �����ϰ� ������ �� �ִ� ��
���� <==> ���� �ĺ���
���� : ���� �׷��� ��
���� : �ٸ糽 ��

�Ϲ������� � ���̺�(����Ƽ)�� �ĺ��ڸ� ���ϴ� �����
[����],[����],[������]

�Խ����� �Խñ� : �Խñ� �ۼ��ڰ� ���� ����� �ۼ� �ߴ���
�Խñ��� �ĺ��� : �ۼ���id, �ۼ�����, ������
        ==>���� �ĺ��ڰ� �ʹ� �����ϱ� ������ ������ ���̼��� ���� 
            ���� �ĺ��ڸ� ��ü�� �� �ִ�(�ߺ����� �ʴ�) ���� �ĺ��ڸ� ���

������ �ϴٺ��� ������ ���� �����ؾ��Ҷ��� ����
ex : ���, �й�, �Խñ� ��ȣ
    ���, �й� : ü��
    ��� : 15101001 - ȸ�� �������� 15, 10�� 10��, �ش� ��¥�� ù��° �Ի��� ��� 01
    �й� : 
-- ü�谡 �ִ� ���� �ڵ�ȭ�Ǳ� ���ٴ� ����� ���� Ÿ�� ��찡 ����
    
    �Խñ� ��ȣ : ü�谡 ��..., ��ġ�� �ʴ� ����
/* ü�谡 ���� ���� �ڵ�ȭ�� ���� ==> SEQUENCE ��ü�� Ȱ���Ͽ� �ս��� ���� ����
                                  ==>�ߺ����� �ʴ� ���� ���� ��ȯ */

�ߺ����� �ʴ� ���� �����ϴ� ���
1. key table�� ����
    ==> select for update �ٸ� ����� ���ÿ� ������� ���ϵ��� ���°� ����
    ==> ���� ���� ���� ��, ������ ���� �Ƹ���� �����ϴ°� ����(SEQUENCE������ �Ұ���)

2.JAVA�� UUID Ŭ������ Ȱ��, ������ ���̺귯�� Ȱ��(����) ==> ������, ����, ī��
    ==> jsp �Խ��� ����

3.ORACLE DB - SEQUENCE

SEQUENCE ����
���� : create sequence ��������;

seq_emp��� �������� ����
create sequence seq_emp;
CREATE SEQUENCE  "YOON"."SEQ_EMP"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE ;

���� : ��ü���� �������ִ� �Լ��� ���ؼ� ���� �޾ƿ´�
NEXTVAL : �������� ���� ���ο� ���� �޾ƿ´�
CURRVAL : ������ ��ü�� NEXTVAL�� ���� ���� ���� �ٽ� Ȯ���� �� ���
         (Ʈ����ǿ���  NEXTVAL �����ϰ� ���� ����� ����);

select seq_emp.NEXTVAL
from dual;

select seq_emp.CURRVAL
from dual;

select *
from emp_test;

SEQUENCE�� ���� �ߺ����� �ʴ� empno�� ���� �Ͽ� insert �ϱ�
�Ʒ� ������ ������ ����
insert into emp_test values (seq_emp.NEXTVAL, 'sally', 88);