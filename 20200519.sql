--�ǽ� calendar1
SELECT to_char(dt,'mm') dt, sum(sales)
FROM sales
GROUP BY to_char(dt,'mm')
ORDER BY dt;

SELECT *
FROM sales;

SELECT  DECODE(dt,01,a) jan , DECODE(dt,02,a) feb, DECODE(dt,03,a) mar, 
       DECODE(dt,04,a) apr, DECODE(dt,05,a) may, DECODE(dt,06,a) jun 
FROM 
(SELECT to_char(dt,'mm') dt, sum(sales) a
FROM sales
GROUP BY to_char(dt,'mm')
ORDER BY dt);

SELECT  MIN(DECODE(dt,'01',a)) jan , MIN(DECODE(dt,'02',a)) feb, NVL(MIN(DECODE(dt,'03',a)),0) mar, 
       MIN(DECODE(dt,'04',a)) apr, MIN(DECODE(dt,'05',a)) may, MIN(DECODE(dt,'06',a)) jun 
FROM 
(SELECT to_char(dt,'mm') dt, sum(sales) a
FROM sales
GROUP BY to_char(dt,'mm')
ORDER BY dt);


--�ǽ� calendar2
SELECT TO_DATE('202004','YYYYMM') + (LEVEL +26), 
        TO_CHAR(TO_DATE('202004','YYYYMM') + (LEVEL +26), 'd'),
        TO_CHAR(TO_DATE('202004','YYYYMM') + (LEVEL +26), 'iw')
FROM dual
CONNECT BY LEVEL <= 35;

---------------------------------------------------------------------------------------------------------------------
SELECT deptno,  SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);

JOIN ������ ��
CROSS JOIN : ������ ���� �� ��...

�μ���ȣ��, ��ü �� �� SAL ���� ���ϴ� 3��° ���
SELECT DECODE(iv, 1, deptno, 2, null), SUM(sal)
FROM emp, (SELECT LEVEL iv
            FROM dual
            CONNECT BY LEVEL <= 2)
GROUP BY DECODE(iv, 1, deptno, 2, null)
ORDER BY 1;
----------------------------------------------------------------------------------------------------------------------
 ������ ����
 START WITH : ���� ������ ������ ���
 CONNECT BY : ����(��)�� ������� ǥ��
 
 XXȸ�����(�ֻ��� ���)���� ���� ��������� ���������� Ž���ϴ� ����Ŭ ������ ����
1. �������� ���� : XXȸ��
2. ������(��� ��) ����� ǥ��
    PRIOR ���� ���� �а� �ִ� ���� ǥ��
    �ƹ��͵� ������ ���� : ���� ������ ���� ���� ǥ��
    
SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�ǽ�h_2
SELECT LEVEL, deptcd,  LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

�����
������ : ��������

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

--�ǽ�h_3
SELECT LEVEL, deptcd,  LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

--�ǽ�h_4
SELECT (LPAD(' ', (LEVEL-1)*3) || s_id) AS s_id , value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

--�ǽ�h_5
SELECT (LPAD(' ', (LEVEL-1)*3) || org_cd) AS org_cd , no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd; --CONNECT BY parent_org_cd = PRIOR org_cd �̷��� �ᵵ ���� ����

CONNECT BY ���Ŀ� �̾ PRIOR�� ���� �ʾƵ� ��� ����
PRIOR�� ���� �а� �ִ� ���� ��Ī�ϴ� Ű����
----------------------------------------------------------------------------------------------------------------
Pruning branch : ���� ġ��
WHERE���� ������ ������� �� : ������ ������ ������ ���� �������� ����
CONNECT BY���� ������� �� : �����߿� ������ ����
�� ���̸� �� 
*�� ������ �������� FROM -> START WITH CONNECT BY -> WHERE�� ������ ó���ȴ�

1.WHERE���� ������ ����� ���
SELECT LEVEL, deptcd,  LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2.CONNECT BY���� ������ ����� ���
SELECT LEVEL, deptcd,  LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';
--------------------------------------------------------------------------------------------------------------------------
������ �������� ����� �� �ִ� Ư�� �Լ�
CONNECT_BY_ROOT(column) : �ش� �÷��� �ֻ��� �����͸� ��ȸ
SYS_CONNECT_BY_PATH(column, ������) : �ش� ���� ������� ���Ŀ� ���� column���� ǥ���ϰ� �����ڸ� ���� ����
CONNECT_BY_ISLEAF ���ڰ� ���� : �ش� ���� ������ ���̻� ���� ������ ������� (LEAF ���)
                                LEAF ��� : 1, NO LEAF ��� : 0

������
    -���
     -���
������
    -���
     -���

SELECT LEVEL lv, deptcd,  LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
        CONNECT_BY_ROOT(deptnm),
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-'),
        CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�ǽ� h6
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH seq = 1 OR seq = 2 OR seq = 4
CONNECT BY PRIOR seq = parent_seq;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq; --�� ������ �ƴ϶� �̰� �´� ��

--�ǽ� h7
������ ������ ���Ľ� ���� ������ �����ϸ鼭 ���� �ϴ� ����� ����
ORDER SIBLINGS BY

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC; --�߸��� ����. �̷��� �����ϸ� ���� ������ ��������

--�ǽ� h9
ALTER TABLE board_test ADD (gp_no NUMBER);

UPDATE board_test SET gp_no = 4
WHERE seq IN(4, 10, 11, 5, 8, 6, 7);

UPDATE board_test SET gp_no = 2
WHERE seq IN(2, 3);

UPDATE board_test SET gp_no = 1
WHERE seq IN(1, 9);

COMMIT;

SELECT gp_no, CONNECT_BY_ROOT(seq), seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY CONNECT_BY_ROOT(seq) DESC, seq ASC;  --CONNECT_BY_ROOT(seq) �̰� �Ἥ �ϸ� ��

select *
from board_test;
-------------------------------------------------------------------------------------------------------------------
��ü �����߿� ���� ���� �޿��� �޴� ����� �޿�����
�ٵ� �װ� ������??
���� ���� �޿��� �޴� ����� �̸�

/*SELECT emp.ename
FROM emp,
    (SELECT MAX(sal) sal
    FROM emp) a
WHERE emp.sal = a.sal;*/

emp���̺��� 2�� �о ������ �޼� ==> ���� �� ȿ������ ����� ������? ==> WINDOW / ANALYSIS
SELECT ename
FROM emp
WHERE sal = (SELECT MAX(sal) 
            FROM emp);


SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

-----
SELECT s.ename, s.sal, s.deptno, g.lv sal_rank
FROM
(SELECT ROWNUM w, m.*
FROM 
(SELECT a.*, b.lv
FROM
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno)a, (SELECT LEVEL lv
                    FROM dual
                    CONNECT BY LEVEL <=6) b
WHERE a.cnt >= lv
ORDER BY a.deptno, b.lv) m)g,

(SELECT ROWNUM q, n.*
FROM
(SELECT *
FROM emp
ORDER BY deptno, sal DESC)n) s
WHERE g.w = s.q;