NVL(expr1, expr2)
if expr1 == null        
    return expr2
else 
    return expr1
    
NVL2(expr1, expr2, expr3)
if expr1 != null
    return expr2
else 
    return expr3
    
---------------------------------------------------------    
NULLIF(expr1, expr2)
if expr1 == expr2
    return null
else
    return expr1
    
sal �÷��� ���� 3000�̸� null�� ����
select empno, ename, sal, nullif(sal,3000)
from emp;

------------------------------------------------------------
�������� : �Լ��� ������ ������ ������ ���� ����
          �������ڵ��� Ÿ���� �����ؾ���
          display("test"), display("test","test","test"...)
coalesce(expr1,expr2.....)

���ڵ��߿� ���� ���������� null�� �ƴ� ���� ���� ����
coalesce(expr1, expr2, expr3....)
if expr1 != null
    return expr1
else
    coalesce(expr2,expr3...)
    
mgr �÷� null
comm �÷� null

select empno,ename,comm,sal, coalesce(comm,sal)
from emp;
------------------------------------------
--fn4
select empno, ename, mgr, 
        nvl(mgr,9999) as mgr_n,
        nvl2(mgr,mgr,9999) as mgr_n_1,
        coalesce(mgr,9999) as mgr_n_2
from emp;

--fn5
select userid, usernm, reg_dt,
        nvl(reg_dt, sysdate) as n_reg_dt
from users
where userid != 'brown';
------------------------------------------
condition
���ǿ� ���� �÷� Ȥ�� ǥ������ �ٸ� ������ ��ü
java if; switch ���� ����
1. case ����
2. decode �Լ�

1. case
case
    when ��/������ �Ǻ��� �� �ִ� �� true ������ ��
    [when ��/������ �Ǻ��� �� �ִ� �� true ������ ��]
    [else ������ �� �Ǻ����� ���� when���� ���� ��� ����)]
end

emp ���̺� ��ϵ� �����鿡�� ���ʽ��� �߰������� ���� �� ����
�ش� ������ job�� salesman�� ��� sal���� 5% �λ�� �ݾ��� ���ʽ��� ����(ex:sal 100->105)
�ش� ������ job�� manager�� ��� sal���� 10% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� president�� ��� sal���� 20% �λ�� �ݾ��� ���ʽ��� ����
�׿� �������� sal��ŭ�� ����

select empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal * 1.05
        when job = 'MANAGER' then sal * 1.10
        when job = 'PRESIDENT' then sal * 1.20
        else sal * 1   
    end
from emp;

2. DECODE(expr1, search1, return1, search2, return2, search3, return3....[default])
    DECODE(expr1, 
            search1, return1, 
            search2, return2, 
            search3, return3....
            [default])
if expr == search1
    return return1
else if expr == search2
    return return2
else if expr == search3
    return return3
.....
else
    return default
    
--decode���� case�� �̰�����(�����ϰ�) ���� ����. but ���� ���� ���Ѵٸ� decode�� �ڵ嵵 ����ϰ� ����

select empno, ename, job, sal,
    decode(job, 'salesman', sal*1.05, 'manager', sal*1.10, 'president', sal*1.20, sal*1) as bonus
from emp;

--cond1
select empno, ename,
    decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPPERATIONS', 'DDIT') AS DNAME
FROM emp;

select empno, ename,
    case
        WHEN deptno = 10 then 'ACCOUNTING'
        WHEN deptno = 20 then 'RESRARCH'
        WHEN deptno = 30 then 'SALES'
        WHEN deptno = 40 then 'OPERATIONS'
        else 'DDIT'
    end as dname
from emp;

select empno, ename,
    decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPPERATIONS', 'DDIT') AS DNAME,
    case
        WHEN deptno = 10 then 'ACCOUNTING'
        WHEN deptno = 20 then 'RESRARCH'
        WHEN deptno = 30 then 'SALES'
        WHEN deptno = 40 then 'OPERATIONS'
        else 'DDIT'
    end as dname
from emp;
--------------------------------------------------------------------------------------------------
--cond2
(���� �⵵ ¦/Ȧ��, ������ ����⵵ ¦/Ȧ��)
(1,1)==> �����
(1,0)==>������
(0,1)==>������
(0,0)==>�����;

select empno, ename, hiredate, 
--mod(to_char(sysdate,'yyyy'),2) , mod(to_char(hiredate,'yyyy'),2), 
case
    when mod(to_char(sysdate,'yyyy'),2) = 1 and mod(to_char(hiredate,'yyyy'),2) =1 then '�ǰ����������'
    when mod(to_char(sysdate,'yyyy'),2) = 0 and mod(to_char(hiredate,'yyyy'),2) =0 then '�ǰ����������'
    when mod(to_char(sysdate,'yyyy'),2) = 1 and mod(to_char(hiredate,'yyyy'),2) =0 then '�ǰ�����������'
    when mod(to_char(sysdate,'yyyy'),2) = 0 and mod(to_char(hiredate,'yyyy'),2) =1 then '�ǰ�����������'
end contact_to_doctor
from emp;

select empno, ename, hiredate, 
--mod(to_char(sysdate,'yyyy'),2) , mod(to_char(hiredate,'yyyy'),2), 
case
    when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(hiredate,'yyyy'),2) then '�ǰ����������'
    else '������'
end contact_to_doctor
from emp;

--cond3
select userid, usernm, alias, reg_dt, 
    case
        when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(reg_dt,'yyyy'),2) then '�ǰ����������'
        when mod(to_char(sysdate,'yyyy'),2)!= mod(to_char(reg_dt,'yyyy'),2) then '�ǰ�����������'
        else '�ǰ�����������'
    end as contacttodoctor   
from users;
        
select userid, usernm, alias, reg_dt, 
    case
        when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(reg_dt,'yyyy'),2) then '�ǰ����������'
        else '�ǰ�����������'
    end as contacttodoctor   
from users;
        

