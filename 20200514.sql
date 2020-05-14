�����ȹ : SQL�� ���������� � ������ ���ļ� �������� ������ �ۼ�
            * ����ϴµ� ��� ���� ����� �ʿ�(�ð�)
            
2���� ���̺��� �����ϴ� SQL
2���� ���̺� ���� �ε����� 5���� �ִٸ�
������ �����ȹ ���� �?? ���̺��� �þ���� ����� �� ������ ������ ==> ª�� �ð��ȿ� �س��� �Ѵ�(������ ���� �ؾ��ϹǷ�)

���� ������ SQL�� ����� ��� ������ �ۼ��� �����ȹ�� �����Ұ��
���Ӱ� ������ �ʰ� ��Ȱ���� �Ѵ�(���ҽ� ����)

���̺� ���� ��� : ���̺� ��ü(1), ������ �ε���(5)
a => b
b => a
����� �� : 36�� * 2 = 72��

select *
from emp;

������ SQL �̶� : SQL ������ ��ҹ��� ������� ��ġ�ϴ� SQL
�Ʒ� �ΰ��� sql�� ���� �ٸ� SQL�� �ν��Ѵ�
SELECT * FROM emp;
select * FROM emp;

Ư�������� ������ ��ȸ�ϰ� ������ : ����� �̿��ؼ�
select /* 202004_B */ *
FROM emp
WHERE empno = :empno;

--�ý��� �������� ����� ������ ��ȸ
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%202004_B%';
------------------------------------------------------------------------------------------------------------------------
--hr ����
select *
from YOON.v_emp;

YOON.v_emp ==> v_emp

synonym : ��ü�� ��Ī�� �����ؼ� ��Ī�� ���� ���� ��ü�� ���(���Ǿ�)
���� : create synonym �ó�� �̸� for ��� ������Ʈ;

YOON.v_emp ==> v_emp �ó������ ����

create synonym v_emp for YOON.v_emp;

v_emp�� ���� ���� ��ü�� YOON.v_emp�� ����� �� �ִ�

select *
from v_emp;
------------------------------------------------------------------------------------------------------------------------
SQL ī�װ�
DML
DDL
DCL
TCL

Data Dictionary : �ý��� ������ �� �� �ִ� view, ����Ŭ�� ��ü������ ����
category(���ξ�)
USER : �ش� ����ڰ� �����ϰ� �ִ� ��ü ���
ALL : �ش� ����� ���� + ������ �ο����� ��ü ���
DBA : ��� ��ü���
V$ : ����, �ý��� ����

select *
from user_tables;

select *
from ALL_tables;

select *
from DBA_tables; --�ý��� �������� �� �� ����

select *
from dictionary;
-------------------------------------------------------------------------------------------------------------------
Multiple insert : �������� �����͸� ���ÿ� �Է��ϴ� insert�� Ȯ�屸��

1. unconditional insert : ������ ���� ���� ���̺� �Է��ϴ� ��� --���� ���x
���� : 
    INSERT ALL
        INTO ���̺��
        [,INTO ���̺��]
    VALUES (...) | SELECT QUERY;

emp_test���̺��� �̿��Ͽ� emp_test2 ���̺� ����
create table emp_test2 as
select *
from emp_test
where 1 = 2; --������ ����x

empno, ename, deptno

emp_test, emp_test2 ���̺� ���ÿ� �Է�
insert all
    into emp_test
    into emp_test2
select 9998, 'brown', 88 from dual 
union all
select 9997, 'brown', 88 from dual; 

select *
from emp_test;

select *
from emp_test2;

2. conditional insert : ���ǿ� ���� �Է��� ���̺��� ����

insert all
    when ����....then 
        into �Է� ���̺� values
    when ����....then 
        into �Է� ���̺�2 values
    else
        inro �Է� ���̺�3 values
    
select ����� ���� ���� empno = 9998�̸� emp_test���� �����͸� �Է�
                                        �� �ܿ��� emp_test2�� �����͸� �Է�
insert all
    when empno = 9998 then
        into emp_test values (empno, ename, deptno)
    else
        into emp_test2 (empno, deptno) values (empno, deptno)
select 9998 empno, 'brown' ename, 88 deptno from dual 
union all
select 9997, 'cony', 88 from dual;

rollback;

conditional insert (all) ==> first : ������ �����ϴ� ù��° when���� ����
insert first
    when empno <= 9998 then
        into emp_test values (empno, ename, deptno)
    when empno <= 9997 then
        into emp_test2 values (empno, ename, deptno)
