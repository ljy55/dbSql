���ν����� ����

����
�ϳ��� ���� ���� ������ �� �ִ� ����(String)
����ü�� ������ �� �ִ� ����(Map, Class)
�������� ������ �� �ִ� ����(List<Map>.List<Class>)

DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER; 
    v_dept dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;
    
--    java : for
--    int[] arr = new int[20]();
--    for(int i = 0;, i < arr.length; i++){
--        System.out.println(arr[i]);
--    }
    FOR i IN 1..v_dept.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno || ' / ' || v_dept(i).dname || ' / ' || v_dept(i).loc);
    END LOOP;
END;
/

��������
IF ����
IF condition THEN
    statement;
ELSIF condition THEN
    statement;
ELSE 
    statement;
END IF;

NUMBER Ÿ���� p ������ �����ϰ� 2�� ����
IF ������ ���� p���� üũ�Ͽ� ����ϴ� ����

DECLARE
    p NUMBER := 2;  --java : int p = 2
BEGIN
   /* p�� 1�̸� 1�� ���
    p�� 2�̸� 2�� ���
    �׹��� ���� ���� else�� ���*/
    
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('else');
    END IF;
END;
/

CASE ����
�˻� ���̽�(java switch)
����
    CASE ǥ����
        WHEN VALUE THEN 
            statement;
        WHEN VALUE2 THEN 
            statement;
        ELSE
            statement;
    END CASE;
�Ϲ� ���̽� : �Ϲ� ����� IF ����, SQL���� ����� CASE ������ ����, CASE - END CASE;
    CASE
        WHEN expression THEN
            statement;
        WHEN expression2 THEN
            statement;
        ELSE
            statement;
    END CASE;
���̽� ǥ����
    CASE
        WHEN expression THEN
            ��ȯ�Ұ�
        WHEN expression2 THEN
            ��ȯ�Ұ�
        ELSE
            ��ȯ�Ұ�
    END;

�˻� ���̽�
DECLARE
    p NUMBER := 2;
BEGIN
--  java switch
    CASE p
    WHEN 1 THEN
        DBMS_OUTPUT.PUT_LINE('1');
    WHEN 2 THEN
        DBMS_OUTPUT.PUT_LINE('2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('else');
    END CASE;
END;
/

�Ϲ� ���̽�
DECLARE
    p NUMBER := 2;
BEGIN
    CASE 
    WHEN P = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1');
    WHEN P = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('else');
    END CASE;
END;
/

���̽� ǥ����
DECLARE
    p NUMBER := 2;
    ret NUMBER := 0;
BEGIN
        ret := CASE 
            WHEN P = 1 THEN
                4
            WHEN P = 2 THEN
                5
            ELSE
                6
        END;
    DBMS_OUTPUT.PUT_LINE(ret);
END;
/  

�ݺ���
�ε��������� �����ڰ� ������ �������� �ʴ´�
REVERSE �ɼ��� ����ϸ� ���ᰪ���� ���� 1�� �ٿ������� �ε��������� ���۰��� �ɶ����� ����
FOR( int = 10; i > 0; i--)

FOR �ε������� IN [REVERSE] ���۰�..���ᰪ LOOP
END LOOP;

1���� 5���� �ݺ����� �̿��Ͽ� ���
DECLARE
BEGIN
    FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

2~9�� ������ ����ϱ�
DECLARE
BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE( i || '*' || j || '=' || i*j);
        END LOOP;
    END LOOP;
END;
/

java �ݺ��� ���� : for(���� for), while, do-while

while
����
WHILE condition LOOP
    statment;
END LOOP;

DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
/

LOOP
java : while(true){
            if(condition){
                break;
            }
        }
����
LOOP
    statement;
    EXIT WHEN condition;
    statment;
END LOOP;

DECLARE
    i NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
/
----------------------------------------------------------------------------------------------------------------------
������� �߿��Ѱ�
CURSOR : SELECT���� ���� ����� �����͸� ����Ű�� ������(�޸�)
SQL�� ����ڰ� DBMS�� ��û�� ������ �� ó�� ����
1. ������ SQL�� ����� ���� �ִ��� Ȯ��(�����ȹ�� �����ϱ� ���ؼ�)
2. ���ε� ��������(���ε� ������ ���Ǿ��� ���)
3. ����(execution)
4. ����(fetch)

cursor�� ����ϰ� �Ǹ� ����ܰ踦 �����
==> SELECT ������ ����� ������ ���� �ʰ� CURSOR�� ���� ���� �޸𸮿� ������ �� �ִ�

PL/SQL�� ��κ��� ������ SELECT ����� Ư�� ������ �����Ͽ� ó�� �ϴ� ���̱� ������
������ ������ SELECT ����� ��� ���� ���ո����� �� �ִ�

cursor�� ����
������ : ������ �̸��� �ο����� �ʰ� ������ DML ����
����� : �����ڰ� �̸��� �ο��� CURSOR

CURSOR�� ����ó�� ���� ==> DECLARE

CURSOR ���ܰ�
1. ����
2. ����(OPEN)
3. ����(FETCH)
4. �ݱ�(CLOSE)

����
1. ���� (DECLARE ��)
    CURSOR Ŀ���̸� IS
        QUERY;
2. ���� (BEGIN)
    OPEN Ŀ���̸�;
3. ����(BEGIN)
    FETCH Ŀ���̸� INTO variable;
4. �ݱ� (BEGIN)
    CLOSEE Ŀ���̸�;

dept ���̺��� ��� ���� ��ȸ�ϰ�, deptno, dname �÷��� Ŀ���� ���ؼ�
��Į�� ����(v_deptno, v_dname)

�������� ��ȸ�ϴ� SELECT ������ ������� �����ϱ� ���ؼ� TABLE TYPE�� ���

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR deptcursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN deptcursor;
    LOOP
        FETCH deptcursor INTO v_deptno, v_dname;
        
        EXIT WHEN deptcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' / ' || v_dname);
    END LOOP;
    CLOSE deptcursor;
