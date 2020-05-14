실행계획 : SQL을 내부적으로 어떤 절차를 거쳐서 실행할지 로직을 작성
            * 계산하는데 비싼 연산 비용이 필요(시간)
            
2개의 테이블을 조인하는 SQL
2개의 테이블에 각각 인덱스가 5개가 있다면
가능한 실행계획 조합 몇개?? 테이블이 늘어날수록 경우의 수 굉장히 많아짐 ==> 짧은 시간안에 해내야 한다(응답을 빨리 해야하므로)

만약 동일한 SQL이 실행될 경우 기존에 작성된 실행계획이 존재할경우
새롭게 만들지 않고 재활용을 한다(리소스 절약)

테이블 접근 방법 : 테이블 전체(1), 각각의 인덱스(5)
a => b
b => a
경우의 수 : 36개 * 2 = 72개

select *
from emp;

동일한 SQL 이란 : SQL 문장의 대소문자 공백까지 일치하는 SQL
아래 두개의 sql을 서로 다른 SQL로 인식한다
SELECT * FROM emp;
select * FROM emp;

특정직원의 정보를 조회하고 싶은데 : 사번을 이용해서
select /* 202004_B */ *
FROM emp
WHERE empno = :empno;

--시스템 계정에서 실행된 쿼리들 조회
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%202004_B%';
------------------------------------------------------------------------------------------------------------------------
--hr 계정
select *
from YOON.v_emp;

YOON.v_emp ==> v_emp

synonym : 객체의 별칭을 생성해서 별칭을 통해 원본 객체를 사용(동의어)
문법 : create synonym 시노님 이름 for 대상 오브젝트;

YOON.v_emp ==> v_emp 시노님으로 생성

create synonym v_emp for YOON.v_emp;

v_emp를 통해 실제 객체인 YOON.v_emp를 사용할 수 있다

select *
from v_emp;
------------------------------------------------------------------------------------------------------------------------
SQL 카테고리
DML
DDL
DCL
TCL

Data Dictionary : 시스템 정보를 볼 수 있는 view, 오라클이 자체적으로 관리
category(접두어)
USER : 해당 사용자가 소유하고 있는 객체 목록
ALL : 해당 사용자 소유 + 권한을 부여받은 객체 목록
DBA : 모든 객체목록
V$ : 성능, 시스템 관련

select *
from user_tables;

select *
from ALL_tables;

select *
from DBA_tables; --시스템 계정에서 볼 수 있음

select *
from dictionary;
-------------------------------------------------------------------------------------------------------------------
Multiple insert : 여러건의 데이터를 동시에 입력하는 insert의 확장구문

1. unconditional insert : 동일한 값을 여러 테이블에 입력하는 경우 --좋은 방식x
문법 : 
    INSERT ALL
        INTO 테이블명
        [,INTO 테이블명]
    VALUES (...) | SELECT QUERY;

emp_test테이블을 이용하여 emp_test2 테이블 생성
create table emp_test2 as
select *
from emp_test
where 1 = 2; --데이터 복사x

empno, ename, deptno

emp_test, emp_test2 테이블에 동시에 입력
insert all
    into emp_test
    into emp_test2
select 9998, 'brown', 88 from dual 
union all
select 9997, 'brown', 88 from dual; 

select *
from emp_test;

select *
from emp_test2;

2. conditional insert : 조건에 따라 입력할 테이블을 결정

insert all
    when 조건....then 
        into 입력 테이블 values
    when 조건....then 
        into 입력 테이블2 values
    else
        inro 입력 테이블3 values
    
select 결과의 행의 값이 empno = 9998이면 emp_test에만 데이터를 입력
                                        그 외에는 emp_test2에 데이터를 입력
insert all
    when empno = 9998 then
        into emp_test values (empno, ename, deptno)
    else
        into emp_test2 (empno, deptno) values (empno, deptno)
select 9998 empno, 'brown' ename, 88 deptno from dual 
union all
select 9997, 'cony', 88 from dual;

rollback;

conditional insert (all) ==> first : 조건을 만족하는 첫번째 when절만 실행
insert first
    when empno <= 9998 then
        into emp_test values (empno, ename, deptno)
    when empno <= 9997 then
        into emp_test2 values (empno, ename, deptno)
select 9998 empno, 'brown' ename, 88 deptno from dual 
union all
select 9997, 'cony', 88 from dual;
----------------------------------------------------------------------------------------------------------------
MERGE : 하나의 데이터 셋을 다른 테이블로 데이터를 신규 입력, 또는 업데이트 하는 쿼리
문법 : 
meger into 머지 대상(emp_test)
using (다른 테이블 | view | subquery)
on (머지대상과 using 절의 연결 조건 기술)
when not matched then
    insert (컬럼1, 컬럼2...) values (value1, value2...)
