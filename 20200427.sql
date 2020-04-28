--grp7
dept 테이블을 확인하면 총 4개의 부서 정보가 존재 ==> 회사내에 존재하는 모든 부서정보
emp 테이블에서 관리되는 직원들이 실제 속한 부서정보의 개수 ==> 10,20,30,40 ==> 3개

select count(count(deptno)) as cnt
from emp
group by deptno;

select count(*) as cnt
from
    (select deptno / deptno  --컬럼이 1개 존개, row는 3개인 테이블
    from emp
    group by deptno);
    
select count(*)
from
  (select count(*) as cnt
  from
    (select deptno / deptno 
    from emp
    group by deptno));
-----------------------------------------------------------------------------------------------------------------------
DBMS ≒ RDBMS
DBMS : database management system
==>DB
RDBMS : relational database management system
==>관계형 데이터베이스 관리 시스템

JOIN 문법의 종류
ANSI - 표준
벤더사의 문법(ORACLE)

join의 경우 다른 테이블의 컬럼을 사용할 수 있기 때문에 select 할 수 있는 컬럼의 개수가 많아진다(가로확장)
집합연산 ==> 세로 확장(행이 많아진다)
------------------------------------------------------------------------------------------------------------
NATURAL JOIN
    - 조인하려는 두 테이블의 연결고리 컬럼의 이름 같을 경우
    - emp, dept 테이블에는 deptno라는 공통된(동일한 이름의, 타입도 동일) 연결고리 컬럼이 존재
    - 다른 ANSI-SQL 문법을 통해서 대체가 가능하고, 조인 테이블들의 컬럼명이 동일하지 않으면 사용이 불가능하기 때문에
      사용빈도는 다소 낮다
    
.emp 테이블 : 14건
.dept 테이블 : 4건

조인하려고 하는 컬럼을 별도 기술하지 않음
select *
from emp natural join dept; --from절에 테이블명이 여러개 올 수 있을까? ㅇㅇ join해봐!!
==>두 테이블의 이름이 동일한 컬럼으로 연결한다(동일한 컬럼=deptno=연결컬럼(연결고리))

select *
from dept;
------------------------------------------------------------------------------------------------------
ORACLE 조인 문법은 ANSI 문법처럼 세분화 하지 않음
오라클 조인 문법
1. 조인할 테이블 목록을 from절에 기술하며 구분자는 클론(,)
2. 연결고리 조건을 where절에 기술하면 된다(ex : where emp.deptno = dept.deptno)

select *
from emp, dept
where emp.deptno = dept.deptno;

deptno가 10번인 직원들만 dept 테이블과 조인 하여 조회
select *
from emp, dept
where emp.deptno = dept.deptno
    and emp.deptno = 10; --and dept.deptno = 10; 이렇게 써도 상관없음
-------------------------------------------------------------------------------------------------------    
ANSI-SQL : JOIN with USING
- join 하려는 테이블간 이름이 같은 컬럼이 2개 이상일 때
- 개발자가 하나의 컬럼으로만 조인하고 싶을 때 조인 컬럼명을 기술

select *
from emp join dept using (deptno);
---------------------------------------------------------------------------------------------------------
ANSI-SQL : JOIN with ON --많이 쓰임
- 조인 하려는 두 테이블간 컬럼명이 다를 떄
- ON절에 연결고리 조건을 기술;

select *
from emp join dept on (emp.deptno = dept.deptno);

oracle 문법으로 위 sql을 작성
select *
from emp, dept
where emp.deptno = dept.deptno;
-------------------------------------------------------------------------------------------------------
JOIN의 논리적인 구분
self join : 조인하려는 테이블이 서로 같을 때
emp 테이블의 한행은 직원의 정보를 나타내고 직원의 정보중 mgr컬럼은 해당 직원의 관리자 사번을 관리
해당 직원의 관리자의 이름을 알고싶을 때 --함수종속

