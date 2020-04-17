--지난 시간 복습 
SELECT 에서 연산 : 
    날짜 연산(+, -) : 날짜 + 정수 , -정수 : 날짜에서 + -정수를 한 과거 혹은 미래일자의 데이트 타입 변환
    정수 연산 : 수업시간에 다루진 않음
    문자열 연산 : 리터럴 = 표기방법
                    숫자 리터럴 : 숫자로 표현
                    문자 리터럴 : java : "문자열" / sql : 'sql'
                    
                    문자열 결합연산 : +가 아니라 || (java에서는 +)
                    날짜 : TO_DATE('날짜 문자열', '날짜 문자열에 대한 포맷')
                            TO_DATE('20200417', 'YYYYMMDD')
                            
WHERE : 기술한 조건을 만족하는 행만 조회 되도록 제한;

SELECT *
FROM users
WHERE userid = 'brown';

---------------------------------------------------------------------------------------------------------------------
sal값이 1000보다 크거나 같고, 2000보다 작거나 같은 직원만 조회 ==>BETWEEN AND;
비교대상 컬럼 / 값 BETWEEN 시작값 AND 종료값
시작값과 종료값의 위치를 바꾸면 정상 동작하지 않음

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

sal >=1000 AND sal <=2000

SELECT *
FROM emp
WHERE sal >= 1000 
 AND sal <= 2000;
 
--PPT (WHERE)문제1
 SELECT ename, hiredate
 FROM emp
 WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND 
                        TO_DATE('19821231', 'YYYYMMDD');

IN 연산자
컬럼|특정값 IN (값1,값2, ....)
컬럼이나 특정값이 괄호안에 값중에 하나라도 일치를 하면 TRUE

SELECT *
FROM emp
WHERE deptno IN (10,30);
==> deptno가 10이거나 30번인 직원 / deptno = 10 OR deptno = 30

SELECT *
FROM emp
WHERE deptno = 10
    OR deptno = 30;
 
--PPT (WHERE)문제3   

SELECT userid as "아이디", usernm as "이름", alias as "별명"
FROM users
WHERE userid IN('brown','cony','sally'); --'문자 리터럴 표기' 꼭꼭 기억하기!

------------------------------------------------------------------------------------------------------------
문자열 매칭 연산 : LIKE 연산 / JAVA : .startWith(prefix) / .endsWith(suffix)
마스킹 문자열 : % ~ 모든 문자열(공백 포함)
              _ ~ 어떤 문자열이든지 딱 하나의 문자 --잘안씀. 물론 쓰기는 씀
문자열의 일부가 맞으면 TRUE

컬럼|특정값 LIKE 패턴 문자열;

'cony' : cony인 문자열
'co%' : 문자열이 co로 시작하고 뒤에는 어떤 문자열이든 올 수 있는 문자열('co'를 포함한다)
'%co%': co를 포함하는 문자열
'co__' : co로 시작하고 뒤에 두개의 문자가 오는 문자열
'_on_' : 가운데 두글자가 on이고 앞 뒤로 어떤 문자열이든지 하나의 문자가 올 수 있는 문자열

직원 이름(ename)이 대문자 S로 시작하는 직원만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--PPT (WHERE)문제4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--PPT (WHERE)문제5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

NULL 비교
SQL 비교연산자 : =

MGR컬럼 값이 없는 모든 직원을 조회
SELECT *
FROM emp
WHERE mgr = NULL; --오류

*SQL에서 NULL 값을 비교할 경우 일반적인 비교연산자(=)를 사용 못하고 IS 연산자를 사용

SELECT *
FROM emp
WHERE mgr IS NULL;

값이 있는 상황에서 등가 비교 : =, !=(같지않다), <>(같지않다)
NULL : IS NULL , IS NOT NULL

emp테이블에서 mgr 컬럼 값이 NULL이 아닌 직원을 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--PPT (WHERE)문제6
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
--IN 연산자 사용시 NULL 주의할 것

--PPT (WHERE)문제7
SELECT *
FROM emp
WHERE job = 'SALESMAN' --job IN ('SALESMAN') 
    AND hiredate > TO_DATE('19810601','YYYYMMDD');
    
--PPT (WHERE)문제8
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
    
--PPT (WHERE)문제9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--PPT (WHERE)문제10
SELECT *
FROM emp
WHERE deptno IN (20,30)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--PPT (WHERE)문제11
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

--PPT (WHERE)문제12
SELECT *
FROM emp
WHERE job LIKE 'SA%'
    OR empno LIKE '78%';

SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno LIKE '78%'; --형변환이 일어남(숫자->문자)

--PPT (WHERE)문제13
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno BETWEEN 7800 AND 7899;
    
         --- empno = 78
            OR empno >= 780 AND empno < 790 
            OR empno >= 7800 AND empno < 7900
    
----------------------------------------------------------------------------------------------------------------
연산자 우선순위 : AND 와 OR 만 주의할것

--PPT (WHERE)문제14 : 문제모호
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR (empno BETWEEN 7800 AND 7899) --(empo >= 7800 AND empo < 7900)
    AND hiredate >= TO_DATE('19810601','YYYYMMDD');

---------------------------------------------------------------------------------------------------------------
table에는 조회, 저장시 순서가 없어(보장하지 않음)
==> 수학시간의 집합과 유사한 개념 -- 집합 : {a,b,c} = {a,c,b}

SQL에서는 데이터를 정렬하려면 별도의 구문이 필요
ORDER BY 컬럼명 [정렬형태], 컬럼명2....

정렬의 형태 : 오름차순(DEFAULT) - ASC, 내림차순 -DESC --형태를 지정하지 않으면 기본은 오름차순

직원 이름으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

SELECT *
FROM emp
ORDER BY ename;

직원 이름으로 내림차순 정렬
SELECT *
FROM emp
ORDER BY ename DESC;

job을 기준으로 오름차순 정렬하고 job이 같을경우 입사일자로 내림차순 정렬
SELECT *
FROM emp
ORDER BY job ASC, hiredate DESC; --=ORDER BY job, hiredate DESC; 
