한개의 행, 하나의 컬럼을 리턴하는 서브쿼리
ex : 전체 직원의 급여 평균, smith 직원이 속한 부서의 부서번호

where에서 사용가능한 연산자
where deptno = 10
===>
부서번호가 10 혹은 30번인 경우
where deptno in(10,30)
where deptno = 10 or deptno = 30
------------------------------------------------------------------------------------------------------------
다중행 연산자
다중행을 조회하는 서브쿼리의 경우 = 연산자를 사용불가
where deptno in(10,30) <-이거는 가능 + (여러개의 행을 리턴하고, 하나의 컬럼으로 이루어진 쿼리)

SMITH = 20, ALLEN은 30번 부서에 속함

SMITH 또는 ALLEN이 속하는 부서의 조직원 정보를 조회

행이 여러개고, 컬럼은 하나다 
==> 서브쿼리에서 사용가능한 연산자 IN(많이씀,중요), (ANY,ALL(빈도가 낮음))
IN : 서브쿼리의 결과값 중 동일한 값이 있을 때 true
    WHERE 컬럼, 표현식 IN (서브쿼리)

ANY : 연산자를 만족하는 값이 하나라도 일을 때 TRUE
    WHERE 컬럼, 표현식 연산자 ANY (서브쿼리)
    
ALL : 서브쿼리의 모든 막ㅄ이 연산자를 만족할 떄 TRUE
    WHERE 컬럼, 표현식 연산자 ALL (서브쿼리)
    
SMITH와 ALLEN이 속한 부서에서 근무하는 모든 직원을 조회

1. 서브쿼리를 사용하지 않을 경우 : 두개의 쿼리를 실행
1-1] SMITH와 ALLEN이 속한 부서의 부서번호를 확인하는 쿼리
SELECT *
FROM EMP
WHERE ENAME IN('SMITH', 'ALLEN');
1-2] 1-1에서 얻은 부서번호로 IN연산자를 통해 해당 부서에 속하는 직원 정보 조회
SELECT *
FROM emp
WHERE deptno IN (20,30)

===>서브쿼리를 이용하면 하나의 SQL애서 실행가능
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM EMP
                WHERE ENAME IN('SMITH', 'ALLEN'));
-------------------------------------------------------------------------------------------------                
--실습 sub3
select *
from emp
where deptno in(select deptno
                from emp
                where ename in('SMITH','WARD'));
-------------------------------------------------------------------------------------------------                
//참고
ANY, ALL ---any : or / all : and 
SMITH나 WARD 두 사원의 급여 중 아무 값보다 작은 급여를 받는 직원 조회
===> sal < 1250
select *
from emp
where sal < any (select sal
                from emp
                where ename in ('SMITH', 'WARD'));
SMITH나 WARD 두 사원의 급여보다 많은 급여를 받는 직원 조회
===>sal > 1250
select *
from emp
where sal > all (select sal
                from emp
                where ename in ('SMITH', 'WARD'));
------------------------------------------------------------------------------------------------------
IN 연산자의 부정
소속부서가 20, 혹은 30인 경우
where deptno in (20,30)

소속부서가 20,30에 속하지 않는 경우
where deptno not in (20,30)
not in 연산자를 사용 할 경우 서브쿼리의 값에 null이 있는지 여부가 중요
==>null이 있으면 정상으로 동작하지 않음

아래 쿼리가 조회하는 결과는 어떤 의미인가?? 누군가의 매니저가 아닌 사원=평사원 조회
--null처리 안해서 데이터 아무것도 조회가 안됨
select *
from emp
where empno not in (select mgr
                    from emp);
--null처리 1 : null값을 갖는 행을 제거
select *
from emp
where empno not in (select mgr
                    from emp
                    where mgr is not null);
--null처리 2 : null처리 함수를 통해 쿼리에 영향이 가지 않는 값으로 치환
select *
from emp
where empno not in (select nvl(mgr,-1)
                    from emp);
------------------------------------------------------------------------------------------
단일 컬럼을 리턴하는 서브쿼리에 대한 연산 ==> 복수 컬럼을 리턴하는 서브쿼리
PAIRWISE 연산 (순서쌍) ==> 동시에 만족

SELECT empno, mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

7499, 7782사번의 직원과 같은 부서, 같은 매니저인 모든 직원 정보 조회
매니저가 7698이면서 소속부서가 30번인 경우
매니저나 7839이면서 소속부서가 10인 경우

mgr컬럼과 deptno컬럼의 연관성이 없다
select *
from emp
where mgr in (7698,7839) and deptno in (10,30); 

PAIRWISE 적용 (위의 쿼리보다 결과가 한건 적다)
select *
from emp
where (mgr, deptno) in (select mgr, deptno
                        from emp
                        WHERE empno IN (7698,7839));
-------------------------------------------------------------------------------------------------------                        
서브쿼리 구분-사용 위치에 따라서
select - 스칼라 서브 쿼리
from - 인라인 뷰
where - 서브쿼리

서브쿼리 구분 - 반환하는 행, 컬럼의 수
단일 행
    단일 컬럼(스칼라 서브 쿼리)
    복수 컬럼
복수 행
    단일 컬럼(많이 쓰는 형태)
    복수 컬럼
    