when matched then
    update set 컬럼1 = value1, 컬럼2 = value12,

1. 다른 데이터로 부터 특정 테이블로 데이터를 머지 하는 경우
2.  key가 없을경우 insert
    key가 있을 때 update

emp테이블의 데이터를 emp_test 테이블로 통합
emp테이블에는 존재하고 emp_test테이블에는 존재하지 않는 직원을 신규입력
emp테이블에는 존재하고 emp_test테이블에는 존재하는 직원의 이름 변경

insert into emp_test values (7369, 'cony', 88); 

select *
from emp_test;

머지 전 가지고 있는 데이터
9999	brown	88
9998	brown	88
9997	cony	88
7369	cony	88

emp테이블의 14건의 데이터를 emp_test테이블에 동일한 empno가 존재하는지 검사해서
동일한 empno가 없으면 insert-empno, ename, 동일한 empno가 있으면 update-ename
merge into emp_test
using emp
on (emp_test.empno = emp.empno)
when not matched then
    insert (empno,ename) values (emp.empno, emp.ename)
when matched then
    update set ename = emp.ename;

머지 후 가지고 있는 데이터
9999	brown	88
9998	brown	88
9997	cony	88
7369	SMITH	88    --update
7499	ALLEN	null
7521	WARD	null
7566	JONES	null
7654	MARTIN	null
7698	BLAKE	null
7782	CLARK	null
7788	SCOTT	null
7839	KING	null
7844	TURNER	null
7876	ADAMS	null
7900	JAMES	null
7902	FORD	null
7934	MILLER	null

위의 시나리오는 하나의 테이블에서 다른 테이블로 머지하는 경우

9999번 사번으로 신규 입력하거나, 업데이트를 하고 싶을 때
(사용자가 9999번, james 사원을 등록하거나, 업데이트 하고싶을 때)
위의 경우는 테이블 ==> 다른 테이블로 머지
데이터를 ==> 틀정 테이블로 머지

이번에 하는 시나리오 : 데이터를 ==> 특정 테이블로 머지
(9999, james)

merge 구문을 사용하지 않으면

데이터 존재 유무를 위해 select 실행
select *
from emp_test
where empno=9999;

데이터가 있으면 => update
데이터가 없으면 => insert

merge into emp_test
using dual                      --dual테이블을 넣어준것은 문법상 뭔가 넣어야하는데 넣을것이 없어서 그냥 넣어준거임
    on (emp_test.empno = 9999)
when not matched then
    insert (empno, ename) values (9999, 'james')
when matched then
    update set ename = 'james';
    
select *
from emp_test;

merge into emp_test
using (Select 9999 eno, 'james' enm
        from dual) a                     --위에 쿼리에서 이부분 수정
    on (emp_test.empno = a.eno)
when not matched then
    insert (empno, ename) values (9999, 'james')
when matched then
    update set ename = 'james';
------------------------------------------------------------------------------------------------------------------------
report group function

emp테이블을 이용하여 부서번호별 직원의 급여 합과, 전체직원의 급여합을 조회하기 위헤
group by를 사용하는 두개의 SQL을 나눠서 하나로 합치는(union all) 작업을 실행 --union보다 union all을 쓰는게 맞다
--union 쿼리
select deptno, sum(sal)
from emp
group by deptno

union all

select null, sum(sal)
from emp;

--group by rollup 쿼리
select deptno, sum(sal)
from emp
group by rollup (deptno);


확장된 group by 3가지
1. group by rollup
문법 : group by rollup (컬럼, 컬럼2...)
목적 : 서브그룹을 만들어주는 용도
서브그룹 생성 방식 : rollup 절에 기술한 컬럼을 오른쪽에서부터 하나씩 제거하면서 서브그룹을 생성
생성된 서브그룹을 union한 결과를 반환

select job, deptno, sum(sal)  as sal
from emp
group by rollup (job, deptno);

서브그룹 : 1.group by job,deptno
            union
          2.group by job
            union
          3.전체행 group by

select job, deptno, sum(sal)  as sal
from emp
group by job, deptno

union all

select job, null, sum(sal)  as sal
from emp
group by job

union all

select null, null, sum(sal)  as sal
from emp;

서브그룹의 개수는 : rollup절에 기술한 컬럼 개수 +1;

