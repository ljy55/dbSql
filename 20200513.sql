--index �ǽ�1
create table dept_test2 as
select *
from dept
where 1 = 1; --���⼭ where���� �ᵵ�ǰ� �Ƚᵵ ��

select *
from dept_test2;

create UNIQUE index idx_u_dept_test2_01 on dept_test2 (deptno);
create index idx_u_dept_test2_02 on dept_test2 (dname);
create index idx_u_dept_test2_03 on dept_test2 (deptno, dname);

--index �ǽ�2
drop index idx_u_dept_test2_01;
drop index idx_u_dept_test2_02;
drop index idx_u_dept_test2_03;

--index �ǽ�3
--equals ������ �Ϲ������δ� ������������ ���°� ����(����� ����(�������� ��)�� ����ؾ���)
1]
empno(=)
2]
deptno(=)
3]
ename(=)
4]
deptno(=), mgr=empno
5]
deptno(=), empno(like :empno || '%')
6]
deptno(=), hiredate(=)

create UNIQUE index idx_u_emp_01 on emp (empno);
create index idx_emp_02 on emp (deptno, mgr, hiredate, sal);
create index idx_emp_03 on emp (ename);
-----------------------------------------------------------------------------------------------------------
�����ȹ

�����ð��� ��� ����
==>���� ���� ���¸� �̾߱� ��, ������� �̾߱Ⱑ �ƴ�
inner join : ���ο� �����ϴ� �����͸� ��ȸ�ϴ� ���� ���
null = '7698'
outer join : ���ο� �����ص� ������ �Ǵ� ���̺��� �÷������� ��ȸ�ϴ� ���� ���
cross join : ������ ����(īƼ�� ������Ʈ), ���� ������ ������� �ʾƼ� ���� ������ ��� ����� ���� ���εǴ� ���
self join : ���� ���̺��� ���� �ϴ� ����

�����ڰ� DBMS�� SQL�� ���� ��û �ϸ� DBMS�� SQL�� �м��ؼ�
��� �� ���̺� ���������� ����,3���� ����� ���� ���(������ ���� ���, ������� �̾߱�)
1. Nested Loop Join : ���� ����, �ҷ��� ������, ã�� ���� ���
2. Sort Merge Join : �뷮�� ������, ������ ������ ���(���� ����)
3. Hash Join : �뷮�� ������, ���� ���̺��� �Ǽ��� ������ ���� ������ ���� ���, �ݵ�� ���� ������ =


OLTP(OnLine Transaction Processing) : �ǽð� ó�� 
                                      ==> ������ ����� �ϴ� �ý���(�Ϲ����� �� ����)
OLAP(OnLine Analysis Processing) : �ϰ� ó�� 
                                    ==> ��ü ó�� �ӵ��� �߿��� ���(���� ���� ��� -> ���� �ѹ��� ���)

