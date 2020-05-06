--����1
/*select sido, sigungu
from tax

minus

select sido,sigungu
from fastfood;*/ --�����Ǵ� �ڷ� �ִ��� ����

select a.sido, a.sigungu, a.city_idx, q.tax
from
(select rownum rank, sido, sigungu, city_idx
from
(select sido, sigungu, round((kfc + mac + bk) / lot ,2) city_idx
from
(select sido, sigungu, 
        nvl(sum(case when gb = '�Ե�����' then 1 end), 1) lot, 
        nvl(sum(case when gb = 'KFC' then 1 end), 0) kfc,
        nvl(sum(case when gb = '�Ƶ�����' then 1 end), 0) mac, 
        nvl(sum(case when gb = '����ŷ' then 1 end), 0) bk
from fastfood
where gb in ('����ŷ','KFC','�Ƶ�����','�Ե�����')
group by sido, sigungu)
order by city_idx desc)) a,
(select rownum rank, sido, sigungu, tax
from
    (select sido, sigungu, round(sal/people,2) tax
    from tax
    order by tax desc)) q 

where a.rank(+) = q.rank;

--����2
fastfood ���̺� �ѹ��� �а� ���ù������� ���ϱ�;

���� �ܹ������� �ּ�(�����̽�, ������ġ �����ϰ� ���)
select rownum, sido, sigungu, city_idx
from
(select sido, sigungu, round((kfc + mac + bk) / lot ,2) city_idx
from
(select sido, sigungu, 
        nvl(sum(case when gb = '�Ե�����' then 1 end), 1) lot, 
        nvl(sum(case when gb = 'KFC' then 1 end), 0) kfc,
        nvl(sum(case when gb = '�Ƶ�����' then 1 end), 0) mac, 
        nvl(sum(case when gb = '����ŷ' then 1 end), 0) bk
from fastfood
where gb in ('����ŷ','KFC','�Ƶ�����','�Ե�����')
group by sido, sigungu)
order by city_idx desc);

----------------------------------------------------------------------------------------------------
DNL
�����͸� �Է�(INSERT), ����(UPDATE), ����(DELETE) �� �� ����ϴ� SQL

INSERT

����
INSERT INTO ���̺��[(���̺��� �÷���,....)] VALUES(�Է��� ��,.....);

ũ�� ���� �ΰ��� ���·� ���
1.���̺��� ��� �÷��� ���� �Է��ϴ� ���, �÷����� �������� �ʾƵ� �ȴ�
  ��, �Է��� ���� ������ ���̺� ���ǵ� �÷� ������ �νĵȴ�
INSERT INTO ���̺�� VALUES (�Է��� ��, �Է��� ��2...);

2.�Է��ϰ��� �ϴ� �÷��� ����ϴ� ���
  ����ڰ� �Է��ϰ��� �ϴ� �÷��� �����Ͽ� �����͸� �Է��� ���
  ��, ���̺� NOT NULL ������ �Ǿ��ִ� �÷��� �����Ǹ� INSERT�� �����Ѵ�
INSERT INTO ���̺�� (�÷�1, �÷�2) VALUES (�Է��� ��, �Է��� ��2);

3.select ����� insert 
  select ������ �̿��ؼ� ������ ���� ��ȸ�Ǵ� ����� ���̺� �Է� ����
  ==> �������� �����͸� �ϳ��� ������ �Է� ���� (ONE-QUERY)==> ���� ����
  
  ����ڷκ��� �����͸� ���� �Է� �޴� ��� (ex ȸ������)�� ������ �Ұ�
  db�� �����ϴ� �����͸� ���� �����ϴ� ��� Ȱ�� ����(�̷� ��찡 ����)
  
  insert into ���̺�� [(�÷���1, �÷���2...)]
  select .....
  from .....
----------------------------------------------------------------------------------------------------------------
dept ���̺� deptno 99, dname DDIT, loc daejeon ���� �Է��ϴ� INSERT ���� �ۼ�
select *
from dept;

INSERT INTO dept VALUES (99, 'DDIT', 'daejeon');
rollback;

