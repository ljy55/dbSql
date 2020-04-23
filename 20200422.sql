--fn3
�־����� : ����� ����ִ� ���ڿ� '201912' ==> 31
���ڿ�     ==>        ��¥ ==>   ������ ��¥�� ���� ==>   ����
/*SELECT to_char(to_date('201912','yyyymm'),'yyyymm') as param,
        to_char(last_day() as dt
FROM dual;

select sysdate, to_char(last_day(sysdate),'dd')
from dual;*/

select  to_date('201912','yyyymm') as param,
        to_char(last_day(to_date('201912','yyyymm')),'dd') as dt
from dual;

select to_date(:yyyymm, 'yyyymm'), 
        to_date(:yyyymm,'yyyymm') as param,
        to_char(last_day(to_date(:yyyymm,'yyyymm')),'dd')
from dual;
---------------------------------------------------------------------
--1-1��
explain plan for
select *
from emp
where empno = '7369';
      ("EMPNO"=7369)--7369�� ���ڿ��� ���ڷ� ����ȯ ��

select *
from table(dbms_xplan.display);

--������ ������
Plan hash value: 3956160932
�����ȹ�� ���� ����(id)
* �鿩���� �Ǿ������� �ڽ� ���۷��̼�
1. ������ �Ʒ��� �д´�
    *�� �ڽ� ���۷��̼��� ������ �ڽ� ���� �д´�
    id-> 1�� �а�->* ǥ�� : 1���� ���� ������ �� ���� �׷� �װ� ������ ���� -> 0�� �а�
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 | --�ڽ�(����� ����)
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)--���ڷ� ���ߴ�
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
------------------------------------------------------------------------
--1-2��
explain plan for
select *
from emp
where to_char(empno) = '7369';

select *
from table(dbms_xplan.display);

--������ ������
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')--���ڷ� ���ߴ�
 
Note
-----
   - dynamic sampling used for this statement (level=2)

---------------------------------------------------------------------------------
explain plan for
select*
from emp
where empno = 7300 + '69';

select *
from table(dbms_xplan.display);

--������ ������
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)--���ڷ� ���ߴ�
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-------------------------------------------------------------------
sql �������� ĥ������ : ���� �˻�
------------------------------------------------------------------
select *
from emp, dept;
------------------------------------------------------------------
����ȭ : i18n
-----------------------------------------------------------------
select ename, sal, to_char(sal, 'L009,000.00')
from emp;
-----------------------------------------------------------------
�� null ó���� �ؾ��ұ�?
null�� ���� �������� null�̴�

������ emp���̺� �����ϴ� sal, comm �ΰ��� �÷� ���� ���� ���� �˰� �; ������ ���� sql�� �ۼ�
select empno, ename, sal, comm, sal + comm as sal_plus_com
from emp;

NVl(expr1, expr2)
expr1�� null�̸� expr2���� �����ϰ�
expr1�� null�� �ƴϸ� expr1�� ����

select empno, ename, sal, comm, sal + nvl(comm, 0) as sal_plus_com
from emp;

reg_dt �÷��� null�� ��� ���� ��¥�� ���� ���� ������ ���ڷ� ǥ��
select userid, usernm, reg_dt, nvl(reg_dt,last_day(sysdate)) as reg_dt_plus
from users;