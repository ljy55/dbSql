�Ѱ��� ��, �ϳ��� �÷��� �����ϴ� ��������
ex : ��ü ������ �޿� ���, smith ������ ���� �μ��� �μ���ȣ

where���� ��밡���� ������
where deptno = 10
===>
�μ���ȣ�� 10 Ȥ�� 30���� ���
where deptno in(10,30)
where deptno = 10 or deptno = 30
------------------------------------------------------------------------------------------------------------
������ ������
�������� ��ȸ�ϴ� ���������� ��� = �����ڸ� ���Ұ�
where deptno in(10,30) <-�̰Ŵ� ���� + (�������� ���� �����ϰ�, �ϳ��� �÷����� �̷���� ����)

SMITH = 20, ALLEN�� 30�� �μ��� ����

SMITH �Ǵ� ALLEN�� ���ϴ� �μ��� ������ ������ ��ȸ

���� ��������, �÷��� �ϳ��� 
==> ������������ ��밡���� ������ IN(���̾�,�߿�), (ANY,ALL(�󵵰� ����))
IN : ���������� ����� �� ������ ���� ���� �� true
    WHERE �÷�, ǥ���� IN (��������)

ANY : �����ڸ� �����ϴ� ���� �ϳ��� ���� �� TRUE
    WHERE �÷�, ǥ���� ������ ANY (��������)
    
ALL : ���������� ��� ������ �����ڸ� ������ �� TRUE
    WHERE �÷�, ǥ���� ������ ALL (��������)
    
SMITH�� ALLEN�� ���� �μ����� �ٹ��ϴ� ��� ������ ��ȸ

1. ���������� ������� ���� ��� : �ΰ��� ������ ����
1-1] SMITH�� ALLEN�� ���� �μ��� �μ���ȣ�� Ȯ���ϴ� ����
SELECT *
FROM EMP
WHERE ENAME IN('SMITH', 'ALLEN');
1-2] 1-1���� ���� �μ���ȣ�� IN�����ڸ� ���� �ش� �μ��� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20,30)

===>���������� �̿��ϸ� �ϳ��� SQL�ּ� ���డ��
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM EMP
                WHERE ENAME IN('SMITH', 'ALLEN'));
-------------------------------------------------------------------------------------------------                
--�ǽ� sub3
select *
from emp
where deptno in(select deptno
                from emp
                where ename in('SMITH','WARD'));
-------------------------------------------------------------------------------------------------                
//����
ANY, ALL ---any : or / all : and 
SMITH�� WARD �� ����� �޿� �� �ƹ� ������ ���� �޿��� �޴� ���� ��ȸ
===> sal < 1250
select *
from emp
where sal < any (select sal
                from emp
                where ename in ('SMITH', 'WARD'));
SMITH�� WARD �� ����� �޿����� ���� �޿��� �޴� ���� ��ȸ
===>sal > 1250
select *
from emp
where sal > all (select sal
                from emp
                where ename in ('SMITH', 'WARD'));
------------------------------------------------------------------------------------------------------
IN �������� ����
�ҼӺμ��� 20, Ȥ�� 30�� ���
where deptno in (20,30)

�ҼӺμ��� 20,30�� ������ �ʴ� ���
where deptno not in (20,30)
not in �����ڸ� ��� �� ��� ���������� ���� null�� �ִ��� ���ΰ� �߿�
==>null�� ������ �������� �������� ����

�Ʒ� ������ ��ȸ�ϴ� ����� � �ǹ��ΰ�?? �������� �Ŵ����� �ƴ� ���=���� ��ȸ
--nulló�� ���ؼ� ������ �ƹ��͵� ��ȸ�� �ȵ�
select *
from emp
where empno not in (select mgr
                    from emp);
--nulló�� 1 : null���� ���� ���� ����
select *
from emp
where empno not in (select mgr
                    from emp
                    where mgr is not null);
--nulló�� 2 : nulló�� �Լ��� ���� ������ ������ ���� �ʴ� ������ ġȯ
select *
from emp
where empno not in (select nvl(mgr,-1)
                    from emp);
------------------------------------------------------------------------------------------
���� �÷��� �����ϴ� ���������� ���� ���� ==> ���� �÷��� �����ϴ� ��������
PAIRWISE ���� (������) ==> ���ÿ� ����

SELECT empno, mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

7499, 7782����� ������ ���� �μ�, ���� �Ŵ����� ��� ���� ���� ��ȸ
�Ŵ����� 7698�̸鼭 �ҼӺμ��� 30���� ���
�Ŵ����� 7839�̸鼭 �ҼӺμ��� 10�� ���

mgr�÷��� deptno�÷��� �������� ����
select *
from emp
where mgr in (7698,7839) and deptno in (10,30); 

PAIRWISE ���� (���� �������� ����� �Ѱ� ����)
select *
from emp
where (mgr, deptno) in (select mgr, deptno
                        from emp
                        WHERE empno IN (7698,7839));
-------------------------------------------------------------------------------------------------------                        
�������� ����-��� ��ġ�� ����
select - ��Į�� ���� ����
from - �ζ��� ��
where - ��������

�������� ���� - ��ȯ�ϴ� ��, �÷��� ��
���� ��
    ���� �÷�(��Į�� ���� ����)
    ���� �÷�
���� ��
    ���� �÷�(���� ���� ����)
    ���� �÷�
    
��Į�� ��������
select ���� ǥ���Ǵ� ��������
������ ���� �÷��� �����ϴ� ���������� ��� ����
���� ������ �ϳ��� �÷�ó�� �ν�

select 'X', (select sysdate from dual)
from dual;

��Į�� ���� ������ �ϳ��� ��, �ϳ��� �÷��� ��ȯ �ؾ� �Ѵ�
--���� �ϳ����� �÷��� 2������ ����
select 'X', (select empno, ename from emp where ename = 'SMITH')
from dual;

������ �ϳ��� �÷��� �����ϴ� ��Į�� ��������
--����
select 'X', (select empno from emp)
from dual;

emp ���̺� ��� �� ��� �ش� ������ �Ҽ� �μ� �̸��� �� ���� ���� ==>join
Ư�� �μ��� �μ� �̸��� ��ȸ�ϴ� ����
select dname
from dept
where deptno = 10;

�� ������ ��Į�� ���������� ����

join���� ����
select empno, ename, dept.deptno, dname
from emp, dept
where emp.deptno =  dept.deptno;

�� ������ ��Į�� ���������� ����
select empno, ename, emp.deptno  --, �μ��̸�
from emp;

select empno, ename, emp.deptno, (select dname from dept where deptno = emp.deptno)
from emp;

�������� ���� - ���������� �÷��� ������������ ����ϴ��� ���ο� ���� ����
��ȣ���� ��������(corelated sub query)
    .���� ������ ���� �Ǿ�� ���� ������ ������ �����ϴ�
���ȣ ���� ��������(non corelated sub query)    
    .���� ������ ���̺��� ���� ��ȸ �� ���� �ְ�,
     sub ������ ���̺��� ���� ��ȸ �� ���� �ִ�
     ==>����Ŭ�� �Ǵ� ���� �� ���ɻ� ������ �������� ���� ������ ����

��� ������ �޿���� ���� ���� �޿��� �޴� ������ ��ȸ�ϴ� ������ �ۼ� �ϼ���(���� ���� �̿�)
select *  
from emp
where sal > (select avg(sal) from emp)
�����غ� ����, ���� ������ ��ȣ ���� ���� �����ΰ�? ���ȣ ���� ���� �����ΰ�?

������ ���� �μ��� �޿� ��պ��� ���� �޿��� �޴� ����
��ü ������ �޿� ���==>������ ���� �μ��� �޿� ���

Ư�� �μ��� �޿� ����� ���ϴ� SQL;
select avg(sal)
from emp
where deptno = 10;

select *
from emp e
where e.sal > (select avg(sal)
               from emp b
               where b.deptno = e.deptno);
--��ȣ ���� ���� : �ݵ�� ���� ������ ���� ���� ���� ������ ���� �Ǿ�����.
--------------------------------------------------------------------------------------------
select *
from dept;
--�ǽ� sub4
insert into dept values (99, 'ddit', 'daejeon');

emp���̺� ��ϵ� �������� 10,20,30�� �μ����� �Ҽ��� �Ǿ�����
������ �Ҽӵ��� ���� �μ���  : 40, 99

select *
from dept 
where deptno not in (10,20,30); --dept.deptno = emp.deptno; 10,20,30

select *
from dept
where deptno not in (select deptno
                     from emp);                   

���������� �̿��Ͽ� in�����ڸ� ���� ��ġ�ϴ� ���� �ִ��� ������ ��
���� ������ �־ ��� ����(����)

������ �μ���ȣ�� ������������ ��ȸ���� �ʵ��� ���� �ҷ��� �׷� ������ �� ���(���� �´�)
select *
from dept
where deptno not in (select deptno
                    from emp
                    group by deptno);
//����                   
select *
from dept
where 0 < (select sum(empno)
            from emp
            where emp.deptno = dept.deptno);

--�ǽ�sub5
select pid
from cycle
where cid = 1;

select *
from product;

select *
from product
where pid not in (select pid
                   from cycle
                   where cid = 1);
                   
--�ǽ�sub6
1�� ���� ������ǰ ������ ��ȸ�� �Ѵ�
��, 2�� ���� �Դ� ������ǰ�� ��ȸ�� �Ѵ�
1] 1�� ���� �Դ� ������ǰ����
select *
from cycle
where cid = 1;
2] 2�� ���� �Դ� ������ǰ����
select pid
from cycle
where cid = 2;
--���ȣ��������
select *
from cycle 
where cid = 1 and pid in (select pid
                          from cycle 
                          where cid = 2);
              
select *
from product;

select *
from cycle;

--�ǽ�sub7
������ �̿��� ���
select c.cid, cnm, c.pid, pnm, day, cnt
from customer s, cycle c, product p
where c.cid = 1 
     and s.cid = c.cid 
     and p.pid = c.pid 
     and c.pid in (select a.pid
                   from cycle a 
                   where a.cid = 2);
 
select cycle.cid, cnm, cycle.pid, pnm, day, cnt
from customer, cycle, product
where customer.cid = cycle.cid 
     and product.pid = cycle.pid 
     and cycle.cid = 1 and cycle.pid in (select cycle.pid
                                         from cycle 
                                         where cycle.cid = 2);

��Į�������� �̿��� ���                   
select cid, (select cnm from customer where cid = cycle.cid) as cnm, 
       pid, (select pnm from product where pid = cycle.pid) as pnm, day,cnt
from cycle
where cid = 1
and pid in (select pid
            from cycle
            where cid = 2);
==>������ �̿��� ����� �� �Ǵ�....��Į�� ������ ������ �ʹ� ���� ��..����