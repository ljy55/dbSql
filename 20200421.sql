����¡ ó��
    .ROWNUM
    .INLINE-VIEW(����Ŭ ����)
    .����¡ ����
    .���ε� ����
----------------------------------------------------------------------------------------
�Լ� : ������ ���ȭ �� �ڵ�
==> ���� ���(ȣ��)�ϴ� ���� �Լ��� �����Ǿ��ִ� �κ��� �и� ==> ���������� ���Ǽ��� ����
 �Լ��� ������� ���� ���
    ȣ���ϴ� �κп� �Լ� �ڵ带 ���� ����ؾ� �ϹǷ�, �ڵ尡 ������� ==> �������� ��������

����Ŭ �Լ��� ����
�Է� ���� : 
    . single row function
    . multi row fumction
    
������ ���� : 
 . ���� �Լ� : ����Ŭ���� �������ִ� �Լ�
 . ����� ���� �Լ� : �����ڰ� ���� ������ �Լ�(pl/sql ��� ��)
 ----------------------------------------------------------------------------------------
 ���α׷��־��, �ĺ��̸� �ο�....�߿��� ��Ģ
 
 DUAL TABLE
 
 SYS������ ���� �ִ� ���̺�
 ����Ŭ�� ��� ����ڰ� �������� ����� �� �ִ� ���̺�
 
 �Ѱ��� ��, �ϳ��� �÷�(dummy)-����'x';
 
 ��� �뵵
 1. �Լ��� �׽�Ʈ�� ����
 2.  merge ����
 3. ������ ����
 
 ����Ŭ ���� �Լ� �׽�Ʈ(��ҹ��� ����)
 LOWER, UPPER, INITCAP : ���ڷ� ���ڿ� �ϳ��� �޴´�;
 
 SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
 FROM dual;
 
 SELECT empno, 5, 'test', LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
 FROM emp;
 
 �Լ��� whrere�������� ����� �����ϴ�
 emp ���̺��� SMITH ����� �̸��� �빮�ڷ� ����Ǿ� ���� : �����Ͱ��� ��ҹ��ڸ� ������
 
 SELECT *
 FROM emp
 WHERE ename = 'smith'; ���̺��� ������ ���� �빮�ڷ� ����Ǿ� �����Ƿ� ��ȸ�Ǽ�0
 WHERE ename = 'SMITH'; ���� ����
 WHERE ename = UPPER ('smith'); �Ʒ� ��İ� ���� �Ʒ����ٴ� ���ݰ��� �� �ùٸ� ����̴�(smith�� �빮�ڷ�)
 WHERE UPPER(ename) = 'smith'; �̷������� �ۼ��ϸ� �ȵȴ�->�� ������ŭ ���� �� �ٲ����(�� �� ������ŭ �����)//�÷��� �ǵ帮�� ����,,
 -------------------------------------------------------------------------------------------------------
 ���ڿ� ���� �Լ�
 CONCAT : 2���� ���ڿ��� �Է����� �޾�, ������ ���ڿ��� ��ȯ�Ѵ�--(CONCAT('Hello','World'))->�� ��ü�� �ϳ��� ���ڿ��� �Ǵ°���
 
 SELECT CONCAT('start', 'end')
 FROM dual;
 
SELECT table_name, tablespace_name, CONCAT('start','end'),
        CONCAT(table_name, tablespace_name),
        'SELECT * FROM ' || table_name || ';' --CONCAT �Լ��� �ۼ��ϱ�(�� ||�� ������� �ʴ´�)
FROM user_tables;

SELECT table_name, tablespace_name, CONCAT('start','end'),
        CONCAT(table_name, tablespace_name),
        CONCAT(CONCAT('SELECT * FROM ',table_name),';') 
FROM user_tables;

SUBSTR(���ڿ�,���� �ε���,���� �ε���) : ���ڿ��� ���� �ε��� ���� ���� �ε��� ������ �κ� ���ڿ�
�����ε����� 1����(*java�� ���� 0����)

LENGTH(���ڿ�) : ���ڿ��� ���̸� ��ȯ

INSTR(���ڿ�,ã�� ���ڿ�,[�˻� ���� �ε���]) : ���ڿ����� ã�� ���ڿ��� �����ϴ���, ������ ��� ã�� ���ڿ��� �ε���(��ġ) ��ȯ

LPAD, RPAD(���ڿ�, ���߰� ���� ��ü ���ڿ� ����, [�е� ���ڿ�-�⺻ ���� ����])

REPLACE(���ڿ�, �˻��� ���ڿ�, ������ ���ڿ�) : ���ڿ����� �˻��� ���ڿ��� ã�� ������ ���ڿ��� ����

TRIM(���ڿ�) : ���ڿ� �� ���� �����ϴ� ������ ����, ���ڿ� �߰��� �ִ� ������ ���� ����� �ƴ�

