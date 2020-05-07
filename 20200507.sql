select *
from ranger;

DDL : data definition language
�����͸� �����ϴ� ���
CREATE, DROP, ALTER 

************************************
SQL�� ���� �ڵ� Ŀ��(rollback �Ұ�) --drop�� �ѹ� �ȵ�..
************************************

name char(10);

name = 'test' ==> 'test      '

if("test          ".equals("test"){
    �̺κ��� ���� �ɱ�?
}

���̺� ����
���� : DROP TABLE ������ ���̺��;
ranger ���̺� ����

DROP TABLE ranger;

DDL�� ROLLBACK �Ұ�(�ڵ� COMMIT)

rollback;

select *
form ranger;

table ����
����
create table [������.] ���̺��(
    �÷���1 �÷�Ÿ�� default ������ �⺻��,
    �÷���2 �÷�Ÿ��,...
    
    �÷���3 �÷�Ÿ��
);

ranger ���̺��� ������ ���� �÷����� ����
ranger_no �÷��� number Ÿ������
ranger_name �÷��� varchar2(50) Ÿ������
reg_dt �÷��� date Ÿ������ (��,�⺻���� �Է´�� ������ ���� �ð�)

create table ranger(
    ranger_no number,
    ranger_name varchar2(50),
    reg_dt date default sysdate
);

�׾ƺ� ��Ͽ��� ���̺� Ȯ��

DDL�� rollback;

select *
from ranger;

ranger_no 1
ranger_nm 'brown'

insert into ranger (ranger_no,ranger_name) values (1,'brown');
reg_dt �÷��� ���� ���� �Է����� �ʾ����� ���̺� ������ ����
�⺻�� sysdate�� �Է��� �ȴ�;

desc emp;
-------------------------------------------------------------------------------------------------
check ��������
member ���̺� �����̶�� �÷��� ���� ��
���� �÷��� �� �� �ִ� �� : ����, ����, ����...�̷��� ������ �ɾ���
not null�� check�������� ���� �ɾ���...

�������� : �������� ���Ἲ�� ��Ű�� ���� ����
��4���� ���������� ����
    unique : ������ �÷��� ���� �ٸ� ���� ���� �ߺ����� �ʵ��� ����
             ex) ���, �й�
    primary key : unique ���� + not null check ����
                  ���� �����ؾ� �ϸ�, ���� �ݵ�� ���;� �ϴ� �÷�
                  ex) ���, �й�
    foreign key : �ش� �÷��� �����ϴ� ���̺��� ���� �����ϴ��� Ȯ���ϴ� ����
                  ex) emp���̺� �űԻ���� ��Ͻ� deptno ���� dept ���̺� �ݵ�� �����ϴ� ���� ����� �����ϴ�
    check  : �÷��� �ԷµǴ� ���� �����ڰ� ���� ������ ���� üũ, ���� �ϴ� ����
             ex) ���� �÷��� ���� F, M �ΰ��� ���� �� �� �ֵ��� ����

���������� �����ϴ� ���
1. ���̺� ������ �÷� �����ٰ� �ش� �÷��� ����� ���������� ���
    ==> �����÷� ������ �Ұ�
2. ���̺� ������ �÷� ����� ������ �ش� ���̺� ����� ���������� ���
    ==> �����÷� ���� ���� --���� ���� ���� ���
3. ���̺� ���� ����, ������ �������Ǹ� �ش� ���̺� ����
    ==> ���̺� ����, �����÷� ���� ����
    

1. ���̺� ������ �÷� ���� ���������� ���
desc dept;

�μ���ȣ�� �ߺ��� �Ǹ� �ȵǰ�, ���� ��� �־�� �ȵȴ�(�Ϲ�������)
==> dbms���� ���� ������ primary key ���������� �÷� ������ ����

drop table dept_test;

�������� �̸��� ������� ���� ��� ����Ŭ dbms�� �ڵ�����
�������� �̸��� �ٿ� �ش�
create table dept_test(
    deptno number(2) primary key,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
 
select *
from dept_test;

insert into dept_test values (99, 'ddit', 'daejeon')
�� ������ ���������� ����

insert into dept_test values (99, 'ddit2', 'daejeon')
�� ������ ù��° �������� �Է��� �μ���ȣ�� �ߺ� �Ǳ� ������ 
primary key(unique) �������ǿ� ����Ǿ� ���������� �����Ͱ� �Էµ��� �ʴ´�
 ==> �츮�� ������ ������ ���Ἲ�� ��������
-------------------------------------------------------------------------------------------------------- 
 drop table dept_test;

�������� �̸��� ����� ���� �ִ�
�ش� ������ �������� ��� ��Ģ�� ����� �Ѵ�
primary key : pk_���̺��
unique : u_���̺��
foreign key : fk_���̺��_�������̺��
not null, check : ������ �̸��� ������� �ʴ´�

create table dept_test(
    deptno number(2) constraint pk_dept_test primary key,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
-----------------------------------------------------------------------------------------------------------------
2. ���̺� ������ �÷� ����� ������ �ش� ���̺� ����� ���������� ���
drop table dept_test;

create table dept_test(
    deptno number(2), 
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    constraint pk_dept_test primary key (deptno, dname)
);
dept_test ���̺� deptno, dname���� primary key ���������� ����
�ΰ� �÷��� ��� ���ƾ����� �ߺ��Ǵ� ������ �ν�

insert into dept_test values (99,'ddit', 'daejeon');
insert into dept_test values (99,'ddit2', 'daejeon');

deptno, dname �÷��� ��� ���� ���� ����
insert into dept_test values (99,'ddit', 'daejeon');

select *
from dept_test;

