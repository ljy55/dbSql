--fn3
주어진것 : 년월을 담고있는 문자열 '201912' ==> 31
문자열     ==>        날짜 ==>   마지막 날짜로 변경 ==>   일자
/*SELECT to_char(to_date('201912','yyyymm'),'yyyymm') as param,
        to_char(last_day() as dt
FROM dual;

select sysdate, to_char(last_day(sysdate),'dd')
from dual;*/

select  to_date('201912','yyyymm') as param,
        to_char(last_day(to_date('201912','yyyymm')),'dd') as dt
from dual;

select to_date(:yyyymm, 'yyyymm'), 
        to_date(:yyyymm,'yyyymm') as param,
        to_char(last_day(to_date(:yyyymm,'yyyymm')),'dd')
from dual;
---------------------------------------------------------------------
--1-1번
explain plan for
select *
from emp
where empno = '7369';
      ("EMPNO"=7369)--7369가 문자에서 숫자로 형변환 됨

select *
from table(dbms_xplan.display);

--위에꺼 실행결과
Plan hash value: 3956160932
실행계획을 보는 순서(id)
* 들여쓰기 되어있으면 자식 오퍼레이션
1. 위에서 아래로 읽는다
    *단 자식 오퍼레이션이 있으면 자식 부터 읽는다
    id-> 1번 읽고->* 표시 : 1번에 대한 설명이 더 있음 그럼 그거 읽으러 ㄱㄱ -> 0번 읽고
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 | --자식(얘부터 읽음)
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)--숫자로 비교했다
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
------------------------------------------------------------------------
--1-2번
explain plan for
select *
from emp
where to_char(empno) = '7369';

select *
from table(dbms_xplan.display);

--위에꺼 실행결과
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')--문자로 비교했다
 
Note
-----
   - dynamic sampling used for this statement (level=2)

---------------------------------------------------------------------------------
explain plan for
select*
from emp
where empno = 7300 + '69';

select *
from table(dbms_xplan.display);

--위에꺼 실행결과
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)--숫자로 비교했다
 
Note
-----
   - dynamic sampling used for this statement (level=2)
-------------------------------------------------------------------
sql 개발자의 칠거지악 : 구글 검색
------------------------------------------------------------------
select *
from emp, dept;
------------------------------------------------------------------
국제화 : i18n
-----------------------------------------------------------------
select ename, sal, to_char(sal, 'L009,000.00')
from emp;
-----------------------------------------------------------------
왜 null 처리를 해야할까?
null에 대한 연산결과는 null이다

예를들어서 emp테이블에 존재하는 sal, comm 두개의 컬럼 값을 합한 값을 알고 싶어서 다음과 같이 sql을 작성
select empno, ename, sal, comm, sal + comm as sal_plus_com
from emp;

NVl(expr1, expr2)
expr1이 null이면 expr2값을 리턴하고
expr1이 null이 아니면 expr1을 리턴

select empno, ename, sal, comm, sal + nvl(comm, 0) as sal_plus_com
from emp;

reg_dt 컬럼이 null일 경우 현재 날짜의 속한 월의 마지막 일자로 표현
select userid, usernm, reg_dt, nvl(reg_dt,last_day(sysdate)) as reg_dt_plus
from users;