--grp7
dept ���̺��� Ȯ���ϸ� �� 4���� �μ� ������ ���� ==> ȸ�系�� �����ϴ� ��� �μ�����
emp ���̺��� �����Ǵ� �������� ���� ���� �μ������� ���� ==> 10,20,30,40 ==> 3��

select count(count(deptno)) as cnt
from emp
group by deptno;

select count(*) as cnt
from
    (select deptno / deptno  --�÷��� 1�� ����, row�� 3���� ���̺�
    from emp
    group by deptno);
    
select count(*)
from
  (select count(*) as cnt
  from
    (select deptno / deptno 
    from emp
    group by deptno));
-----------------------------------------------------------------------------------------------------------------------
DBMS �� RDBMS
DBMS : database management system
==>DB
RDBMS : relational database management system
==>������ �����ͺ��̽� ���� �ý���

JOIN ������ ����
ANSI - ǥ��
�������� ����(ORACLE)

join�� ��� �ٸ� ���̺��� �÷��� ����� �� �ֱ� ������ select �� �� �ִ� �÷��� ������ ��������(����Ȯ��)
���տ��� ==> ���� Ȯ��(���� ��������)
------------------------------------------------------------------------------------------------------------
NATURAL JOIN
    - �����Ϸ��� �� ���̺��� ����� �÷��� �̸� ���� ���
    - emp, dept ���̺��� deptno��� �����(������ �̸���, Ÿ�Ե� ����) ����� �÷��� ����
    - �ٸ� ANSI-SQL ������ ���ؼ� ��ü�� �����ϰ�, ���� ���̺���� �÷����� �������� ������ ����� �Ұ����ϱ� ������
      ���󵵴� �ټ� ����
    
.emp ���̺� : 14��
.dept ���̺� : 4��

�����Ϸ��� �ϴ� �÷��� ���� ������� ����
select *
from emp natural join dept; --from���� ���̺���� ������ �� �� ������? ���� join�غ�!!
==>�� ���̺��� �̸��� ������ �÷����� �����Ѵ�(������ �÷�=deptno=�����÷�(�����))

select *
from dept;
------------------------------------------------------------------------------------------------------
ORACLE ���� ������ ANSI ����ó�� ����ȭ ���� ����
����Ŭ ���� ����
1. ������ ���̺� ����� from���� ����ϸ� �����ڴ� Ŭ��(,)
2. ����� ������ where���� ����ϸ� �ȴ�(ex : where emp.deptno = dept.deptno)

select *
from emp, dept
where emp.deptno = dept.deptno;

deptno�� 10���� �����鸸 dept ���̺�� ���� �Ͽ� ��ȸ
select *
from emp, dept
where emp.deptno = dept.deptno
    and emp.deptno = 10; --and dept.deptno = 10; �̷��� �ᵵ �������
-------------------------------------------------------------------------------------------------------    
ANSI-SQL : JOIN with USING
- join �Ϸ��� ���̺� �̸��� ���� �÷��� 2�� �̻��� ��
- �����ڰ� �ϳ��� �÷����θ� �����ϰ� ���� �� ���� �÷����� ���

select *
from emp join dept using (deptno);
---------------------------------------------------------------------------------------------------------
ANSI-SQL : JOIN with ON --���� ����
- ���� �Ϸ��� �� ���̺� �÷����� �ٸ� ��
- ON���� ����� ������ ���;

select *
from emp join dept on (emp.deptno = dept.deptno);

oracle �������� �� sql�� �ۼ�
select *
from emp, dept
where emp.deptno = dept.deptno;
-------------------------------------------------------------------------------------------------------
JOIN�� ������ ����
self join : �����Ϸ��� ���̺��� ���� ���� ��
emp ���̺��� ������ ������ ������ ��Ÿ���� ������ ������ mgr�÷��� �ش� ������ ������ ����� ����
�ش� ������ �������� �̸��� �˰���� �� --�Լ�����

ansi-sql�� sql ���� :
�����Ϸ��� �ϴ� ���̺� emp(����), emp(������ ������)
            ����� �÷� : ����.mgr = ������.empno
            ==> ���� �÷� �̸��� �ٸ���(mgr, empno)
             ==> natural join, join with using �� ����� �Ұ����� ����
              ==>join with on �� ����ؼ� �ۼ� �� �� �ۿ� ����

ansi-sql�� �ۼ�

select * 
from emp e join emp m on (e.mgr = m.empno); 

select * 
from emp as e join emp as m on (e.mgr = m.empno); --����==> ���̺��� ��Ī�ٶ��� as ������ ���� �ȵ�. �� ���� �׳� ��Ī����� 
-------------------------------------------------------------------------------------------------------------------------
NONEUQI JOIN : ����� ������ = �� �ƴ� ��
�׵��� where���� ����� ������ : =, !=, <>,<=, <, >, >=
                             and, or, not
                             like %, _
                             or - in
                             between and
select *
from emp;

select *
from salgrade;

select *
from emp join salgrade on (emp.sal between salgrade.losal and salgrade.hisal);

select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp join salgrade on (emp.sal between salgrade.losal and salgrade.hisal);

==> oracle ���� �������� ����
select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp, salgrade
where sal between salgrade.losal and salgrade.hisal;

select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp, salgrade
where emp.sal between salgrade.losal and salgrade.hisal;
-------------------------------------------------------------------------------------------------------------------------
--join0
(1) join with on;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
order by dname;

(2) oracle;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
order by dname;

(3) natural join;
select empno, ename, deptno, dname
from emp natural join dept
order by dname;

(4) join using;
select empno, ename, deptno, dname
from emp join dept using (deptno)
order by dname;


--join0_1
(1) join with on;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.deptno !=20; --emp.deptno = 10 or emp.deptno = 30

(2)oracle;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    --and (emp.deptno = 10 or emp.deptno = 30); --dept.deptno in (10,30) or emp.deptno in (10,30)
    and (dept.deptno = 10 or dept.deptno = 30);

(3) natural join;
select empno, ename, deptno, dname
from emp natural join dept
where deptno !=20; --deptno = 10 or deptno = 30

(4) join using;
select empno, ename, deptno, dname
from emp join dept using (deptno)
where deptno = 10 or deptno = 30; --deptno != 20


--join0_2
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500
order by deptno;


--join0_3
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500 and empno > 7600
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500 and emp.empno > 7600
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500 and empno > 7600
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500 and empno > 7600
order by deptno;


--join0_4
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500 and emp.empno > 7600 and dept.dname = 'RESEARCH'
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500 and emp.empno > 7600 and dept.dname = 'RESEARCH'
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500 and empno > 7600 and dname = 'RESEARCH'
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500 and empno > 7600 and dname = 'RESEARCH'
order by deptno;


----------------------------------------------------------------------------------------------------------------------
�����غ���
select empno, ename, emp.deptno, dname 
from emp, dept
where emp.deptno != dept.deptno;

select empno, ename, emp.deptno, dname 
from emp, dept
where emp.deptno <= dept.deptno;
-----------------------------------------------------------------------------------------------------------------------
--join1
(1) join with on ;
select lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
from prod join lprod on (prod.prod_lgu = lprod.lprod_gu);

(2) oracle;
select lprod_gu, lprod_nm, prod_id, prod_name
from prod, lprod
where prod.prod_lgu = lprod.lprod_gu;