�����͸� Ȯ�� ��������  : commit - Ʈ����� �Ϸ�
������ �Է��� ��� �Ϸ��� : rollback - Ʈ����� ���

INSERT INTO dept (loc, deptno, dname) values ('deajeon', 99, 'DDIT');
rollback;

���� insert ������ ������ ���ڿ�, ����� �Է��� ���
---------------------------------------------------------------------------------------------------------------------
insert �������� ��Į�� ��������, �Լ��� ��� ����
ex : ���̺� �����Ͱ� �� ����� �Ͻ������� ��� �ϴ� ��찡 ���� ==>sysdate;

select *
from emp;

emp ���̺��� ��� �÷� �� ������ 8��, not null�� 1��(empno)
empno�� 9999�̰� ename�� �����̸�, hiredate�� ���� �Ͻø� �����ϴ� insert ������ �ۼ�
insert into emp (empno, ename, hiredate) values (9999, '������', sysdate);

9998�� ������� jw����� �Է�, �Ի����ڴ� 2020��4��13�Ϸ� �����Ͽ� ������ �Է�
insert into emp (empno, ename, hiredate) values (9998, 'jw', to_date('20200413','yyyymmdd'));

empno���̺��� not null(desc emp), �Ʒ� ���� �����ϸ� ������
insert into emp (ename, hiredate) values ('jw', to_date('20200413','yyyymmdd'));
----------------------------------------------------------------------------------------------------------------------
select ����� ���̺� �Է��ϱ�(�뷮 �Է�);

desc dept;

dept ���̺��� 4���� �����Ͱ� ����(10~40)
�Ʒ������� �����ϸ� ���� ���� 4�� + select�� �ԷµǴ� 4�� �� 8���� �����Ͱ� dept ���̺� �Էµ�
insert into dept
select *
from dept;

������ Ȯ��
select *
from dept;
---------------------------------------------------------------------------------------------------------------------
UPDATE : ������ ����
UPDATE ���̺�� SET ������ �÷�1 = ������ ��1,
                   [������ �÷�1 = ������ ��1, .....]
[WHERE condition-SELECT ������ ��� WHERE���� ����
        ������ ���� �ν��ϴ� ������ ���]

dept ���̺� 99,ddit,daejeon;
insert into dept values (99, 'DDIT', 'deajeon');

������ �Է� Ȯ��
select *
from dept;

99�� �μ��� �μ����� ���IT��, ��ġ�� ���κ������� ����
update dept set dname = '���IT', loc = '���κ���'
where deptno = 99;

�Ʒ� ������ dept ���̺��� ��� ���� �μ���� ��ġ�� �����ϴ� ����
update dept set dname = '���IT', loc = '���κ���'

insert : ���� �� ���� ����
update, delete : ������ �ִ°� ����, ����
 ==> ������ �ۼ��� ��� ����
        1. where���� �������� �ʾҴ���
        2. update, delect ���� �����ϱ����� where���� �����ؼ� select�� �Ͽ�
           ������ ���� ���� ������ Ȯ��
           
���������� �̿��� ������ ����;
insert into emp (empno, ename, job) values (9999, 'brown', null);

9999�� ������ deptno, job �ΰ��� �÷��� smith ����� ������ �����ϰ� ����
update emp set deptno = (select deptno from emp where ename = 'SMITH'), 
                job = (select job from emp where ename = 'SMITH') 
where empno = 9999;
�Ϲ����� update ���������� �÷����� ���������� �ۼ��Ͽ� ��ȿ���� ����
==> merge ������ ���� ��ȿ���� ���� �� �� �ִ�

where���� ���� ���� ����� �ۼ��ߴ��� Ȯ���ϱ�!
select *
from emp
where empno = 9999;

��������� ���
rollback;
-----------------------------------------------------------------------------------------------------------
delete : ���̺� �����ϴ� �����͸� ����
����
delete [from] ���̺��
[where condition]

������
1. Ư�� �÷��� ���� ���� ==> �ش� �÷��� null�� update
    delete���� �� ��ü�� ����
2. update ���������� delete ������ �����ϱ� ���� select�� ���� ���� ����̵Ǵ� ���� ��ȸ, Ȯ������

