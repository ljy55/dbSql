PL/SQL ==> PL/SQL�� �����ϴ� ���� ����Ŭ ��ü
            �ڵ� ��ü�� ����Ŭ�� ����(����Ŭ ��ü�ϱ�)
            ������ �ٲ� �Ϲ� ���α׷��� ���(java)�� ���� �� �ʿ䰡 ����

SQL ==> SQL ������ �Ϲ� ���� ����(java)
        ���� sql�� ���õ� ������ �ٲ�� java������ ������ ���ɼ��� ŭ

PL/SQL : Procedual Laguage / Structured Query Language
SQL : ������, ������ ����(�̺��ϰ� ����, CASE, DECODE..)

������ �ϴٺ��� � ���ǿ� ���� ��ȸ�ؾ��� ���̺� ��ü�� �ٲ�ų�, ������ ��ŵ�ϴ� ����
��ü���� �κ��� �ʿ� �� ���� ����

�������� : �ҵ��� 25%�� �ſ�ī�� + ���ݿ����� + üũī��� �Һ�
          �Һ�ݾ��� �ҵ��� 25%�� �ʰ��ϴ� �ݾ׿� ���ؼ�
          �ſ�ī��� ���� : 15%, ���ݿ������� 30%, üũī�� 30%�� �����ϴ� 
          ��, �����ݾ��� 300������ ���� �� ����
          ��, ���߱��뿡 ���� �߰������� 100������ ���� ���� �� �ְ�
          ��, ������忡 ���ݿ� ���ؼ��� �߰������� 100������ ���� ���� �� �ִ�;

DBMS�󿡼� ���Ͱ��� ������ ������ SQL�� �ۼ��ϴµ��� ������ ����(��������)
�Ϲ����� ���α׷��� ���� ����ϴ� ��������(if, case), �ݺ���(for, while), �������� Ȱ�� �� �� �ִ�
PL/SQL�� ����

���� ������
java =
pl/sql :=

java���� sysout ==> console�� ���
PL/SQL���� ����
SET SERVEROUTPUT ON; �α׸� �ܼ�â�� ��°����ϰԲ� �ϴ� ����

PL/SQL block�� �⺻����
DECLARE : ����� (���� ���� ����, ���� ����)
BEGIN : ����� (������ �����Ǵ� �κ�)
EXCEPTION : ���ܺ�(���ܰ� �߻� ���� �� CATCH�Ͽ� �ٸ� ������ �����ϴ� �κ�(java try-catch))

PL/SQL �͸�(�̸��� ����, ��ȸ��) ���

DECLARE
   /* JAVA : ����TYPE ������
    PL/SQL : ������ ����TYPE */
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
   /* dept ���̺��� 10�� �μ��� �ش��ϴ� �μ���ȣ, �μ����� DECLARE���� ������ �ΰ��� ������ ��� */

    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    /*java�� sysout*/
    /*System.out.println(v_deptno + "     " + v_dname);*/
    DBMS_OUTPUT.PUT_LINE(v_deptno || '  ' || v_dname);
END;
/

������ Ÿ�� ����
v_deptno, v_dname �ΰ��� ���� ���� ==> dept ���̺��� �÷� ���� �������� ����
                                 ==> dept ���̺��� �÷� ������ Ÿ�԰� �����ϰ� ���� �ϰ� ���� ��Ȳ
������ Ÿ���� ���� �������� �ʰ� ���̺��� �÷� Ÿ���� ���� �ϵ��� ���� �� �� �ִ�
==> ���̺� ������ �ٲ� pl/sql ��Ͽ� ����� ������ Ÿ���� �������� �ʾƵ� �ڵ����� ����ȴ�

���̺��.�÷���%TYPE;
DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || '  ' || v_dname);
END;
/

��¥�� �Է¹޾� ==> �� ȸ���� �����ϱ������� 5�ϵ��� ��¥�� �����ϴ� �Լ�
ȸ�縸�� Ư���� ������ �ʿ��� ��� �Լ��� ���� �� �ִ�

PROCEDURE : �̸��� ���� PL/SQL ���, ���ϰ��� ����
            ������ ���� ó�� �� �����͸� �ٸ� ���̺� �Է��ϴ� ����
            ����Ͻ� ������ ó�� �� �� ���
            ����Ŭ ��ü ==> ����Ŭ ������ ������ �ȴ�
            ������ �ִ� ������� ���ν��� �̸��� ���� ������ ����
            
CREATE OR  REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
--�����
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || '  ' || v_dname);
END;
/

