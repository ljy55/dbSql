outer join
테이블 연결 조건이 실패해도, 기준으로 삼은 테이블의 컬럼은 조회가 되도록 하는 조인 방식
<====>
inner join(우리가 지금까지 배운 방식)

left outer join : 기준이 되는 테이블이 join 키워드 왼쪽에 위치
right outer join : 기준이 되는 테이블이 join 키워드 오른쪽에 위치
full outer join : left outer join + right outer join -(중복되는 데이터가 한건만 남도록 처리)

emp테이블의 컬럼 중 mgr컬럼을 통해 해당 직원의 관리자 정보를 찾아갈 수 있다
하지만 king 직원의 경우 상급자가 없기 때문에 일반적인 inner 조인 처리시 조인에 실패하기 때문에 
king을 제외한 13건의 데이터만 조회가 됨

inner 조인 복습
상급자 사번, 상급자 이름, 직원 사번, 직원 이름
--oracle
select m.empno, m.ename, e.empno, e.ename
from emp e, emp m
where e.mgr = m.empno;
--ansi
select m.empno, m.ename, e.empno, e.ename
from emp e join emp m on(e.mgr = m.empno);

조인이 성공해야지만 데이터가 조회된다
==>king의 상급자 정보(mgr)는 null이기 때문에 조인에 실패하고
king의 정보는 나오지 않는다(emp 테이블의 건수 14건-->13건)
----------------------------------------------------------------------------------------------------------
위의 쿼리를 outer 조인으로 변경
(king 직원이 조인에 실패해도 본인 정보에 대해서는 나오도록, 하지만 상급자 정보는 없기 때문에 나오지 않는다);

--ansi-sql : outer
select m.empno, m.ename, e.empno, e.ename
from emp e left outer join emp m on(e.mgr = m.empno);

from 기준 테이블 left outer join 테이블

select m.empno, m.ename, e.empno, e.ename
from emp m right outer join emp e on(e.mgr = m.empno);

from 테이블 right outer join 기준 테이블
--oracle-sql : outer
oracle join
1.from절에 조인할 테이블 기술(콤마로 구분)
2.where 절에 조인 조건을 기술
3. 조인 컬럼(연결고리)중 조인이 실패하여 데이터가 없는 쪽의 컬럼에 (+)
  ==> 마스터 테이블 반대편쪽 테이블의 모든 컬럼에(+)
select m.empno, m.ename, e.empno, e.ename
from emp e, emp m
where e.mgr = m.empno(+);
--------------------------------------------------------------------------------------------------------------------
outer 조인의 조건 기술 위치에 따른 결과 변화

직원의 상급자 이름, 아이디를 포함해서 조회
단, 직원의 소속부서가 10번에 속하는 직원들만 한정해서;

--조건을 on절에 기술했을 때
select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e left outer join emp m on(e.mgr = m.empno and e.deptno = 10);

--조건을 where절에 기술했을 때
select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e left outer join emp m on(e.mgr = m.empno)
where e.deptno = 10;

select *
from emp;

outer 조인을 하고 싶은 것이라면 조건을 on절에 기술하는게 맞다

select m.empno, m.ename, e.empno, e.ename, e.deptno
from emp e,emp m 
where e.mgr(+) = m.empno
     and e.deptno(+) = 10;
--------------------------------------------------------------------------------------------------------------------
--outerjoin1

select buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b right outer join prod p on(b.buy_prod = p.prod_id) and buy_date = to_date('20050125','yyyymmdd');

select buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');

--outerjoin2
select to_date('20050125','yyyymmdd') as buy_date, buy_prod, prod_id, prod_name, buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');

--outerjoin3
select to_date('20050125','yyyymmdd') as buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty,0) as buy_qty
from buyprod b, prod p
where b.buy_prod(+) = p.prod_id
    and buy_date(+) = to_date('20050125','yyyymmdd');
    
--outerjoin4
select p.pid, pnm, nvl(cid,1) as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p, cycle c
where p.pid = c.pid(+)
      and c.cid(+) = 1;
      
select p.pid, pnm, nvl(cid,1) as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);
--위에보다 아래에 있는 cid null처리가 더 합리적
select p.pid, pnm, 1 as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);

select product.pid, pnm, customer.cid, cnm, day, cnt
from cycle, product, customer
where cycle.pid = product.pid(+) 
     and cycle.cid(+) = 1
     and cycle.cid = customer.cid(+);

select p.pid, pnm, 1 as cid , nvl(day,0) as day, nvl(cnt,0) as cnt
from product p left outer join cycle c on(p.pid = c.pid and c.cid = 1);

-----------------------------------------------------------------------------------------------------------------------

15 ==> 45
3개 ==> customer

cross join
조인 조건을 기술하지 않은 경우
모든 가능한 행의 조합으로 결과가 조회된다
emp 14 * dept 4 = 56
select*
from emp cross join dept;

oracle (조인 테이블만 기술하고 where 절에 조건을 기술하지 않는다)
select *
from emp, dept;

--crossjoin1
select *
from customer cross join product;

-------------------------------------------------------------------------------------
서브쿼리
where : 조건을 만족하는 행만 조회되도록 제한
select *
from emp
where 1=1 or 1 != 1 --> true or false ==> true

서브 <==> 메인
서브쿼리는 다른 쿼리 안에서 작성된 쿼리
서브쿼리 가능한 위치
1. select 
    scalar sub query : 스칼라 서브쿼리는 조회되는 행이 1행이고, 컬럼이 한개의 컬럼이어야 한다 --ex)dual

2. from 
    inline-view : 쿼리를 괄호로 묶은 것

3. where 
    sub query : where절에 사용된 쿼리

smith가 속한 부서에 속한 직원들은 누가 있을까?
1. smith가 속한 부서가 몇번이지?
2.1번에서 알아낸 부서번호에 속하는 직원을 조회
==>독립적인 2개의 쿼리를 각각 실행
    두번째 쿼리는 첫번째의 쿼리의 결과에 따라 값을 다르게 가져와야한다
    smith(20) => ward(30) ==> 두번째 쿼리 작성시 10번에서 30번으로 조건을 변경 ==> 유지보수 측면에서 좋지 않음
첫번째 쿼리
select deptno
from emp
where ename = 'SMITH';

두번째 쿼리
select *
from emp
where deptno = 20;

서브쿼리를 통한 쿼리 통합
select *
from emp
where deptno = (select deptno
               from emp
               where ename = 'SMITH');
               
--sub1
select count(*)
from emp 
where sal > (select avg(sal) 
            from emp);

--sub2
select *
from emp 
where sal > (select avg(sal) 
            from emp);
            
------------------------------------------------------------------------------------------------------------------------ 

