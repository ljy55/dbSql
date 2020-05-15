rollup : ����׷� ���� - ����� �÷��� �����ʿ������� ���������� group by�� ����

�Ʒ� ������ ���� �׷�
1. group by job, deptno
2. group by job
3. group by ==> ��ü

select grouping(job) as job, 
        grouping(deptno) as deptno, 
        sum(sal) as sal
from emp
group by rollup (job, deptno);

--group_ad2
select decode(grouping(job),1,'�Ѱ�',0,job) as job, 
        decode(grouping(deptno),0,deptno) as deptno, 
        sum(sal) as sal
from emp
group by rollup (job, deptno);


--group_ad2-1
select decode(grouping(job),1,'��',0,job) as job, 
        decode(grouping(deptno) + grouping(job), 1, '�Ұ�', 2, '��', to_char(deptno)), 
        sum(sal) as sal 
from emp
group by rollup (job, deptno);

select case 
        when grouping(job) = 1 then '��'
        else job
        end job,
        case
        when grouping(deptno) = 1 and grouping(job) = 1 then '��'
        when grouping(deptno) = 1 then '�Ұ�' 
        else to_char(deptno)
        end deptno,
        sum(sal) as sal
from emp
group by rollup (job, deptno);

--group_ad3
select deptno, job, sum(sal)
from emp
group by rollup (deptno,job);

rollup���� ��� �Ǵ� �÷��� ������ ��ȸ ����� ������ ��ģ��
****���� �׷��� ����� �÷��� ������ ���� ������ �����鼭 ����

--group_ad4
select dept.dname, emp.job, sum(emp.sal)
from emp, dept 
where emp.deptno = dept.deptno
group by rollup (dept.dname, emp.job);

select dept.dname, a.job, a.sum_sal
from 
(select deptno, job, sum(sal) as sum_sal
from emp
group by rollup (deptno,job)) a, dept
where a.deptno = dept.deptno(+);

--group_ad5
select nvl(dept.dname, '�Ѱ�') dname, emp.job, sum(emp.sal)
from emp, dept 
where emp.deptno = dept.deptno
group by rollup (dept.dname, emp.job);
-------------------------------------------------------------------------------------------------------------------
2.grouping sets
rollup�� ���� :  ���ɾ��� ����׷쵵 ���� �ؾ� �Ѵ�
                rollup���� ����� �÷��� �����ʿ��� ���������� ������
                ���� �߰������� �ִ� ����׷��� ���ʿ� �� ��� ����
grouping sets : �����ڰ� ���� ������ ����׷��� ���
                rollup���� �ٸ��� ���⼺�� ����
���� : group by grouping sets (col1, col2....)
group by col1
union all
group by col2

select job, deptno, sum(sal)
from emp
group by grouping sets (job, deptno);

select job, deptno, sum(sal)
from emp
group by job
union all
select job, deptno, sum(sal)
from emp
group by deptno;

�׷������
1. job, deptno
2. mgr

group by grouping sets ( (job,deptno), mgr )

select job, deptno, mgr, sum(sal) 
from emp
group by grouping sets ( (job,deptno), mgr );

select job, deptno, null, sum(sal) 
from emp
group by grouping sets (job,deptno)
union all
select null, null, mgr, sum(sal) 
from emp
group by mgr;
------------------------------------------------------------------------------------------------------
report group function ==> Ȯ��� group by
report group function�� ����� ���ϸ�
�������� SQL�� �ۼ�, union all�� ���ؼ� �ϳ��� ����� ��ġ�� ����

==> �� �� ���ϰ� �ϴ°� report group function
----------------------------------------------------------------------------------------------------------
3. CUBE
���� : group by cube (col1, col2...)
����� �÷��� ������ ��� ���� (������ ��Ų��)

group by cube (job, deptno);
  1           2         
job         deptno      
job         X
X           deptno
X           X

group by cube (job, deptno, mgr);
  1           2         3
job         deptno      mgr
job         deptno      x
job         x           mgr    
job         x           x
x           deptno      mgr
x           x           mgr
x           deptno      x
x           x           x    ==> ��ü

select job, deptno, sum(sal)
from emp
group by cube (job, deptno);
----------------------------------------------------------------------------------------------------------
�������� report group ����ϱ�
select job, deptno, mgr, sum(sal)
from emp
group by job, rollup(deptno), cube(mgr);

**�߻� ������ ������ ���
1       2           3
job     deptno      mgr ==>group by job, deptno, mgr
job     deptno      x  ==>group by job, deptno
job     x           mgr ==>group by job, mgr
job     x           x   ==>group by job

select job, deptno, mgr, sum(sal+nvl(comm,0))sal
from emp
group by job, rollup(job,deptno), cube(mgr);
----------------------------------------------------------------------------------------------------------------
��ȣ���� �������� ������Ʈ
1. emp���̺��� �̿��Ͽ� emp_test ���̺� ����
    ==> ������ ������ emp_test ���̺� ���� ���� ����
        drop table emp_test;
    ==> ���̺� ����
        create table emp_test as
        select *
        from emp;

2. emp_test ���̺� dname �÷� �߰� (dept ���̺� ����)
desc dept;
alter table emp_test add (dname VARCHAR2(14));

3. subquery�� �̿��Ͽ� emp_test ���̺� �߰��� dname �÷��� ������Ʈ ���ִ� ���� �ۼ�
emp_test�� dname �÷��� ���� dept ���̺��� dname �÷����� update
emp_test���̺��� deptno���� Ȯ���ؼ� dept���̺��� deptno���̶� ��ġ�ϴ� dname �÷����� ������ update

emp_test���̺��� dname �÷��� dept ���̺��̿��ؼ� dname�� ��ȸ�Ͽ� ������Ʈ
update ����� �Ǵ� �� : 14 ==> where ���� ������� ����

��� ������ ������� dname�÷��� dept ���̺��� ��ȸ�Ͽ� ������Ʈ
update emp_test set dname = (select dname
                            from dept
                            where emp_test.deptno = dept.deptno);

--�ǽ� sub_a1
1.���̺� ����
drop table dept_test;

create table dept_test as
select *
from dept;

2. dept_test ���̺� empcnt(number) �÷� �߰�
alter table dept_test add (empcnt NUMBER(2));

3. �������� �̿��Ͽ� �ش� �μ��� ���� ������Ʈ
update dept_test set empcnt = (select count(*) 
                                from emp
                                where dept_test.deptno = emp.deptno); --�� ���������� ���ȣ��������

update dept_test set empcnt = (select count(*) 
                                from emp
                                where dept_test.deptno = emp.deptno
                                group by deptno); --���� ������ �ٸ� ���� null���� ����

select *
from dept_test;

select deptno, count(*)
from emp
group by deptno;
---------------------------------------------------------------------------------------------------------
select ��� ��ü�� ������� �׷� �Լ��� ������ ���
���Ǵ� ���� ������ 0���� ����

select count(*)
from emp
where 1 = 2;

group by ���� ����� ��� ����� �Ǵ� ���� ������� ��ȸ�Ǵ� ���� ����(null-���� �������� �ʾҴ�)
select count(*)
from emp
where 1 = 2
group by deptno;