SELECT SUBSTR('Hello, World', 1, 5) as  sub,
       LENGTH('Hello, World') as len,
       INSTR('Hello, World','o') as ins,
       INSTR('Hello, World','o',6) as ins2,
       INSTR('Hello, World','o',INSTR('Hello, World','o')+1) as ins3,
       LPAD('hello', 15, '*') as lp,
       RPAD('hello', 15, '*') as rp,       
       REPLACE('Hello, World', 'll', 'LL') as rep,
       TRIM('      He llo      ') as tr,
       TRIM('H' FROM 'Hello') as trr
FROM dual;
----------------------------------------------------------------------------------------------------
NUMBER ���� �Լ�
ROUND(����, [�ݿø� ��ġ-defalt 0]) : �ݿø�
 ROUND(105.54, 1) : �Ҽ��� ù��°�ڸ����� ����� ���� ==> �Ҽ��� �ι�° �ڸ����� �ݿø�
  : 105.5
TRUCK(����, [���� ��ġ-defalt 0]) : ����
MOD(������, ����) : ������ ����

SELECT  round(105.54, 1) as ro1,
        round(105.55, 1) as ro2,
        round(105.55, 0) as ro3,
        round(105.55, -1) as ro4
FROM dual;

SELECT  TRUNC(105.54, 1) as t1,
        TRUNC(105.55, 1) as t2,
        TRUNC(105.55, 0) as t3,
        TRUNC(105.55, -1) as t4
FROM dual;

select mod(10, 3), sal, mod(sal, 1000)
from emp;
-----------------------------------------------------------------------------------------------
��¥ ���� �Լ�
SYSDATE : ������� ����Ŭ �����ͺ��̽� ������ ���� �ð�, ��¥�� ��ȯ�Ѵ�
        �Լ������� ���ڰ� ���� �Լ�
        (���ڰ� ���� ��� JAVA : �޼ҵ�()
                        SQL : �Լ���)

date type +- ���� : ���� ���ϱ� ����
���� 1 = �Ϸ�
1/24 = �ѽð�
1/24/60 = �Ϻ�

���ͷ�
 ���� 
 ����:'' 
 ��¥:to_date('��¥ ���ڿ�','����')

SELECT SYSDATE
FROM dual;

--fn1        
select to_date('2019/12/31','yyyy/mm/dd') as lastday,
        to_date('2019/12/31','yyyy/mm/dd')-5 as lastday_before5,
        sysdate as now,
        sysdate -3 as now_before3
FROM dual;

TO_DATE(���ڿ�,����) : ���ڿ��� ���˿� �°� �ؼ��Ͽ� ��¥ Ÿ������ ����ȯ
TO_CHAR(��¥,����) : ��¥ Ÿ���� ���˿� �°� �ؼ��Ͽ� ���� Ÿ������ ����ȯ
YYYY : �⵵
MM : ��
DD : ����
D : �ְ�����(1~7, 1-�Ͽ���, 2-������....7-�����)
IN : ���� (52��~53��)
HH : �ð�(12�ð�)
HH24 : 24�ð� ǥ��
MI : ��
SS : ��

����ð�(SYSDATE) �ú��� �������� ǥ�� ==> TO_CHAR�� �̿��Ͽ� ����ȯ

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as now,
        TO_CHAR(SYSDATE, 'd') as d,
        TO_CHAR(SYSDATE -3, 'YYYY/MM/DD HH24:MI:SS') as now_before3,
        TO_CHAR(SYSDATE -1/24, 'YYYY/MM/DD HH24:MI:SS') as now_before3
from dual;

--fn2
select to_char(sysdate,'yyyy-mm-dd') as dt_dash,
        to_char(sysdate,'yyyy-mm-dd hh24-mi-ss')as dt_dash_wth_time,
        to_char(sysdate, 'dd-mm-yyyy') as dt_dd_mm_yyyy
from dual;
-----------------------------------------------------------------------------------------------------
months_between(date1,date2) : date1�� date2������ �������� ��ȯ
4���� ��¥ �����Լ��߿� ��� �󵵰� ����
select months_between (to_date('2020/04/21', 'yyyy/mm/dd'),to_date('2020/03/21', 'yyyy/mm/dd')) as a,
       months_between (to_date('2020/04/22', 'yyyy/mm/dd'),to_date('2020/03/21', 'yyyy/mm/dd')) as b
from dual;

add_months(date1,������ ���� ��) : date1�κ��� �ι�° �Էµ� ���� �� ��ŭ ������ date
���� ��¥�κ��� 5���� ��  ��¥
select add_months(sysdate, 5) as dt1,
       add_months(sysdate, -5) as dt2
from dual;

next_day(date1,�ְ�����) : date1 ���� �����ϴ� ù��° �ְ������� ��¥�� ��ȯ
select next_day(sysdate, 7)
from dual;

last_day(date1) : date1�� ���� ���� ������ ��¥�� ��ȯ
select last_day(sysdate)
from dual;

��¥�� ���� ���� ù��° ��¥ ���ϱ�(1��)
sysdate = 20200421==>20200401

select sysdate, last_day(sysdate), last_day(sysdate)+1, 
        add_months(last_day(sysdate)+1, -1)
from dual;

select to_date(to_char(sysdate,'yyyymm') || '01' , 'yyyymmdd')
from dual;


