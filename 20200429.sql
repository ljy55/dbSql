outer join
���̺� ���� ������ �����ص�, �������� ���� ���̺��� �÷��� ��ȸ�� �ǵ��� �ϴ� ���� ���
<====>
inner join(�츮�� ���ݱ��� ��� ���)

left outer join : ������ �Ǵ� ���̺��� join Ű���� ���ʿ� ��ġ
right outer join : ������ �Ǵ� ���̺��� join Ű���� �����ʿ� ��ġ
full outer join : left outer join + right outer join -(�ߺ��Ǵ� �����Ͱ� �ѰǸ� ������ ó��)

emp���̺��� �÷� �� mgr�÷��� ���� �ش� ������ ������ ������ ã�ư� �� �ִ�
������ king ������ ��� ����ڰ� ���� ������ �Ϲ����� inner ���� ó���� ���ο� �����ϱ� ������ 
king�� ������ 13���� �����͸� ��ȸ�� ��

inner ���� ����
����� ���, ����� �̸�, ���� ���, ���� �̸�
--oracle
select m.empno, m.ename, e.empno, e.ename
from emp e, emp m
where e.mgr = m.empno;
--ansi
select m.empno, m.ename, e.empno, e.ename
from emp e join emp m on(e.mgr = m.empno);

������ �����ؾ����� �����Ͱ� ��ȸ�ȴ�
==>king�� ����� ����(mgr)�� null�̱� ������ ���ο� �����ϰ�
king�� ������ ������ �ʴ´�(emp ���̺��� �Ǽ� 14��-->13��)
----------------------------------------------------------------------------------------------------------
���� ������ outer �������� ����
(king ������ ���ο� �����ص� ���� ������ ���ؼ��� ��������, ������ ����� ������ ���� ������ ������ �ʴ´�);

--ansi-sql : outer
select m.empno, m.ename, e.empno, e.ename
from emp e left outer join emp m on(e.mgr = m.empno);

from ���� ���̺� left outer join ���̺�

select m.empno, m.ename, e.empno, e.ename
from emp m right outer join emp e on(e.mgr = m.empno);

from ���̺� right outer join ���� ���̺�
--oracle-sql : outer
oracle join
1.from���� ������ ���̺� ���(�޸��� ����)
2.where ���� ���� ������ ���
3. ���� �÷�(�����)�� ������ �����Ͽ� �����Ͱ� ���� ���� �÷��� (+)
  ==> ������ ���̺� �ݴ����� ���̺��� ��� �÷���(+)
select m.empno, m.ename, e.empno, e.ename
from emp e, emp m
where e.mgr = m.empno(+);
--------------------------------------------------------------------------------------------------------------------
outer ������ ���� ��� ��ġ�� ���� ��� ��ȭ

������ ����� �̸�, ���̵� �����ؼ� ��ȸ
��, ������ �ҼӺμ��� 10���� ���ϴ� �����鸸 �����ؼ�;

--������ on���� ������� ��
select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e left outer join emp m on(e.mgr = m.empno and e.deptno = 10);

--������ where���� ������� ��
select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e left outer join emp m on(e.mgr = m.empno)
where e.deptno = 10;

select *
from emp;

outer ������ �ϰ� ���� ���̶�� ������ on���� ����ϴ°� �´�

select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e,emp m 
where e.mgr(+) = m.empno
     and e.deptno(+) = 10;
--------------------------------------------------------------------------------------------------------------------
--outerjoin1

select buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b right outer join prod p on(b.buy_prod = p.prod_id) and buy_date = to_date('20050125','yyyymmdd');

select buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');

--outerjoin2
select to_date('20050125','yyyymmdd') as buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');

--outerjoin3
select to_date('20050125','yyyymmdd') as buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty,0) as buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');
    
--outerjoin4
select p.pid, pnm, nvl(cid,1) as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p, cycle c
where p.pid = c.pid(+)
      and c.cid(+) = 1;
      
select p.pid, pnm, nvl(cid,1) as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);
--�������� �Ʒ��� �ִ� cid nulló���� �� �ո���
select p.pid, pnm, 1 as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);

select product.pid, pnm, customer.cid, cnm, day, cnt
from cycle, product, customer
where cycle.pid = product.pid(+) 
     and cycle.cid(+) = 1
     and cycle.cid = customer.cid(+);

select p.pid, pnm, 1 as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);

-----------------------------------------------------------------------------------------------------------------------

15 ==> 45
3�� ==> customer

cross join
���� ������ ������� ���� ���
��� ������ ���� �������� ����� ��ȸ�ȴ�
emp 14 * dept 4 = 56
select*
from emp cross join dept;

oracle (���� ���̺� ����ϰ� where ���� ������ ������� �ʴ´�)
select *
from emp, dept;

--crossjoin1
select *
from customer cross join product;

-------------------------------------------------------------------------------------
��������
where : ������ �����ϴ� �ุ ��ȸ�ǵ��� ����
select *
from emp
where 1=1 or 1 != 1 --> true or false ==> true

���� <==> ����
���������� �ٸ� ���� �ȿ��� �ۼ��� ����
�������� ������ ��ġ
1. select 
    scalar sub query : ��Į�� ���������� ��ȸ�Ǵ� ���� 1���̰�, �÷��� �Ѱ��� �÷��̾�� �Ѵ� --ex)dual

2. from 
    inline-view : ������ ��ȣ�� ���� ��

3. where 
    sub query : where���� ���� ����

smith�� ���� �μ��� ���� �������� ���� ������?
1. smith�� ���� �μ��� �������?
2.1������ �˾Ƴ� �μ���ȣ�� ���ϴ� ������ ��ȸ
==>�������� 2���� ������ ���� ����
    �ι�° ������ ù��°�� ������ ����� ���� ���� �ٸ��� �����;��Ѵ�
    smith(20) => ward(30) ==> �ι�° ���� �ۼ��� 10������ 30������ ������ ���� ==> �������� ���鿡�� ���� ����
ù��° ����
select deptno
from emp
where ename = 'SMITH';

�ι�° ����
select *
from emp
where deptno = 20;

���������� ���� ���� ����
select *
from emp
where deptno = (select deptno
               from emp
               where ename = 'SMITH');
               
--sub1
select count(*)
from emp 
where sal > (select avg(sal) 
            from emp);

--sub2
select *
from emp 
where sal > (select avg(sal) 
            from emp);
            
------------------------------------------------------------------------------------------------------------------------ 

