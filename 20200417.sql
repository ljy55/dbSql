--���� �ð� ���� 
SELECT ���� ���� : 
    ��¥ ����(+, -) : ��¥ + ���� , -���� : ��¥���� + -������ �� ���� Ȥ�� �̷������� ����Ʈ Ÿ�� ��ȯ
    ���� ���� : �����ð��� �ٷ��� ����
    ���ڿ� ���� : ���ͷ� = ǥ����
                    ���� ���ͷ� : ���ڷ� ǥ��
                    ���� ���ͷ� : java : "���ڿ�" / sql : 'sql'
                    
                    ���ڿ� ���տ��� : +�� �ƴ϶� || (java������ +)
                    ��¥ : TO_DATE('��¥ ���ڿ�', '��¥ ���ڿ��� ���� ����')
                            TO_DATE('20200417', 'YYYYMMDD')
                            
WHERE : ����� ������ �����ϴ� �ุ ��ȸ �ǵ��� ����;

SELECT *
FROM users
WHERE userid = 'brown';

---------------------------------------------------------------------------------------------------------------------
sal���� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ������ ��ȸ ==>BETWEEN AND;
�񱳴�� �÷� / �� BETWEEN ���۰� AND ���ᰪ
���۰��� ���ᰪ�� ��ġ�� �ٲٸ� ���� �������� ����

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

sal >=1000 AND sal <=2000

SELECT *
FROM emp
WHERE sal >= 1000 
 AND sal <= 2000;
 
--PPT (WHERE)����1
 SELECT ename, hiredate
 FROM emp
 WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND 
                        TO_DATE('19821231', 'YYYYMMDD');

IN ������
�÷�|Ư���� IN (��1,��2, ....)
�÷��̳� Ư������ ��ȣ�ȿ� ���߿� �ϳ��� ��ġ�� �ϸ� TRUE

SELECT *
FROM emp
WHERE deptno IN (10,30);
==> deptno�� 10�̰ų� 30���� ���� / deptno = 10 OR deptno = 30

SELECT *
FROM emp
WHERE deptno = 10
    OR deptno = 30;
 
--PPT (WHERE)����3   

SELECT userid as "���̵�", usernm as "�̸�", alias as "����"
FROM users
WHERE userid IN('brown','cony','sally'); --'���� ���ͷ� ǥ��' ���� ����ϱ�!

------------------------------------------------------------------------------------------------------------
���ڿ� ��Ī ���� : LIKE ���� / JAVA : .startWith(prefix) / .endsWith(suffix)
����ŷ ���ڿ� : % ~ ��� ���ڿ�(���� ����)
              _ ~ � ���ڿ��̵��� �� �ϳ��� ���� --�߾Ⱦ�. ���� ����� ��
���ڿ��� �Ϻΰ� ������ TRUE

�÷�|Ư���� LIKE ���� ���ڿ�;

'cony' : cony�� ���ڿ�
'co%' : ���ڿ��� co�� �����ϰ� �ڿ��� � ���ڿ��̵� �� �� �ִ� ���ڿ�('co'�� �����Ѵ�)
'%co%': co�� �����ϴ� ���ڿ�
'co__' : co�� �����ϰ� �ڿ� �ΰ��� ���ڰ� ���� ���ڿ�
'_on_' : ��� �α��ڰ� on�̰� �� �ڷ� � ���ڿ��̵��� �ϳ��� ���ڰ� �� �� �ִ� ���ڿ�

���� �̸�(ename)�� �빮�� S�� �����ϴ� ������ ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--PPT (WHERE)����4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

--PPT (WHERE)����5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

NULL ��
SQL �񱳿����� : =

MGR�÷� ���� ���� ��� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr = NULL; --����

*SQL���� NULL ���� ���� ��� �Ϲ����� �񱳿�����(=)�� ��� ���ϰ� IS �����ڸ� ���

SELECT *
FROM emp
WHERE mgr IS NULL;

���� �ִ� ��Ȳ���� � �� : =, !=(�����ʴ�), <>(�����ʴ�)
NULL : IS NULL , IS NOT NULL

emp���̺��� mgr �÷� ���� NULL�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--PPT (WHERE)����6
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-------------------------------------------------------------------------------------------------------------------
SELECT *
FROM emp
WHERE mgr = 7698
    AND sal > 1000;

SELECT *
FROM emp
WHERE mgr = 7698
    OR sal > 1000;

-------------------------------------------------------------------------------------------------------------------    

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839) --WHERE (mgr != 7698 AND mgr != 7839)
        OR mgr IS NULL;
--IN ������ ���� NULL ������ ��

--PPT (WHERE)����7
SELECT *
FROM emp
WHERE job = 'SALESMAN' --job IN ('SALESMAN') 
    AND hiredate > TO_DATE('19810601','YYYYMMDD');
    
--PPT (WHERE)����8
SELECT *
FROM emp
WHERE deptno != 10 
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');
    
SELECT *
FROM emp
WHERE deptno <> 10
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');
    
SELECT *
FROM emp
WHERE (deptno = 20 OR deptno = 30)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');
    
--PPT (WHERE)����9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--PPT (WHERE)����10
SELECT *
FROM emp
WHERE deptno IN (20,30)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--PPT (WHERE)����11
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR hiredate >= TO_DATE('19810601','YYYYMMDD');

SELECT *
FROM emp
WHERE job IN ('SALESMAN')
    OR hiredate >= TO_DATE('19810601','YYYYMMDD');

SELECT *
FROM emp
WHERE job LIKE 'SA%'
    OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--PPT (WHERE)����12
SELECT *
FROM emp
WHERE job LIKE 'SA%'
    OR empno LIKE '78%';

SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno LIKE '78%'; --����ȯ�� �Ͼ(����->����)

--PPT (WHERE)����13
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno BETWEEN 7800 AND 7899;
    
         --- empno = 78
            OR empno >= 780 AND empno < 790 
            OR empno >= 7800 AND empno < 7900
    
----------------------------------------------------------------------------------------------------------------
������ �켱���� : AND �� OR �� �����Ұ�

--PPT (WHERE)����14 : ������ȣ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR (empno BETWEEN 7800 AND 7899) --(empo >= 7800 AND empo < 7900)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

---------------------------------------------------------------------------------------------------------------
table���� ��ȸ, ����� ������ ����(�������� ����)
==> ���нð��� ���հ� ������ ���� -- ���� : {a,b,c} = {a,c,b}

SQL������ �����͸� �����Ϸ��� ������ ������ �ʿ�
ORDER BY �÷��� [��������], �÷���2....

������ ���� : ��������(DEFAULT) - ASC, �������� -DESC --���¸� �������� ������ �⺻�� ��������

���� �̸����� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

SELECT *
FROM emp
ORDER BY ename;

���� �̸����� �������� ����
SELECT *
FROM emp
ORDER BY ename DESC;

job�� �������� �������� �����ϰ� job�� ������� �Ի����ڷ� �������� ����
SELECT *
FROM emp
ORDER BY job ASC, hiredate DESC; --=ORDER BY job, hiredate DESC; 
