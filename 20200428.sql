--join2
(1) oracle;
select buyer_id, buyer_name, prod_id, prod_name
from prod, buyer
where prod.prod_buyer = buyer.buyer_id;

join2 ��� �Ǽ��� ���ϴ� sql
--1�� ��� : ���� ���� ���
select count(*)
from 
    (select buyer_id, buyer_name, prod_id, prod_name
    from prod, buyer
    where prod.prod_buyer = buyer.buyer_id); --ĥ������ : inline-view�� �� �ʿ��Ѱ��� Ȯ���ض�
--2�� ���
select count(*)
from prod, buyer
where prod.prod_buyer = buyer.buyer_id;

buyer_name�� �Ǽ� ��ȸ ���� �ۼ�
select buyer_name, count(*)
from prod, buyer
where prod.prod_buyer = buyer.buyer_id --join
group by buyer.buyer_name; --group

--join3
select mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
where cart.cart_member = member.mem_id and cart.cart_prod = prod.prod_id;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member join cart on(member.mem_id = cart.cart_member) 
            join prod on (cart.cart_prod = prod.prod_id);
     
�������
select *
from
    (select deptno, count(*)
     from emp
     group by deptno)
where deptno = 30;

select deptno, count(*)
from emp
group by deptno
having deptno = 30;

select deptno, count(*)
from emp
where deptno = 30
group by deptno;

--join4~7
select *
from customer;
cid : customer id
cnm : customer number

select *
from product;
pid : product id
pnm : product number

select *
from cycle;
cycle : �����ֱ�
cid : 
pid : 
day : ��������(�Ͽ���-1,������-2,ȭ����-3...)
cnt : ����

--join4
select customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
from customer, cycle
where customer.cid = cycle.cid 
      and customer.cnm in('brown','sally');

select customer.cid, cnm, pid, day, cnt
from customer, cycle
where customer.cid = cycle.cid 
      and customer.cnm in('brown','sally');

select cid, cnm, pid, day, cnt
from customer natural join cycle
where customer.cnm in('brown','sally');

--join5
select customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
from customer, cycle, product
where customer.cid = cycle.cid 
      and cycle.pid = product.pid 
      and customer.cnm in('brown','sally');

--join6
select customer.cid, customer.cnm, cycle.pid, product.pnm, sum(cnt) as cnt
from customer, cycle, product
where customer.cid = cycle.cid and cycle.pid = product.pid
group by customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.cnt;

--count(cnt) -> cnt�� null�� ���� ���� ����
--count(*) -> null�� �ְ� ���� ��� ���� ����

--join7
select product.pid, product.pnm, sum(cnt) as cnt
from product, cycle
where product.pid = cycle.pid
group by product.pid, product.pnm;

select a.pid, b.pnm, a.cnt
from
  (select pid, sum(cnt) as cnt
   from cycle
   group by cycle.pid) a, product b
where a.pid = b.pid;