���ν��� ���� ��� : EXEC ���ν����̸�;
EXEC printdept;

���ڰ� �ִ� printdept ����
EXEC printdept(20);

PL/SQL������ SELECT ������ �������� �� �����Ͱ� �Ѱ� �ȳ��� ��� NO_DATA_FOUND ���ܸ� ������

--�ǽ�PRO_1

CREATE OR  REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS

    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;

BEGIN
    SELECT ename, dname INTO v_ename, v_dname
    FROM dept, emp
    WHERE dept.deptno = emp.deptno
        AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(v_ename || '  ' || v_dname);
END;
/

EXEC printemp(7698);

--�ǽ�PRO_2

CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.deptno%TYPE, 
                                              p_dname IN dept_test.dname%TYPE, 
                                              p_loc IN dept_test.loc%TYPE ) IS

BEGIN
   INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc); 
    COMMIT;
END;
/

EXEC registdept_test (99, 'ddit', 'daejeon');

SELECT *
FROM dept_test;

--�ǽ�PRO_3 : ����

CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE, 
                                              p_dname IN dept_test.dname%TYPE, 
                                              p_loc IN dept_test.loc%TYPE ) IS

BEGIN
   UPDATE dept_test SET deptno = p_deptno, dname = p_dname, loc = p_loc
   WHERE deptno = p_deptno;
   
END;
/

EXEC UPDATEdept_test (99, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;


���պ���
��ȸ����� �÷��� �ϳ��� ������ ��� �۾� ���ŷӴ� ==> ���� ������ ����Ͽ� �������� �ؼ�

0. %TYPE : �÷�
1. %ROWTYPE : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ���� ���� Ÿ��
    (���� %TYPE - Ư�� ���̺��� �÷� Ÿ���� ����)
2. PL/SQL RECORD : ���� ������ �� �ִ� Ÿ��, �÷��� �����ڰ� ���� ���
                    ���̺��� ��� �÷��� ����ϴ°� �ƴ϶� �÷��� �Ϻθ� ����ϰ� ���� ��
3. PL/SQL TABLE TYPE : �������� ��, �÷��� ������ �� �ִ� Ÿ��

1. %ROWTYPE
�͸������ dept ���̺��� 10�� �μ������� ��ȸ�Ͽ� %ROWTYPE���� ������ ������ ������� �����ϰ�
DBMS_OUTPUT.PUT_LINE�� �̿��Ͽ� ���

DECLARE 
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' / ' || v_dept_row.dname || ' / ' || v_dept_row.loc);
END;
/

2. RECORD : ���� ������ �� �ִ� ����Ÿ��, �÷� ������ �����ڰ� ���� ������ �� �ִ�
dept���̺��� deptno, dname �ΰ� �÷��� ������� �����ϰ� ���� ��

DECLARE
    --deptno, dname �÷� �ΰ��� ���� ������ �� �ִ� TYPE�� ����
    TYPE dept_rec IS RECORD (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE);
    --���Ӱ� ���� Ÿ������ ������ ����(java�� �����ϸ� class�� ����� �ν��Ͻ� ����)
    v_dept_rec dept_rec;
BEGIN
    SELECT deptno, dname INTO v_dept_rec
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_rec.deptno || ' / ' || v_dept_rec.dname);
END;
/

�������� ������ �� ��
SELECT ����� �������̱� ������ �ϳ��� �� ������ ���� �� �ִ� ROWTYPE ��������
���� ���� ���� ���� ���� �߻�
==> ���� ���� ������ �� �ִ� TABLE TYPE ���
DECLARE 
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' / ' || v_dept_row.dname || ' / ' || v_dept_row.loc);
END;
/

TABLE TYPE : �������� ������ �� �ִ� Ÿ��
���� : TYPE Ÿ�Ը� IS TABLE OF �� Ÿ�� INDEX BY �ε����� Ÿ��;

dept���̺��� �� ������ ������ �� �ִ� ���̺� TYPE
    List<Dept> dept_tab = new ArrayList<Dept>();
    
    java���� �迭 �ε���
    int[] intArray = new int[50];
    intAttay[0]
    java������ �ε����� �翬�� ����
    
    intArrat["ù����"] = 50;
    System.out.ptintln(intArray("ù��°));
    
    PL/SQL������ �ΰ��� Ÿ���� ���� : ����(BINARY_INREGER), ���ڿ�(VARCHAR(2))
    
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER 
    
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER; 
    v_dept dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;
END;
/