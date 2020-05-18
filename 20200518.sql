����׷� ���� ���
rollup : �ڿ���(�����ʿ���) �ϳ��� �������鼭 ����׷��� ����
cube : ������ ��� ����
grouping sets : �����ڰ� ����׷� ������ ���� ���
---------------------------------------------------------------------------------------------------
--sub_a2
drop table dept_test;


create table dept_test as
select *
from dept;

insert into dept_test values (99, 'it1', 'daejeon');
insert into dept_test values (98, 'it2', 'daejeon');

delete dept_test 
where not exists (select 'X'
                 from emp
                 where emp.deptno = dept_test.deptno);

rollback;
-------------------------------------------------------------------------------------------------------------
--sub_a3
select *
from emp_test,
(select deptno, avg(sal)
from emp_test e
group by deptno)a
where emp_test.deptno = a.deptno;

update emp_test set sal = sal + 200
where sal < (select avg(sal)
            from emp_test a
            where emp_test.deptno = a.deptno
            group by deptno);
----------------------------------------------------------------------------------------------------------------            
���Ŀ��� �ƴ�����, �˻�-������ ���� ������ ǥ��
���������� ���� ���
1. Ȯ���� : ��ȣ���� ��������(exists)
            ==> ������������ ���� ==> �������� ����
2. ������ : ���������� ���� ����Ǽ� ���������� ���� �������ִ� ����
13�� : �Ŵ����� �����ϴ� ������ ��ȸ
select *
from emp
where mgr in (select empno
              from emp);
-----------------------------------------------------------------------------------------------------------------
�μ��� ��ձ޿�(�Ҽ��� ��°�ڸ�����)
select deptno, round(avg(sal),2)
from emp
group by deptno;

��ü �޿� ���
select round(avg(sal),2)
from emp;

�μ��� �޿������ ��ü �޿���պ��� ū �μ��� �μ���ȣ, �μ��� �޿���� ���ϱ�
select deptno, round(avg(sal),2)
from emp
group by deptno
having round(avg(sal),2) > (select round(avg(sal),2)
                           from emp);


with �� : SQL���� �ݺ������� ������ QUERY BLOCK(SUBQUERY)�� ������ �����Ͽ�
          SQL ����� �ѹ��� �޸𸮿� �ε��� �ϰ� �ݺ������� ����� �� �޸� ������ �����͸�
          Ȱ���Ͽ� �ӵ� ������ �� �� �ִ� KEYWORD
          ��, �ϳ��� SQL���� �ݺ����� SQL ����� ���´� ���� �߸� �ۼ��� SQL�� ���ɼ��� ���� ������
          �ٸ� ���·� ������ �� �ִ����� ���� �غ��� ���� ��õ.
with emp_avg_sal as
(
select round(avg(sal),2)
from emp
)
select deptno, round(avg(sal),2), (select * from emp_avg_sal)
from emp
group by deptno
having round(avg(sal),2) > (select *
                           from emp_avg_sal);
--------------------------------------------------------------------------------------------------------------
��������
connect by level : ���� �ݺ��ϰ� ���� ����ŭ ������ ���ִ� ���
��ġ : from(where)�� ������ ���
DUAL ���̺�� ���� ���

���̺� ���� �Ѱ�, �޸𸮿��� ����
select level
from dual
connect by level <= 5;

���� ���� ���� �̹� ��� keyword�� �̿��Ͽ� �ۼ� ����
5�� �̻��� �����ϴ� ���̺��� ���� ���� ����
���࿡ �츮�� ������ �����Ͱ� 10,000���̸��� 10,000�ǵ� ���� DISK I/O�� �߻�
select rownum
from emp
where rownum <=5;

1. �츮���� �־��� ���ڿ� ��� : 202005
    �־��� ����� �ϼ��� ���Ͽ� �ϼ��� ���� ����

select to_date('202005','yyyymm'),level,
        to_date('202005','yyyymm') + (level -1) dt
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

select to_date('202005','yyyymm') + (level -1) dt
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

�޷��� �÷��� 7�� - �÷��� ������ ���� : Ư�� ���ڴ� �ϳ��� ���Ͽ� ����
select to_date('202005','yyyymm') + (level -1) dt,
        �Ͽ����̸� dt�÷�, �������̸� dt�÷�, ȭ�����̸� dt�÷�....������̸� dt�÷�
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

�Ʒ� ������� SQL�� �ۼ��ص� ������ �ϼ��ϴ°� �����ϳ�
������ ���鿡�� �ʹ� �����Ͽ� �ζ��κ並 �̿��Ͽ� ������ �� �� �ܼ��ϰ� �����
select to_date('202005','yyyymm') + (level -1) dt,
        decode(to_char(to_date('202005','yyyymm') + (level -1), 'd'),1,to_date('202005','yyyymm') + (level -1)) sun,
        decode(to_char(to_date('202005','yyyymm') + (level -1), 'd'),2,to_date('202005','yyyymm') + (level -1)) mon
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

�÷��� ����ȭ�Ͽ� ǥ��
to_date('202005','yyyymm') + (level -1) ==> dt
select dt, d(dt�� �������̸� dt, dt�� ȭ�����̸� dt....1���� �÷��߿� �� �ϳ��� �÷����� dt ���� ǥ�� �ȴ�)
from
(select to_date('202005','yyyymm') + (level -1) dt, 
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
----
select dt, decode(d,1,dt) sun, decode(d,2,dt) mon, decode(d,3,dt) tue,
           decode(d,4,dt) wed, decode(d,5,dt) thu, decode(d,6,dt) fri, decode(d,7,dt) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
---
select dt, iw, 
           decode(d,1,dt) sun, decode(d,2,dt) mon, decode(d,3,dt) tue,
           decode(d,4,dt) wed, decode(d,5,dt) thu, decode(d,6,dt) fri, decode(d,7,dt) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
---
select decode(d,1,iw+1,iw), 
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);
---
select  
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);
---
select  decode(d, 1, iw+1, iw),
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date(:yyyymm,'yyyymm') + (level -1) dt,
        to_char(to_date(:yyyymm,'yyyymm') + (level -1), 'd') d,
        to_char(to_date(:yyyymm,'yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date(:yyyymm,'yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);