END;
/

����� Ŀ���� FOR LOOP ���� ==> ���� ����ϱ� ���� ����
OPEN, CLOSE, FETCH �ϴ� ������ FOR LOOP���� �ڵ������� �������ش�
�����ڴ� Ŀ�� ����� FRO LOOP�� Ŀ������ �־��ִ� �ɷ� ������ �ܼ�ȭ

���� --�̰Ŵ� �˾Ƶα�
FOR ���ڵ��̸�(�� ������ ����) IN Ŀ���̸� LOOP
    ���ڵ��̸�.�÷������� �÷� ���� ����
END FOR;

DECLARE
     CURSOR deptcursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN deptcursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/

�Ķ���Ͱ� �ִ� ����� Ŀ��
�μ� ��ȣ�� �Է¹޾� WHERE������ ����ϴ� Ŀ���� ����

DECLARE
     CURSOR deptcursor (p_deptno dept.deptno%TYPE ) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;
BEGIN
    FOR rec IN deptcursor(30) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/

FOR LOOP�� �ζ���(�������) Ŀ��
DECLARE���� Ŀ���� ��������� �������� �ʰ�
FOR LOOP���� SQL�� ���� ���

DECLARE
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/

--�ǽ� PRO_3
SELECT *
FROM dt;

CREATE TABLE dt2 AS
SELECT 40 n FROM dual UNION ALL
SELECT 35 FROM dual UNION ALL
SELECT 30 FROM dual UNION ALL
SELECT 25 FROM dual UNION ALL
SELECT 20 FROM dual UNION ALL
SELECT 15 FROM dual UNION ALL
SELECT 10 FROM dual UNION ALL
SELECT 5 FROM dual;

SELECT *
FROM dt2;

--1.Ŀ���� �̿��ؼ�
CREATE OR REPLACE PROCEDURE pro_3_dt2 IS
    CURSOR dt2_cursor IS
        SELECT *
        FROM dt2
        ORDER BY n DESC;
        
    sumValue NUMBER :=0;
    countValue NUMBER :=0;
    lastValue NUMBER :=0;
BEGIN
    FOR dt2row IN dt2_cursor LOOP
        IF countValue = 0 THEN
            lastValue := dt2row.n;
        ELSE
            sumValue := sumValue + lastValue - dt2row.n;
            lastValue := dt2row.n;
        END IF;
        
        countValue := countValue + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(sumValue);
    DBMS_OUTPUT.PUT_LINE((countValue-1));
    DBMS_OUTPUT.PUT_LINE(sumValue / (countValue-1));
END;
/

EXEC pro_3_dt2;

--java �Ϲ� FOR������
CREATE OR REPLACE PROCEDURE pro_3_dt2_table IS
    TYPE dt2_table IS TABLE OF dt2%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt2_table dt2_table;
        
    sumValue NUMBER :=0;
    
BEGIN
    SELECT * BULK COLLECT INTO v_dt2_table
    FROM dt2
    ORDER BY n DESC;
    
    FOR i IN 1..v_dt2_table.COUNT-1 LOOP
            sumValue := sumValue + v_dt2_table(i).n - v_dt2_table(i+1).n;
            
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(sumValue);
    DBMS_OUTPUT.PUT_LINE(sumValue / (v_dt2_table.COUNT-1));
END;
/

EXEC pro_3_dt2_table;

PL/SQL : ȣ��ȣ�� ���� ����
        �и��� �ʿ��� ���� ����(������ �����ϰ� ��ټ��� �κ��� �����Ϳ� ���õǾ��� ��)
�׷��� ���� ���� ��κ� �䱸������ SQL�� �ذ��� ����

�� ���� ��� ȭ�鿡 ��Ÿ������ �ϴ°� ������ ��հ� : 5
PL/SQL, SQL�� ����ϵ� 5��� ���� ����� ���� ������ �޼�.

SQL�� ������ Ǯ�����
1] �м��Լ�
SELECT AVG(diff)
FROM
(SELECT n - LEAD(n) OVER (ORDER BY n DESC) diff
FROM dt2);

2]����
SELECT AVG(a.n - b.n)
FROM 
 (SELECT ROWNUM rn, n
 FROM 
    (SELECT n
    FROM dt2
    ORDER BY n DESC)) a,
 (SELECT ROWNUM rn, n
 FROM 
    (SELECT n
    FROM dt2
    ORDER BY n DESC)) b
WHERE b.rn = a.rn + 1;

3]�����Լ�
SELECT (MAX(n) - MIN(n)) / (COUNT(*) - 1)
FROM dt2;