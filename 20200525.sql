--�ǽ� PRO_4
cycle ���̺�(��������)�� �̿��Ͽ� daily(�Ͻ���) ���̺� �����͸� ���� ���ִ� ���ν���
����� �Ѻ��� �����ϴ� �� 2~300��
���Ѹ�� ��ǰ�� 2~3�� ���� ����
�Ͻ��� (�Ѵ� 20���� ������) 8,000~12,000�� ������ ������

cycle ���̺�
cid, pid, day, cnt
1    100    2   1   :1�� ���� 100�� ��ǰ�� �����ϳ� 1�� �Դ´�

sales ���̺�
cid, pid, dt, cnt
1    100  2020/05/04   1   :1�� ���� 100�� ��ǰ�� 2020/05/04(������) 1�� �Դ´�
1    100  2020/05/11   1   :1�� ���� 100�� ��ǰ�� 2020/05/11(������) 1�� �Դ´�
1    100  2020/05/18   1   :1�� ���� 100�� ��ǰ�� 2020/05/18(������) 1�� �Դ´�
1    100  2020/05/25   1   :1�� ���� 100�� ��ǰ�� 2020/05/25(������) 1�� �Դ´�

SELECT *
FROM cycle;

SELECT *
FROM daily;

2020�� 5���� ���� ��¥, ���� ������ ���� ���̺� ����

'202005' ==> :yyyymm
SELECT TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') DT,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')),'DD');
----
CREATE OR REPLACE PROCEDURE create_daily_sales (p_yyyymm IN VARCHAR) IS
    --�����ֱ� Ŀ��
    CURSOR cycle_cur IS
        SELECT *
        FROM cycle;
        
    --�޷� ���̺��� ���� ����(�������� ��, ���� Ư�� ���̺� ���ϴ� ��찡 �ƴ�)
    TYPE cal_rec_type IS RECORD(
        dt VARCHAR2(8),
    d VARCHAR2(1)
    );
    
    TYPE cal_rec_tab_type IS TABLE OF cal_rec_type INDEX BY BINARY_INTEGER;
    cal_rec_tab cal_rec_tab_type;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') DT,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
           BULK COLLECT INTO cal_rec_tab
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')),'DD');
    
    --���� ���࿡ ���ؼ� ������ �����ʹ� �����Ѵ�(���� ������)
    DELETE daily
    WHERE dt BETWEEN TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM'),'YYYYMMDD') AND
                     TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')),'YYYYMMDD');
    
    --Ŀ���� ������ ���鼭(OUTER LOOP) �ش� ���� �������������� ��ġ�ϴ� �޷����̺�(INNER LOOP)�� ���ڸ� ã�Ƽ�
    --��ġ�� ��� SALES ���̺� ����
    
    FOR cycle_row IN cycle_cur LOOP
        FOR i IN  1..cal_rec_tab.COUNT LOOP
        --���� ���� �����ֱ� ���ϰ� �޷��� ������ ���� ��
            IF cycle_row.day = cal_rec_tab(i).d THEN
                INSERT INTO daily VALUES (cycle_row.cid, 
                                          cycle_row.pid, 
                                          cal_rec_tab(i).dt, 
                                          cycle_row.cnt); 
            END IF;
        END LOOP;
    END LOOP;
    COMMIT;
END;
/

EXEC create_daily_sales('202005');

SELECT *
FROM daily;

SELECT *
FROM cycle
WHERE cid = 1
    AND pid = 100; ��, ��, ��

SELECT *
FROM daily
WHERE cid = 1
    AND pid = 100;

--���� PL/SQL�� §�� SQL�� one query(�̰� �ӵ����鿡�� �ξ� ����)
INSERT INTO daily;
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle,
(SELECT TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') DT,
           TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')),'DD')) cal
WHERE cycle.day = cal.d;

--------------------------------------------------------------------------------------------------------
EXCEPTION 

DECLARE
    v_ename emp. ename%TYPE;
BEGIN
    --���� ����� �������ε� ������ ��Į�� ���� ==> ���̺� Ÿ���� ������ �����ؾ� �Ѵ�
    SELECT ename INTO v_ename
    FROM emp;
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
END;
/

����� ���� ���� : ����Ŭ���� ������ ���ܰ� �ƴ϶� �����ڰ� ���� ������ ����
java������ �ݵ�� ó���� �ؾ��ϴ� ���ܸ� ��Ƽ� �ش� ȸ�糪 �����ڰ� ������ ���ܷ� �ٲپ ó���� �� �ִ�
mybatis���� ORM(Object Relation Mapping) �����ӿ�ũ������ jdbc ���α׷��ֿ��� �ݵ�� ���� �ϴ�
SQLException (checked exception)�� ���� ���Ǹ� ���� �����ӿ�ũ���� ������ ���ܷ� ġȯ�Ͽ� ����Ѵ�

SELECT ����� ���� �� ==> NO_DATA_FOUND

�Ʒ� ������ Ư�� ������ ��ȸ�ϱ� ���� ����
���࿡ �ش��ϴ� �����Ͱ� ���� �� NO_DATA_FOUND 
                              ==> NO_EMP ������ ���� ���ܷ� ġȯ�Ͽ� �ǹ̻����� ���� ��Ȯ�ϰ� ǥ��
SELECT *
FROM emp
WHERE empno = :empno;

DECLARE
    --����� ���� ����
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = 9999;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --NO_EMP���ܷ� ġȯ�Ͽ� ���ܸ� ������
            RAISE NO_EMP; --java�� throw new Exception();
    END;
EXCEPTION
    WHEN NO_EMP THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/
----------------------------------------------------------------------------------------------
function : ���ϰ��� �ִ� pl/sql ��
��� ��ȣ�� �Է¹޾� �ش����� �̸��� �����ϴ� function : getEmpName ����

CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;

--�ǽ� function1
CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT deptno, dname, getDeptName(deptno)
FROM dept;

--�ǽ� function2
�Լ��� ���鶧 � ���ڰ� �ʿ�����,
���������� ���踦 ���� �� � ������ �߻��ϴ���
SELECT deptcd, LPAD(' ', (LEVEL - 1) *4, ' ') || deptnm deptnm
SELECT deptcd, INDENT(LEVEL, '*') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

CREATE OR REPLACE FUNCTION INDENT (lv NUMBER, padString VARCHAR2) RETURN VARCHAR2 IS
    indent_string VARCHAR2(50) := '';
BEGIN
    SELECT LPAD(' ', (lv - 1) *4, padString) INTO indent_string 
    FROM dual;
    
    RETURN indent_string;
END;
/