스칼라 서브쿼리
select 절에 표현되는 서브쿼리
단일행 단일 컬럼을 리턴하는 서브쿼리만 사용 가능
메인 쿼리의 하나의 컬럼처럼 인식

select 'X', (select sysdate from dual)
from dual;

스칼라 서브 쿼리는 하나의 행, 하나의 컬럼을 반환 해야 한다
--행은 하나지만 컬럼이 2개여서 에러
select 'X', (select empno, ename from emp where ename = 'SMITH')
from dual;

다중행 하나의 컬럼을 리턴하는 스칼라 서브쿼리
--에러
select 'X', (select empno from emp)
from dual;

emp 테이블만 사용 할 경우 해당 직원의 소속 부서 이름을 알 수가 없다 ==>join
특정 부서의 부서 이름을 조회하는 쿼리
select dname
from dept
where deptno = 10;

위 쿼리를 스칼라 서브쿼리로 변경

join으로 구현
select empno, ename, dept.deptno, dname
from emp, dept
where emp.deptno =  dept.deptno;

위 쿼리를 스칼라 서브쿼리로 변경
select empno, ename, emp.deptno  --, 부서이름
from emp;

select empno, ename, emp.deptno, (select dname from dept where deptno = emp.deptno)
from emp;

서브쿼리 구분 - 메인쿼리의 컬럼을 서브쿼리에서 사용하는지 여부에 따른 구분
상호연관 서브쿼리(corelated sub query)
    .메인 쿼리가 실행 되어야 서브 쿼리가 실행이 가능하다
비상호 연관 서브쿼리(non corelated sub query)    
    .메인 쿼리의 테이블을 먼저 조회 할 수도 있고,
     sub 쿼리의 테이블을 먼저 조회 할 수도 있다
     ==>오라클이 판단 했을 때 성능상 유리한 방향으로 실행 방향을 결정

모든 직원의 급여평균 보다 많은 급여를 받는 직원을 조회하는 쿼리를 작성 하세요(서브 쿼리 이용)
select *  
from emp
where sal > (select avg(sal) from emp)
생각해볼 문제, 위의 쿼리는 상호 연관 서브 쿼리인가? 비상호 연권 서브 쿼리인가?

직원이 속한 부서의 급여 평균보다 많은 급여를 받는 직원
전체 직원의 급여 평균==>직원이 속한 부서의 급여 평균

특정 부서의 급여 평균을 구하는 SQL;
select avg(sal)
from emp
where deptno = 10;

select *
from emp e
where e.sal > (select avg(sal)
               from emp b
               where b.deptno = e.deptno);
--상호 연관 쿼리 : 반드시 메인 쿼리의 값이 서브 쿼리 안으로 들어가게 되어있음.
--------------------------------------------------------------------------------------------
select *
from dept;
--실습 sub4
insert into dept values (99, 'ddit', 'daejeon');

emp테이블에 등록된 직원들은 10,20,30번 부서에만 소속이 되어있음
직원이 소속되지 않은 부서는  : 40, 99

select *
from dept 
where deptno not in (10,20,30); --dept.deptno = emp.deptno; 10,20,30

select *
from dept
where deptno not in (select deptno
                     from emp);                   

서브쿼리를 이용하여 in연산자를 통해 일치하는 값이 있는지 조사할 때
값이 여러개 있어도 상관 없다(집합)

동일한 부서번호가 서브쿼리에서 조회되지 않도록 제거 할려고 그룹 연산을 한 경우(답은 맞다)
select *
from dept
where deptno not in (select deptno
                    from emp
                    group by deptno);
//참고                   
select *
from dept
where 0 < (select sum(empno)
            from emp
            where emp.deptno = dept.deptno);

--실습sub5
select pid
from cycle
where cid = 1;

select *
from product;

select *
from product
where pid not in (select pid
                   from cycle
                   where cid = 1);
                   
--실습sub6
1번 고객의 애음제품 정보를 조회를 한다
단, 2번 고객이 먹는 애음제품만 조회를 한다
1] 1번 고객이 먹는 애음제품정보
select *
from cycle
where cid = 1;
2] 2번 고객이 먹는 애음제품정보
select pid
from cycle
where cid = 2;
--비상호연관쿼리
select *
from cycle 
where cid = 1 and pid in (select pid
                          from cycle 
                          where cid = 2);
              
select *
from product;

select *
from cycle;

--실습sub7
조인을 이용한 방법
select c.cid, cnm, c.pid, pnm, day, cnt
from customer s, cycle c, product p
where c.cid = 1 
     and s.cid = c.cid 
     and p.pid = c.pid 
     and c.pid in (select a.pid
                   from cycle a 
                   where a.cid = 2);
 
select cycle.cid, cnm, cycle.pid, pnm, day, cnt
from customer, cycle, product
where customer.cid = cycle.cid 
     and product.pid = cycle.pid 
     and cycle.cid = 1 and cycle.pid in (select cycle.pid
                                         from cycle 
                                         where cycle.cid = 2);

스칼라쿼리를 이용한 방법                   
select cid, (select cnm from customer where cid = cycle.cid) as cnm, 
       pid, (select pnm from product where pid = cycle.pid) as pnm, day,cnt
from cycle
where cid = 1
and pid in (select pid
            from cycle
            where cid = 2);
==>조인을 이용한 방법이 더 옳다....스칼라 쿼리를 실행이 너무 많이 됨..ㅇㅇ