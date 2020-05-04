������

��Ģ ������ : +, -, *, / : ���� ������
���� ������ : ? (1==1 ? true�� �� ���� : false�� �� ����)

sql ������
= : �÷�] ǥ���� = �� ==> ���� ������

in  : �÷�] ǥ���� in (����)
deptno in (10,30) ==> in (10,30), deptno (10,30)

exists ������
�����  : exists (��������)
���������� ��ȸ����� �Ѱ��̶� ������ true
�߸��� ����� : where deptno exists (��������)

���������� ���� ���� ���� ���������� ���� ����� �׻� ���� �ϱ� ������ emp ���̺��� ��� �����Ͱ� ��ȸ �ȴ�
�Ϲ������� exists �����ڴ� ��ȣ���� ���������� ���� ���
�Ʒ� ������ ���ȣ ��������
select *
from emp
where exists (select 'X'
              from dept);
              
exists �������� ����
�����ϴ� ���� �ϳ��� �߰��� �ϸ� ���̻� Ž���� ���� �ʰ� �ߴ�.
���� ���� ���ο� ������ ���� �� ���
-----------------------------------------------------------------------------------------------------------
�Ŵ����� ���� ���� : king
�Ŵ��� ������ �����ϴ� ���� : 14-king = 13���� ����
--1
select *
from emp
where mgr is not null;
--2
select *
from emp e
where exists (select 'x'
             from emp m
             where e.mgr = m.empno);
--3
select e.*
from emp e, emp m
where e.mgr = m.empno;
--------------------------------------------------------------------------------------------------------------------
--sub9
select *
from product
where exists(select *
             from cycle
             where cid = 1
                and cycle.pid = product.pid);

--sub10
select *
from product
where not exists(select *
             from cycle
             where cid = 1
                and cycle.pid = product.pid);
------------------------------------------------------------------------------------------------------
���տ���
������
{1, 5, 3} U {2, 3} = {1, 2, 3, 5}
������
{1, 5, 3} ������ {2, 3} = {3}
������
{1, 5, 3} - {2, 3} = {1, 5}
sql���� �����ϴ�  union all(�ߺ� �����͸� ���� ���� �ʴ´�)
{1, 5, 3} U {2, 3} = {1, 5, 3, 2, 3}

sql������ ���տ���
������ : union, union all, intersect, minus
�ΰ��� sql�� �������� ���� Ȯ�� (��,�Ʒ��� ���� �ȴ�)

--union ������ : �ߺ�����(������ ������ ���հ� ����) 
select empno, ename
from emp
where empno in (7566, 7698, 7369)

union

select empno, ename
from emp
where empno in (7566, 7698);

--union all������ : �ߺ� ���
select empno, ename
from emp
where empno in (7566, 7698, 7369)

union all

select empno, ename
from emp
where empno in (7566, 7698);

--intersect ������ : �����հ� �ߺ��Ǵ� ��Ҹ� ��ȸ
select empno, ename
from emp
where empno in (7566, 7698, 7369)

intersect

select empno, ename
from emp
where empno in (7566, 7698);

--minus ������ : ���� ���տ��� �Ʒ��� ���� ��Ҹ� ����
select empno, ename
from emp
where empno in (7566, 7698, 7369)

minus

select empno, ename
from emp
where empno in (7566, 7698);

<sql ���տ������� Ư¡>
1. ���� �̸� : ù��° sql�� �÷��� ���󰣴�

--ù��° ������ �÷��� ��Ī �ο�
select ename nm, empno no
from emp
where empno in (7369)
union
select ename, empno
from emp
where empno in(7698);

2. ������ �ϰ���� ��� �������� ���� ����
   ���� sql���� order by �Ұ� (�ζ��� �並 ����Ͽ� ������������ order by�� ������� ������ ����)
select ename nm, empno no
from emp
where empno in (7369)
--order by nm ==>����. �߰� ������ ���� �Ұ�
union
select ename, empno
from emp
where empno in(7698)
order by nm;