select 9998 empno, 'brown' ename, 88 deptno from dual 
union all
select 9997, 'cony', 88 from dual;
----------------------------------------------------------------------------------------------------------------
MERGE : �ϳ��� ������ ���� �ٸ� ���̺�� �����͸� �ű� �Է�, �Ǵ� ������Ʈ �ϴ� ����
���� : 
meger into ���� ���(emp_test)
using (�ٸ� ���̺� | view | subquery)
on (�������� using ���� ���� ���� ���)
when not matched then
    insert (�÷�1, �÷�2...) values (value1, value2...)
when matched then
    update set �÷�1 = value1, �÷�2 = value12,

1. �ٸ� �����ͷ� ���� Ư�� ���̺�� �����͸� ���� �ϴ� ���
2.  key�� ������� insert
    key�� ���� �� update

emp���̺��� �����͸� emp_test ���̺�� ����
emp���̺��� �����ϰ� emp_test���̺��� �������� �ʴ� ������ �ű��Է�
emp���̺��� �����ϰ� emp_test���̺��� �����ϴ� ������ �̸� ����

insert into emp_test values (7369, 'cony', 88); 

select *
from emp_test;

���� �� ������ �ִ� ������
9999	brown	88
9998	brown	88
9997	cony	88
7369	cony	88

emp���̺��� 14���� �����͸� emp_test���̺� ������ empno�� �����ϴ��� �˻��ؼ�
������ empno�� ������ insert-empno, ename, ������ empno�� ������ update-ename
merge into emp_test
using emp
on (emp_test.empno = emp.empno)
when not matched then
    insert (empno,ename) values (emp.empno, emp.ename)
when matched then
    update set ename = emp.ename;

���� �� ������ �ִ� ������
9999	brown	88
9998	brown	88
9997	cony	88
7369	SMITH	88    --update
7499	ALLEN	null
7521	WARD	null
7566	JONES	null
7654	MARTIN	null
7698	BLAKE	null
7782	CLARK	null
7788	SCOTT	null
7839	KING	null
7844	TURNER	null
7876	ADAMS	null
7900	JAMES	null
7902	FORD	null
7934	MILLER	null

���� �ó������� �ϳ��� ���̺��� �ٸ� ���̺�� �����ϴ� ���

9999�� ������� �ű� �Է��ϰų�, ������Ʈ�� �ϰ� ���� ��
(����ڰ� 9999��, james ����� ����ϰų�, ������Ʈ �ϰ���� ��)
���� ���� ���̺� ==> �ٸ� ���̺�� ����
�����͸� ==> Ʋ�� ���̺�� ����

�̹��� �ϴ� �ó����� : �����͸� ==> Ư�� ���̺�� ����
(9999, james)

merge ������ ������� ������

������ ���� ������ ���� select ����
select *
from emp_test
where empno=9999;

�����Ͱ� ������ => update
�����Ͱ� ������ => insert

merge into emp_test
using dual                      --dual���̺��� �־��ذ��� ������ ���� �־���ϴµ� �������� ��� �׳� �־��ذ���
    on (emp_test.empno = 9999)
when not matched then
    insert (empno, ename) values (9999, 'james')
when matched then
    update set ename = 'james';
    
select *
from emp_test;

merge into emp_test
using (Select 9999 eno, 'james' enm
        from dual) a                     --���� �������� �̺κ� ����
    on (emp_test.empno = a.eno)
when not matched then
    insert (empno, ename) values (9999, 'james')
when matched then
    update set ename = 'james';
------------------------------------------------------------------------------------------------------------------------
report group function

emp���̺��� �̿��Ͽ� �μ���ȣ�� ������ �޿� �հ�, ��ü������ �޿����� ��ȸ�ϱ� ����
group by�� ����ϴ� �ΰ��� SQL�� ������ �ϳ��� ��ġ��(union all) �۾��� ���� --union���� union all�� ���°� �´�
--union ����
select deptno, sum(sal)
from emp
group by deptno

union all

select null, sum(sal)
from emp;

--group by rollup ����
select deptno, sum(sal)
from emp
group by rollup (deptno);


Ȯ��� group by 3����
1. group by rollup
���� : group by rollup (�÷�, �÷�2...)
���� : ����׷��� ������ִ� �뵵
����׷� ���� ��� : rollup ���� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭 ����׷��� ����
������ ����׷��� union�� ����� ��ȯ

select job, deptno, sum(sal)  as sal
from emp
group by rollup (job, deptno);

����׷� : 1.group by job,deptno
            union
          2.group by job
            union
          3.��ü�� group by

select job, deptno, sum(sal)  as sal
from emp
group by job, deptno

union all

select job, null, sum(sal)  as sal
from emp
group by job

union all

select null, null, sum(sal)  as sal
from emp;

����׷��� ������ : rollup���� ����� �÷� ���� +1;

