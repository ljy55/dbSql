SELECT * --��� �÷������� ��ȸ
FROM prod; --�����͸� ��ȸ�� ���̺� ���

--Ư�� �÷��� ���ؼ��� ��ȸ : SELECT �÷�1, �÷�2...
prod_id, prod_name�÷��� prod ���̺����� ��ȸ;

SELECT prod_id, prod_name
FROM prod;

select1]
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

SQL ���� : JAVA�� �ٸ��� ���� X, �Ϲ��� ��Ģ����
int b = 2; =���� ������, == ��;

SQL ������ Ÿ�� : ����, ����, ��¥(date);

USERS ���̺��� (4/14 ����� ����) ����
USERS ���̺��� ��� �����͸� ��ȸ;

��¥ Ÿ�Կ� ���� ���� : ��¥�� +, - ���� ����
date type + ���� : date���� ���� ��¥��ŭ �̷� ��¥�� �̵�
date type - ���� : date���� ���� ��¥��ŭ ���� ��¥�� �̵�

SELECT *
FROM USERS;

SELECT userid, reg_dt, reg_dt + 5 as after_5days, reg_dt -5
FROM USERS;

;
�÷� ��Ī : ���� �÷����� ���� �ϰ� ���� ��
syntax : ���� �÷��� [as] ��Ī��Ī
��Ī ��Ī�� ������ ǥ���Ǿ�� �� ��� ���� �����̼�("")���� ���´�
���� ����Ŭ������ ��ü���� �빮�� ó�� �ϱ� ������ �ҹ��ڷ� ��Ī�� �����ϱ� ���ؼ��� ���� �����̼��� ����Ѵ�

SELECT userid as id, userid id2, userid ���̵�, userid "�� �� ��"
FROM users;

select2]
SELECT prod_id as "id", prod_name as "name"
FROM prod;

SELECT lprod_gu as "gu", lprod_nm as "nm"
FROM lprod;

SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;

���ڿ� ����(���տ���) : || +' '   (���ڿ� ������ +�����ڰ� �ƴϴ�)
SELECT /*userid + 'test'*/ userid || 'test', reg_dt + 5, 'test', 15
FROM users;

�� / �̸� / ��
SELECT '�� ' || userid || ' ��'
FROM users;

SELECT userid, usernm, userid || usernm
FROM users;

SELECT userid || usernm as id_name
        CONCAT(userid, usernm) as concat_id_name
FROM users;

sel_con1]
user_tables : oracle �����ϴ� ���̺� ������ ��� �ִ� ���̺�(view) ==> data dictionary
SELECT table_name
FROM user_tables;

���ڿ� ���� ���ڿ� ���� ���ڿ�
SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

SELECT CONCAT('SELECT * FROM ', table_name, ';')
FROM user_tables;

���̺��� ���� �÷��� Ȯ��
1. tool(sql developer)�� ���� Ȯ��
    ���̺� - Ȯ���ϰ��� �ϴ� ���̺�
2. SELECT *
    FROM ���̺�
    �ϴ� ��ü ��ȸ --> ��� �÷��� ǥ��
3. DESC ���̺���
4. data dictionary : user_tab_colums

DESC emp;

SELECT *
FROM user_tab_columns;

���ݱ��� ��� SELECT ����
��ȸ�ϰ��� �ϴ� �÷� ��� : SELECT
��ȸ�� ���̺� ��� : FROM
��ȸ�� ���� �����ϴ� ������ ��� : WHERE
WHERE ���� ����� ������ ��(TRUE)�� �� ����� ��ȸ --�߿�

java�� �� ���� : a������ b������ ���� ������ �� ==
sql�� �� ���� : =
/*int a = 5;
int b = 2;
a�� b�� ���� ���� ���� Ư������ ����
if(a == b)*/ --�ڹ�

SELECT *
FROM users
WHERE userid = 'cony';


SELECT *
FROM users
WHERE userid = userid; --�׻� ��

SELECT *
FROM users
WHERE 1 = 1; --�׻� ��

SELECT *
FROM users
WHERE 1 = 2; --�׻� ����

'1234', 1234 --�� ���� �ٸ�(�� : ����,  ��: ����)

emp���̺� �÷��� ������ Ÿ���� Ȯ��;
DESC emp;

SELECT *
FROM emp;

emp : employee
empno : �����ȣ
ename : ����̸�
job : ����(��å)
mgr : �����(������)
hiredate : �Ի�����
sal : �޿�
comm : ������
deptno : �μ���ȣ

SELECT *
FROM dept;

emp ���̺����� ������ ���� �μ���ȣ�� 30������ ū �μ��� ���� ������ ��ȸ;
SELECT *
FROM emp
WHERE deptno > 30;

emp ���̺����� ������ ���� �μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ������ ��ȸ;
SELECT *
FROM emp
WHERE deptno >= 30;

!= �ٸ���
users ���̺����� ����� ���̵�(userid)�� brown�� �ƴ� ����ڸ� ��ȸ
SELECT *
FROM users
WHERE userid != 'brown';

SQL ���ͷ�
���� : 20, 30, 5, ...
���� : �̱� �����̼� : 'hello world"
��¥ : TO_DATE('��¥���ڿ�','��¥ ���ڿ��� ����');

1982�� 1�� 1�� ���Ŀ� �Ի��� ������ ��ȸ 
emp ���̺��� ���� : 14��
1982�� 1�� 1�� ���� �Ի��ڰ� : 3��
1982�� 1�� 1�� ���� �Ի��ڰ� : 11��

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
    hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');
    hiredate >= TO_DATE('1982.01.01', 'YYYY.MM.DD');