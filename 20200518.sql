서브그룹 생성 방식
rollup : 뒤에서(오른쪽에서) 하나씩 지워가면서 서브그룹을 생성
cube : 가능한 모든 조합
grouping sets : 개발자가 서브그룹 기준을 직접 기술
---------------------------------------------------------------------------------------------------
--sub_a2
drop table dept_test;


create table dept_test as
select *
from dept;

insert into dept_test values (99, 'it1', 'daejeon');
insert into dept_test values (98, 'it2', 'daejeon');

delete dept_test 
where not exists (select 'X'
                 from emp
                 where emp.deptno = dept_test.deptno);

rollback;
-------------------------------------------------------------------------------------------------------------
--sub_a3
select *
from emp_test,
(select deptno, avg(sal)
from emp_test e
group by deptno)a
where emp_test.deptno = a.deptno;

update emp_test set sal = sal + 200
where sal < (select avg(sal)
            from emp_test a
            where emp_test.deptno = a.deptno
            group by deptno);
----------------------------------------------------------------------------------------------------------------            
공식용어는 아니지만, 검색-도서에 자주 나오는 표현
서브쿼리의 사용된 방법
1. 확인자 : 상호연관 서브쿼리(exists)
            ==> 메인쿼리부터 실행 ==> 서브쿼리 실행
2. 공급자 : 서브쿼리가 먼저 실행되서 메인쿼리에 값을 공급해주는 역할
13건 : 매니저가 존재하는 직원을 조회
select *
from emp
where mgr in (select empno
              from emp);
-----------------------------------------------------------------------------------------------------------------
부서별 평균급여(소수점 둘째자리까지)
select deptno, round(avg(sal),2)
from emp
group by deptno;

전체 급여 평균
select round(avg(sal),2)
from emp;

부서별 급여평균이 전체 급여평균보다 큰 부서의 부서번호, 부서별 급여평균 구하기
select deptno, round(avg(sal),2)
from emp
group by deptno
having round(avg(sal),2) > (select round(avg(sal),2)
                           from emp);


with 절 : SQL에서 반복적으로 나오는 QUERY BLOCK(SUBQUERY)을 별도로 선언하여
          SQL 실행시 한번만 메모리에 로딩을 하고 반복적으로 사용할 때 메모리 공간의 데이터를
          활용하여 속도 개선을 할 수 있는 KEYWORD
          단, 하나의 SQL에서 반복적인 SQL 블락이 나온느 것은 잘못 작성한 SQL일 가능성이 높기 때문에
          다른 형태로 변경할 수 있는지를 검토 해보는 것을 추천.
with emp_avg_sal as
(
select round(avg(sal),2)
from emp
)
select deptno, round(avg(sal),2), (select * from emp_avg_sal)
from emp
group by deptno
having round(avg(sal),2) > (select *
                           from emp_avg_sal);
--------------------------------------------------------------------------------------------------------------
계층쿼리
connect by level : 행을 반복하고 싶은 수만큼 복제를 해주는 기능
위치 : from(where)절 다음에 기술
DUAL 테이블과 많이 사용

테이블에 행이 한건, 메모리에서 복제
select level
from dual
connect by level <= 5;

위의 쿼리 말고도 이미 배운 keyword를 이용하여 작성 가능
5행 이상이 존재하는 테이블을 갖고 행을 제한
만약에 우리가 복제할 데이터가 10,000건이면은 10,000건데 대한 DISK I/O가 발생
select rownum
from emp
where rownum <=5;

1. 우리에게 주어진 문자열 년월 : 202005
    주어진 년월의 일수를 구하여 일수만 행을 생성

select to_date('202005','yyyymm'),level,
        to_date('202005','yyyymm') + (level -1) dt
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

select to_date('202005','yyyymm') + (level -1) dt
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

달력의 컬럼은 7개 - 컬럼의 기준은 요일 : 특정 일자는 하나의 요일에 포함
select to_date('202005','yyyymm') + (level -1) dt,
        일요일이면 dt컬럼, 월요일이면 dt컬럼, 화요일이면 dt컬럼....토요일이면 dt컬럼
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

아래 방식으로 SQL을 작성해도 쿼리를 완성하는게 가능하나
가독성 측면에서 너무 복잡하여 인라인뷰를 이용하여 쿼리를 좀 더 단순하게 만든다
select to_date('202005','yyyymm') + (level -1) dt,
        decode(to_char(to_date('202005','yyyymm') + (level -1), 'd'),1,to_date('202005','yyyymm') + (level -1)) sun,
        decode(to_char(to_date('202005','yyyymm') + (level -1), 'd'),2,to_date('202005','yyyymm') + (level -1)) mon
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd');

컬럼을 간소화하여 표현
to_date('202005','yyyymm') + (level -1) ==> dt
select dt, d(dt가 월요일이면 dt, dt가 화요일이면 dt....1개의 컬럼중에 딱 하나의 컬럼에만 dt 값이 표현 된다)
from
(select to_date('202005','yyyymm') + (level -1) dt, 
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
----
select dt, decode(d,1,dt) sun, decode(d,2,dt) mon, decode(d,3,dt) tue,
           decode(d,4,dt) wed, decode(d,5,dt) thu, decode(d,6,dt) fri, decode(d,7,dt) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
---
select dt, iw, 
           decode(d,1,dt) sun, decode(d,2,dt) mon, decode(d,3,dt) tue,
           decode(d,4,dt) wed, decode(d,5,dt) thu, decode(d,6,dt) fri, decode(d,7,dt) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'));
---
select decode(d,1,iw+1,iw), 
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);
---
select  
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date('202005','yyyymm') + (level -1) dt,
        to_char(to_date('202005','yyyymm') + (level -1), 'd') d,
        to_char(to_date('202005','yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date('202005','yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);
---
select  decode(d, 1, iw+1, iw),
           min(decode(d,1,dt)) sun, min(decode(d,2,dt)) mon, min(decode(d,3,dt)) tue,
           min(decode(d,4,dt)) wed, min(decode(d,5,dt)) thu, min(decode(d,6,dt)) fri, 
           min(decode(d,7,dt)) sat
from
(select to_date(:yyyymm,'yyyymm') + (level -1) dt,
        to_char(to_date(:yyyymm,'yyyymm') + (level -1), 'd') d,
        to_char(to_date(:yyyymm,'yyyymm') + (level -1), 'iw') iw
from dual
connect by level <= to_char(last_day(to_date(:yyyymm,'yyyymm')),'dd'))
group by decode(d, 1, iw+1, iw)
order by decode(d, 1, iw+1, iw);