3. sql�� ���� �����ڴ� �ߺ��� �����Ѵ�(������ ���� ����� ����), ��, union all�� �ߺ� ���

4. �ΰ��� ���տ��� �ߺ��� �����ϱ� ���� ������ ������ �����ϴ� �۾��� �ʿ�
  ==> ����ڿ��� ����� �����ִ� �������� ������
     ==> union all�� ����� �� �ִ� ��Ȳ�� ��� union�� ������� �ʾƾ� �ӵ����� ���鿡�� �����ϴ�
    
�˰���(����-���� ����, ���� ����....
        �ڷ� ���� : Ʈ������(���� Ʈ��, �뷱�� Ʈ��)
                    heap
                    stack, queue
                    list
���տ��꿡�� �߿��� ���� : �ߺ�����

-----------------------------------------------------------------------------------------------------
select *
from fastfood
where sido = '����Ư����' and sigungu = '�߱�';

select sido, SIGUNGU, count(gb)
from fastfood
group by sido, SIGUNGU, gb
having gb != '�Ե�����'
order by sido;

select *
from
(select sido, sigungu, c
from (select sido, SIGUNGU, count(gb) as c
     from fastfood
     group by sido, SIGUNGU, gb
     having gb != '�Ե�����') 
group by sido, sigungu, c );



select sido, sigungu, a
from (select sido, SIGUNGU, count(gb) as a
     from fastfood
     group by sido, SIGUNGU, gb
     having gb != '�Ե�����') 
group by sido, sigungu, a;

select sido, sigungu
from fastfood
group by sido, sigungu;

select m.sido, m.sigungu, m.a, n.b, round(a/b,2)
from
(select sido, sigungu, count(gb) as a
from fastfood
where gb in ('����ŷ','�Ƶ�����','KFC')
group by sido, sigungu) m,
(select sido, sigungu, count(gb) as b
from fastfood
where gb = '�Ե�����'
group by sido, sigungu) n
where m.sido = n.sido and m.sigungu=n.sigungu
order by a/b desc;
-------------------------------------------------------------------------------------------------------------
--�ܹ��� ���� : ���� ����-where, group by, count, �ζ��� ��, rownum, order by, ��Ī(�÷�,���̺�), round, join
select rownum || '��' as ���ù�������, x.*
from
(select m.sido, m.sigungu, m.a, n.b, round(a/b,2)
from
(select sido, sigungu, count(gb) as a
from fastfood
where gb in ('����ŷ','�Ƶ�����','KFC')
group by sido, sigungu) m,
(select sido, sigungu, count(gb) as b
from fastfood
where gb = '�Ե�����'
group by sido, sigungu) n
where m.sido = n.sido and m.sigungu = n.sigungu
order by a/b desc)x;

����1] fastfood ���̺�� tax ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� sql �ۼ� : �ʼ�
1. ���ù��������� ���ϰ�(������ ���� ���ð� ������ ����)
2. �δ� ���� �Ű���� ���� �õ� �ñ������� ������ ���Ͽ�
3.���ù��������� �δ� �Ű�� ������ ���� ������ ����(rownum) �����Ͽ� �Ʒ��� ���� �÷��� ��ȸ�ǵ��� sql �ۼ�
���� �ܹ��� �õ�, �ܹ��� �ñ���, �ܹ��� ���ù�������, ����û �õ�, ����û �ñ���, ����û �������� �ݾ�1�δ� �Ű��

����2] : �ɼ� 
�ܹ��� ���ù��� ������ ���ϱ� ���� 4���� �ζ��� �並 ��� �Ͽ��µ�(fastfood ���̺��� 4�� ���)
�̸� �����Ͽ� ���̺��� �ѹ��� �д� ���·� ������ ����(fastfood ���̺��� 1���� ���)
case, decode

����3] : �ɼ�
�ܹ��� ���� sql�� �ٸ����·� �����ϱ