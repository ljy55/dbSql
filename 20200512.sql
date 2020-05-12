explain plan for
select *
from emp
where empno = 7369;

select *
from table(dbms_xplan.display); -- 읽는 순서 2->1->0

----------------------------------------------------------------------------------------------------------------
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
---------------------------------------------------------------------------------------------------------------------

ROWID : 테이블 행이 저장된 물리주소 (java - 인스턴스 변수);

select rowid, emp.*
from emp;

사용자에 의한 ROWID 사용 --일케는 안씀
explain plan for
select *
from emp
where rowid = 'AAAE5xAAFAAAAETAAF';

select *
from table(dbms_xplan.display);
--------------------------------------------------------------------------------------------------------------
Plan hash value: 1116584662
 
-----------------------------------------------------------------------------------
| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT           |      |     1 |    99 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY USER ROWID| EMP  |     1 |    99 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
--index 실습
emp테이블에 어제 생성한 pk_emp primary key 제약조건을 삭제
alter table emp drop constraint pk_emp;

인덱스 없이 empno 값을 이용하여 데이터 조회
explain plan for
select *
from emp
where empno = 7782; 

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
--------------------------------------------------------------------------------------------------------------------
2. emp 테이블에 empno 컬럼으로 primary key 제약조건 생성 한 경우
    (empno 컬럼으로 생성된 unique 인덱스가 존재)
alter table emp add constraint pk_emp primary key (empno);
explain plan for
select *
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
--------------------------------------------------------------------------------------------------------------------
3. 2번 SQL을 변형(select 컬럼을 변형) 

2번
select *
from emp
where empno = 7782;

3번
explain plan for
select empno
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
-------------------------------------------------------------------------------------------------------------------
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |    13 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |    13 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
----------------------------------------------------------------------------------------------------------------------
4. empno컬럼에 non-unique 인덱스가 생성되어 있는 경우
alter table emp drop constraint pk_emp;
create index idx_emp_01 on emp (empno);

explain plan for
select *
from emp
where empno = 7782;

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------------
Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
---------------------------------------------------------------------------------------------------------------------
5. emp 테이블의 job 값이 일치하는 데이터를 찾고 싶을 때
보유 인덱스(4번에서 한거)
idx_emp_01 : empno

explain plan for
select *
from emp
where job = 'MANAGER';

select *
from table(dbms_xplan.display);
---------------------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
------------------------------------------------------------------------------------------------------------------
idx_emp_01의 경우 정렬이 empno컬럼 기준으로 되어 있기 떄문에 job 컬럼을 제한하는
SQL에서는 효과적으로 사용할 수가 없기 때문에 table 전체 접근하는 형태의 실행계획이 필요해짐

==>idx_emp_02(job) 생성을 한 후 실행계획 비교
create index idx_emp_02 on emp (job);

explain plan for
select *
from emp
where job = 'MANAGER';

select *
from table(dbms_xplan.display);
-----------------------------------------------------------------------------------------------------------------
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-----------------------------------------------------------------------------------------------------------------------
6. emp 테이블에서 job = 'MANAGER' 이면서 ename이 C로 시작하는 사원만 조회(전체컬럼 조회)
인덱스 현황
idx_emp_01 : empno
idx_emp_02 : job

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------------
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
----------------------------------------------------------------------------------------------------------------------
7. emp 테이블에서 job = 'MANAGER' 이면서 ename이 C로 시작하는 사원만 조회(전체컬럼 조회)
    단, 새로운 인덱스 추가 : idx_emp_03 : job, ename
create index idx_emp_03 on emp (job,ename);

인덱스 현황
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_03 : job, ename

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
----------------------------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
--------------------------------------------------------------------------------------------------------------------
8. emp 테이블에서 job = 'MANAGER' 이면서 ename이 C로 끝나는 사원만 조회(전체컬럼 조회)
    단, 새로운 인덱스 추가 : idx_emp_03 : job, ename

인덱스 현황
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_03 : job, ename

explain plan for
select /*+ index( emp idx_emp_03 )*/ * ==> /* */ : 힌트 주석 - 쓰는 걸 권장하지는 않음
from emp
where job = 'MANAGER' and ename like '%C';

select *
from table(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
------------------------------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-----------------------------------------------------------------------------------------------------------------------
rule based optimizer : 규칙기반 최적화기 (9i 버전까지) ==> 수동 카메라
cost based optimizer : 비용기반 최적화기 (10g 버전이후) ==> 자동 카메라
------------------------------------------------------------------------------------------------------------------------
9. 복합 컬럼 인덱스의 컬럼 순서의 중요성
인덱스 구성 컬럼 : (job, ename) VS (ename, job)
*** 실행해야 하는 sql에 따라서 인덱스 컬럼 순서를 조정해야 한다

실행 sql : job=manager, ename이 C로 시작하는 사원 정보를 조회(전체 컬럼)
기존 인덱스 삭제 : idx_emp_03;
drop index idx_emp_03;

인덱스 신규 생성
idx_emp_04 : ename, job
create index idx_emp_04 on emp (ename, job);

인덱스 현황
idx_emp_01 : empno
idx_emp_02 : job
idx_emp_04 : ename, job

explain plan for
select *
from emp
where job = 'MANAGER' and ename like 'C%';

select *
from table(dbms_xplan.display);
--------------------------------------------------------------------------------------------------------------
Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-------------------------------------------------------------------------------------------------------------------------
조인에서의 인덱스

idx_emp_01 삭제(pk_emp와 중복)
drop index idx_emp_01;

emp 테이블에 empno 컬럼을 primary key로 제약조건 생성
pk_emp : empno
alter table emp add constraint pk_emp primary key (empno); 

인덱스 현황
idx_emp_02 : job
idx_emp_04 : ename, job
pk_emp : empno

모든 직원에서 특정 직원으로 조건 제한 
explain plan for
select *
from emp, dept
where emp.deptno = dept.deptno
        and emp.empno = 7788;

select *
from table(dbms_xplan.display);

3-2-5-4-1-0
------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2385808155
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |   117 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |   117 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    87 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |   409 | 12270 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
-----------------------------------------------------------------------------------------------------------------------
nested loop join
hash join
sort merge join