ansi-sql로 sql 조인 :
조인하려고 하는 테이블 emp(직원), emp(직원의 관리자)
            연결고리 컬럼 : 직원.mgr = 관리자.empno
            ==> 조인 컬럼 이름이 다르다(mgr, empno)
             ==> natural join, join with using 은 사용이 불가능한 형태
              ==>join with on 을 사용해서 작성 할 수 밖에 없음

ansi-sql로 작성

select * 
from emp e join emp m on (e.mgr = m.empno); 

select * 
from emp as e join emp as m on (e.mgr = m.empno); --오류==> 테이블에서 별칭줄때는 as 무조건 쓰면 안됨. 안 쓰고 그냥 별칭줘야함 
-------------------------------------------------------------------------------------------------------------------------
NONEUQI JOIN : 연결고리 조건이 = 이 아닐 때
그동안 where에서 사용한 연산자 : =, !=, <>,<=, <, >, >=
                             and, or, not
                             like %, _
                             or - in
                             between and
select *
from emp;

select *
from salgrade;

select *
from emp join salgrade on (emp.sal between salgrade.losal and salgrade.hisal);

select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp join salgrade on (emp.sal between salgrade.losal and salgrade.hisal);

==> oracle 조인 문법으로 변경
select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp, salgrade
where sal between salgrade.losal and salgrade.hisal;

select emp.empno, emp.ename, emp.sal, salgrade.grade
from emp, salgrade
where emp.sal between salgrade.losal and salgrade.hisal;
-------------------------------------------------------------------------------------------------------------------------
--join0
(1) join with on;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
order by dname;

(2) oracle;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
order by dname;

(3) natural join;
select empno, ename, deptno, dname
from emp natural join dept
order by dname;

(4) join using;
select empno, ename, deptno, dname
from emp join dept using (deptno)
order by dname;


--join0_1
(1) join with on;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.deptno !=20; --emp.deptno = 10 or emp.deptno = 30

(2)oracle;
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    --and (emp.deptno = 10 or emp.deptno = 30); --dept.deptno in (10,30) or emp.deptno in (10,30)
    and (dept.deptno = 10 or dept.deptno = 30);

(3) natural join;
select empno, ename, deptno, dname
from emp natural join dept
where deptno !=20; --deptno = 10 or deptno = 30

(4) join using;
select empno, ename, deptno, dname
from emp join dept using (deptno)
where deptno = 10 or deptno = 30; --deptno != 20


--join0_2
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500
order by deptno;


--join0_3
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500 and empno > 7600
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500 and emp.empno > 7600
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500 and empno > 7600
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500 and empno > 7600
order by deptno;


--join0_4
(1) join with on;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp join dept on (emp.deptno = dept.deptno)
where emp.sal > 2500 and emp.empno > 7600 and dept.dname = 'RESEARCH'
order by deptno;

(2)oracle;
select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
from emp, dept
where emp.deptno = dept.deptno
    and emp.sal > 2500 and emp.empno > 7600 and dept.dname = 'RESEARCH'
order by deptno;

(3) natural join;
select empno, ename, sal, deptno, dname
from emp natural join dept
where sal > 2500 and empno > 7600 and dname = 'RESEARCH'
order by deptno;

(4) join using;
select empno, ename, sal, deptno, dname
from emp join dept using (deptno)
where sal > 2500 and empno > 7600 and dname = 'RESEARCH'
order by deptno;


----------------------------------------------------------------------------------------------------------------------
생각해보기
select empno, ename, emp.deptno, dname 
from emp, dept
where emp.deptno != dept.deptno;

select empno, ename, emp.deptno, dname 
from emp, dept
where emp.deptno <= dept.deptno;
-----------------------------------------------------------------------------------------------------------------------
--join1
(1) join with on ;
select lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
from prod join lprod on (prod.prod_lgu = lprod.lprod_gu);

(2) oracle;
select lprod_gu, lprod_nm, prod_id, prod_name
from prod, lprod
where prod.prod_lgu = lprod.lprod_gu;
