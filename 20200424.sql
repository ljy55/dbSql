<20200422~20200423 �� ����ؾ� �� 3���� ����>

1.nulló�� �ϴ� ��� (4�����߿� ���� ���Ѱɷ� �ϳ� �̻��� ���)
nvl, nvl2...

desc emp; --empno�� not null(empno���� null������ �ȵȴ�)

2. condition : case, decode

3.�����ȹ : �����ȹ�� ���� + ���� ����
----------------------------------------------------------------------------------------
select*
from emp
order by deptno;

emp ���̺� ��ϵ� �����鿡�� ���ʽ��� �߰������� ���� �� ����
�ش� ������ job�� salesman�� ��� sal���� 5% �λ�� �ݾ��� ���ʽ��� ����(ex:sal 100->105)
�ش� ������ job�� manager�̸鼭 deptno�� 10�̸� sal���� 30% �λ�� �ݾ��� ���ʽ��� ����
                              �� ���� �μ��� ���ϴ� ����� 10% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� president�� ��� sal���� 20% �λ�� �ݾ��� ���ʽ��� ����
�׿� �������� sal��ŭ�� ����

decode�� ���
/*select empno, ename, job, sal, deptno,
        DECODE(job,'SALESMAN',sal*1.05,
                    'MANAGER',decode(deptno,10,sal*1.3,sal*1.1),
                    'PRESIDENT',sal*1.2,
                    sal*1.1)
from emp;*/ --if�� �ߺ��ؼ� ����ϴ°� ������
--------------------------------------------------------------------------------------------------------
���� A = {10, 15, 18, 23, 24, 25, 29, 30, 35, 37}
�Ҽ� : �ڽŰ� 1�� ����� �ϴ� ��
prime Number �Ҽ� : {23, 29, 37} : count-3, max-37, min-23, avg-29.66, sum-89
��Ҽ� : {10, 15, 18, 24, 25, 30, 35}

group function
�������� �����͸� �̿��Ͽ� ���� �׷쳢�� ���� �����ϴ� �Լ�
�������� �Է¹�� �ϳ��� ������ ����� ���δ�
ex)�μ��� �޿� ���
    emp���̺��� 14���� ������ �ְ�, 14���� ������ 3���� �μ�(10,20,30)�� ���� �ִ�
    �μ��� �޿� ����� 3���� ������ ����� ��ȯ�ȴ�
    
group by ����� ���� ���� : select ����� �� �ִ� �÷��� ���ѵ�

select �׷��� ���� �÷�, �׷��Լ�
from ���̺�
group by �׷��� ���� �÷�
[order by];

�μ����� ���� ���� �޿�
select deptno, max(sal)
from emp
group by deptno;

select deptno, sal
from emp
order by deptno,sal;

select deptno, ename, max(sal) --����ȵ�. why? �׷��� ���� �÷��� �μ���ȣ�� ��Ƽ�
from emp
group by deptno;

select deptno, min(ename), max(sal) --�̰Ŵ� �����. ��� : �μ���ȣ�� �������� �̸��� ������..? ���� ������ ���� ū ��
from emp
group by deptno;

select deptno,
        max(sal), --�μ����� ���� ���� �޿� ��
        min(sal), --�μ����� ���� ���� �޿� ��
        round(avg(sal),2), --�μ��� �޿� ���
        sum(sal), --�μ����� �޿� ��
        count(sal), --�μ����� �޿� �Ǽ�(sal �÷��� ���� �ƴ� null�� �ƴ� row�� ��)
        count(*), --�μ��� ���� ��
        count(mgr)
from emp
group by deptno;

*�׷� �Լ��� ���� �μ���ȣ �� ���� ���� �޿��� ���� ���� ������ ���� ���� �޿��� �޴� ����� �̸��� �� ���� ����
==>���� window function�� ���� �ذ� ����

emp ���̺��� �׷� ������ �μ���ȣ�� �ƴ� ��ü �������� �����ϴ� ���
select  max(sal), --��ü ���� �� ���� ���� �޿� ��
        min(sal), --��ü ���� �� ���� ���� �޿� ��
        round(avg(sal),2), --��ü ������ �μ��� �޿� ���
        sum(sal), --��ü ������ �޿� ��
        count(sal), --��ü ������ �޿� �Ǽ�(sal �÷��� ���� �ƴ� null�� �ƴ� row�� ��)
        count(*), --��ü ���� ��
        count(mgr) -- mgr�÷��� null�� �ƴ� �Ǽ�
from emp;

2020.04.27�� ��ǥ �� ���� Ȯ��
group by���� ����� �÷���
    select���� ������ ������ --����
    
group by���� ������� ���� �÷���
    select���� ������ --����

�׷�ȭ�� ���� ���� ���ڿ�, ��� ���� select���� ǥ�� �� �� �ִ�(���� �ƴ�);
select deptno, 'test', 1,
        max(sal), --�μ����� ���� ���� �޿� ��
        min(sal), --�μ����� ���� ���� �޿� ��
        round(avg(sal),2), --�μ��� �޿� ���
        sum(sal), --�μ����� �޿� ��
        count(sal), --�μ����� �޿� �Ǽ�(sal �÷��� ���� �ƴ� null�� �ƴ� row�� ��)
        count(*), --�μ��� ���� ��
        count(mgr)
from emp
group by deptno;

group�Լ� ����� null ���� ���ܰ� �ȴ�
30�� �μ����� null���� ���� ���� ������ sum(comm)�� ���� ���������� ���Ǵ� �� Ȯ�� �� �� �ִ�
select deptno,sum(comm)
from emp
group by deptno;

10��, 20�� �μ��� sum(comm)�÷��� null�� �ƴ϶� 0�� �������� nulló��
* Ư���� ������ �ƴϸ� �׷��Լ� ������� nulló���� �ϴ� ���� ���ɻ� ����

nvl(sum(comm),0) : comm�÷��� sum �׷��Լ��� �����ϰ� ���� ����� nvl�� ����(1ȸ ȣ��)
sum(nvl(comm,0)) : ��� comm�÷��� nvl �Լ��� ���� ��(�ش� �׷��� row�� ��ŭ ȣ��) sum �׷��Լ� ����

select deptno, sum(nvl(comm,0)), nvl(sum(comm),0) --�ڿ� �ִ°� �� ȿ������ ���
from emp
group by deptno;

single row�Լ��� where���� ��� �� �� ������
multi row �Լ�(group�Լ�)�� where���� ����� �� ���� group by �� ���� having���� ������ ���

single row �Լ��� where ������ ��� ����
select *
from emp
where lower(ename) = 'smith';

�μ��� �޿� ���� 5000�� �Ѵ� �μ��� ��ȸ
select deptno, sum(sal)
from emp
where sum(sal)>9000
group by deptno; --����

select deptno, sum(sal)
from emp
group by deptno
having sum(sal) > 9000;

--grp1
select max(sal) as max_sal, min(sal) as min_sal, round(avg(sal),2) as avg_sal,
       sum(sal) as sum_sal, count(sal) as count_sal, count(mgr) as count_mgr, count(*) as count_all --all = * 
from emp;

--grp2
select  deptno, 
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno;

--grp3
select  deptno as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno
having decode(deptno,30,'ACCOUNTING',20,'RESEARCH',10,'SALES');

--grp3 *����
(1)
select  decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES') as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno
order by max(sal) desc;
(2)
select  decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES') as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES');

--grp4
select to_char(hiredate,'yyyymm') as hire_yyyymm, count(*) as cnt
from emp
group by to_char(hiredate,'yyyymm');

--grp5
select to_char(hiredate,'yyyy') as hire_yyyymm, count(*) as cnt
from emp
group by to_char(hiredate,'yyyy');

--grp6
select count(*) as cnt
from dept;

--grp7
select count(count(deptno)) as cnt
from emp
group by deptno;



select *
from emp;