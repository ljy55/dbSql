explain plan for
select *
from emp
where empno = 7369;

select *
from table(dbms_xplan.display); -- �д� ���� 2->1->0

----------------------------------------------------------------------------------------------------------------
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
---------------------------------------------------------------------------------------------------------------------

ROWID : ���̺� ���� ����� �����ּ� (java - �ν��Ͻ� ����);

select rowid, emp.*
from emp;

����ڿ� ���� ROWID ��� --���ɴ� �Ⱦ�
explain plan for
select *
from emp
where rowid = 'AAAE5xAAFAAAAETAAF';

select *
from table(dbms_xplan.display);
--------------------------------------------------------------------------------------------------------------
Plan hash value: 1116584662
 
-----------------------------------------------------------------------------------
| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT           |      |     1 |    99 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY USER ROWID| EMP  |     1 |    99 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
--index �ǽ�
emp���̺� ���� ������ pk_emp primary key ���������� ����
alter table emp drop constraint pk_emp;

�ε��� ���� empno ���� �̿��Ͽ� ������ ��ȸ
explain plan for
select *
from emp
where empno = 7782; 

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
--------------------------------------------------------------------------------------------------------------------
2. emp ���̺� empno �÷����� primary key �������� ���� �� ���
    (empno �÷����� ������ unique �ε����� ����)
alter table emp add constraint pk_emp primary key (empno);
explain plan for
select *
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
--------------------------------------------------------------------------------------------------------------------
3. 2�� SQL�� ����(select �÷��� ����) 

2��
select *
from emp
where empno = 7782;

3��
explain plan for
select empno
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
-------------------------------------------------------------------------------------------------------------------
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |    13 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |    13 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
----------------------------------------------------------------------------------------------------------------------
4. empno�÷��� non-unique �ε����� �����Ǿ� �ִ� ���
alter table emp drop constraint pk_emp;
create index idx_emp_01 on emp (empno);

explain plan for
select *
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------------
Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
---------------------------------------------------------------------------------------------------------------------
5. emp ���̺��� job ���� ��ġ�ϴ� �����͸� ã�� ���� ��
���� �ε���(4������ �Ѱ�)
idx_emp_01 : empno

explain plan for
select *
from emp
where job = 'MANAGER';

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
------------------------------------------------------------------------------------------------------------------
idx_emp_01�� ��� ������ empno�÷� �������� �Ǿ� �ֱ� ������ job �÷��� �����ϴ�
SQL������ ȿ�������� ����� ���� ���� ������ table ��ü �����ϴ� ������ �����ȹ�� �ʿ�����

==>idx_emp_02(job) ������ �� �� �����ȹ ��
create index idx_emp_02 on emp (job);

explain plan for
select *
from emp
where job = 'MANAGER';

select *
from table(dbms_xplan.display);
-----------------------------------------------------------------------------------------------------------------
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-----------------------------------------------------------------------------------------------------------------------
6. emp ���̺��� job = 'MANAGER' �̸鼭 ename�� C�� �����ϴ� ����� ��ȸ(��ü�÷� ��ȸ)
�ε��� ��Ȳ
idx_emp_01 : empno
idx_emp_02 : job

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------------
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
----------------------------------------------------------------------------------------------------------------------
7. emp ���̺��� job = 'MANAGER' �̸鼭 ename�� C�� �����ϴ� ����� ��ȸ(��ü�÷� ��ȸ)
    ��, ���ο� �ε��� �߰� : idx_emp_03 : job, ename
create index idx_emp_03 on emp (job,ename);

�ε��� ��Ȳ
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_03 : job, ename

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
--------------------------------------------------------------------------------------------------------------------
8. emp ���̺��� job = 'MANAGER' �̸鼭 ename�� C�� ������ ����� ��ȸ(��ü�÷� ��ȸ)
    ��, ���ο� �ε��� �߰� : idx_emp_03 : job, ename

�ε��� ��Ȳ
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_03 : job, ename

explain plan for
select /*+ index( emp idx_emp_03 )*/ * ==> /* */ : ��Ʈ �ּ� - ���� �� ���������� ����
from emp
where job = 'MANAGER' and ename like '%C';

select *
from table(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
------------------------------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-----------------------------------------------------------------------------------------------------------------------
rule based optimizer : ��Ģ��� ����ȭ�� (9i ��������) ==> ���� ī�޶�
cost based optimizer : ����� ����ȭ�� (10g ��������) ==> �ڵ� ī�޶�
------------------------------------------------------------------------------------------------------------------------
9. ���� �÷� �ε����� �÷� ������ �߿伺
�ε��� ���� �÷� : (job, ename) VS (ename, job)
*** �����ؾ� �ϴ� sql�� ���� �ε��� �÷� ������ �����ؾ� �Ѵ�

���� sql : job=manager, ename�� C�� �����ϴ� ��� ������ ��ȸ(��ü �÷�)
���� �ε��� ���� : idx_emp_03;
drop index idx_emp_03;

�ε��� �ű� ����
idx_emp_04 : ename, job
create index idx_emp_04 on emp (ename, job);

�ε��� ��Ȳ
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_04 : ename, job

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
--------------------------------------------------------------------------------------------------------------
Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-------------------------------------------------------------------------------------------------------------------------
���ο����� �ε���

idx_emp_01 ����(pk_emp�� �ߺ�)
drop index idx_emp_01;

emp ���̺� empno �÷��� primary key�� �������� ����
pk_emp : empno
alter table emp add constraint pk_emp primary key (empno); 

�ε��� ��Ȳ
idx_emp_02 : job
idx_emp_04 : ename, job
pk_emp : empno

��� �������� Ư�� �������� ���� ���� 
explain plan for
select *
from emp, dept
where emp.deptno = dept.deptno
        and emp.empno = 7788;

select *
from table(dbms_xplan.display);

3-2-5-4-1-0
------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2385808155
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |   117 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |   117 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    87 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |   409 | 12270 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
-----------------------------------------------------------------------------------------------------------------------
nested loop join
hash join
sort merge join