���� �׽�Ʈ ������ �Է�;
insert into emp (empno, ename, job) values (9999, 'brown', null);

����� 9999���� ���� ���� �ϴ� ���� �ۼ�
delete emp
where empno = 9999;

where���� ���� ���� ����� �ۼ��ߴ��� Ȯ���ϱ�!
select *
from emp
where empno = 9999;

rollback;

�Ʒ� ������ �ǹ� : emp ���̺��� ��� ���� ����
delete emp;

select *
from emp;

rollback;

update, delete ���� ��� ���̺� �����ϴ� �����Ϳ� ����, ������ �ϴ� ���̱� ������
��� ���� �����ϱ� ���� where ���� ����� �� �ְ�
where���� select ������ ����� ������ ���� �� �� �ִ�
���� ��� ���������� ���� ���� ������ ����

�Ŵ����� 7698�� �������� ��� ���� �ϰ� ���� ��
delete emp
where empno in
        (select empno
        from emp
        where mgr = 7698);

select *
from emp
where mgr = 7698;

rollback;

DML : select, insert, update, delete
where ���� ��� ����� DML : select, update, delete
    3���� ������ �����͸� �ĺ��ϴ� where���� ��� �� �� �ִ�
    �����͸� �ĺ��ϴ� �ӵ��� ���� ������ ���� ������ �¿� ��
    ==> index ��ü�� ���� �ӵ� ����� ����

insert : ������� �ű� �����͸� �Է� �ϴ� ��
         ������� �ĺ��ϴ°� �߿�
         ==> �����ڰ� �� �� �ִ� Ʃ�� ����Ʈ�� ���� ����
         
���̺��� �����͸� ����� ��� (��� ������ �����)
1. delete : where���� ������� ������ ��
2. truncate
    ���� : truncate table ���̺��
    Ư¡ : 1) ������ �α׸� ������ ����
            ==> ������ �Ұ���
          2) �α׸� ������ �ʱ� ������ ���� �ӵ��� ������
            ==> �ȯ�濡���� �� ������� ���� (������ �ȵǱ� ������)
                �׽�Ʈ ȯ�濡�� �ַ� ���
                
�����͸� �����Ͽ� ���̺� ����(���� �غ���)

create table emp_copy as 
select *
from emp;

select *
from emp_copy;

emp_copy ���̺��� truncate ����� ���� ��� �����͸� ����
truncate table emp_copy;

select *
from emp_copy;

rollback;

Ʈ����� : ������ ���� ����
ex : ATM - ��ݰ� �Ա��� �Ѵ� ���������� �̷������ ������ �߻����� ����
            ����� ���� ó�� �Ǿ����� �Ա��� ������ ó�� �Ǿ��ٸ�
            ���� ó���� ��ݵ� ��Ҹ� ����� �Ѵ�
            
���
�Ա�(����)
rollback;

����Ŭ������ ù��° DML�� ������ �Ǹ� Ʈ���� �������� �ν�
Ʈ������� rollback, commit�� ���� ���ᰡ �ȴ�

Ʈ����� ���� �� ���ο� DML�� ����Ǹ� ���ο� Ʈ������� ����


��� ����ϴ� �Խ����� �����غ���
�Խñ� �Է��� �� �Է� �ϴ°� : ����(1��), ����(1��), ÷������(���� ����)
RDBMS������ �Ӽ��� �ߺ��� ��� ������ ����Ƽ(���̺�)�� �и��� �Ѵ�
�Խñ� ���̺�(����,����) / �Խñ� ÷������ ���̺�(÷�����Ͽ� ���� ����)

�Խñ��� �ϳ� ����� �ϴ���
�Խñ� ���̺��, �Խñ� ÷������ ���̺� �����͸� �űԷ� ����� �Ѵ�
insert into �Խñ� ���̺� (����, ����, �����, ����Ͻ�) values (....);
insert into �Խñ� ÷������ ���̺� (÷�����ϸ�, ÷�����ϻ�����) values (....);

�ΰ��� insert ������ �Խñ� ����� Ʈ����� ����
�� �ΰ��߿� �ϳ��� ������ ����� �Ϲ������� rollback�� ���� �� ���� insert ������ ���