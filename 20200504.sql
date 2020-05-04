연산자

사칙 연산자 : +, -, *, / : 이항 연산자
삼항 연산자 : ? (1==1 ? true일 때 실행 : false일 때 실행)

sql 연산자
= : 컬럼] 표현식 = 값 ==> 이항 연산자

in  : 컬럼] 표현식 in (집합)
deptno in (10,30) ==> in (10,30), deptno (10,30)

exists 연산자
사용방법  : exists (서브쿼리)
서브쿼리의 조회결과가 한건이라도 있으면 true
잘못된 사용방법 : where deptno exists (서브쿼리)

메인쿼리의 값과 관계 없이 서브쿼리의 실행 결과는 항상 존재 하기 때문에 emp 테이블의 모든 데이터가 조회 된다
일반적으로 exists 연산자는 상호연관 서브쿼리로 많이 사용
아래 쿼리는 비상호 서브쿼리
select *
from emp
where exists (select 'X'
              from dept);
              
exists 연산자의 장점
만족하는 행을 하나라도 발견을 하면 더이상 탐색을 하지 않고 중단.
행의 존재 여부에 관심이 있을 때 사용
-----------------------------------------------------------------------------------------------------------
매니저가 없는 직원 : king
매니저 정보가 존재하는 직원 : 14-king = 13명의 직원
--1
select *
from emp
where mgr is not null;
--2
select *
from emp e
where exists (select 'x'
             from emp m
             where e.mgr = m.empno);
--3
select e.*
from emp e, emp m
where e.mgr = m.empno;
--------------------------------------------------------------------------------------------------------------------
--sub9
select *
from product
where exists(select *
             from cycle
             where cid = 1
                and cycle.pid = product.pid);

--sub10
select *
from product
where not exists(select *
             from cycle
             where cid = 1
                and cycle.pid = product.pid);
------------------------------------------------------------------------------------------------------
집합연산
합집합
{1, 5, 3} U {2, 3} = {1, 2, 3, 5}
교집합
{1, 5, 3} 교집합 {2, 3} = {3}
차집합
{1, 5, 3} - {2, 3} = {1, 5}
sql에만 존재하는  union all(중복 데이터를 제거 하지 않는다)
{1, 5, 3} U {2, 3} = {1, 5, 3, 2, 3}

sql에서의 집합연산
연산자 : union, union all, intersect, minus
두개의 sql의 실행결과를 행을 확장 (위,아래로 결합 된다)

--union 연산자 : 중복제거(수학적 개념의 집합과 동일) 
select empno, ename
from emp
where empno in (7566, 7698, 7369)

union

select empno, ename
from emp
where empno in (7566, 7698);

--union all연산자 : 중복 허용
select empno, ename
from emp
where empno in (7566, 7698, 7369)

union all

select empno, ename
from emp
where empno in (7566, 7698);

--intersect 교집합 : 두집합간 중복되는 요소만 조회
select empno, ename
from emp
where empno in (7566, 7698, 7369)

intersect

select empno, ename
from emp
where empno in (7566, 7698);

--minus 연산자 : 위쪽 집합에서 아래쪽 집합 요소를 제거
select empno, ename
from emp
where empno in (7566, 7698, 7369)

minus

select empno, ename
from emp
where empno in (7566, 7698);

<sql 집합연산자의 특징>
1. 열의 이름 : 첫번째 sql의 컬럼을 따라간다

--첫번째 쿼리의 컬럼명에 별칭 부여
select ename nm, empno no
from emp
where empno in (7369)
union
select ename, empno
from emp
where empno in(7698);

2. 정렬을 하고싶을 경우 마지막에 적용 가능
   개별 sql에는 order by 불가 (인라인 뷰를 사용하여 메인쿼리에서 order by가 기술되지 않으면 가능)
select ename nm, empno no
from emp
where empno in (7369)
--order by nm ==>오류. 중간 쿼리에 정렬 불가
union
select ename, empno
from emp
where empno in(7698)
order by nm;

3. sql의 집합 연산자는 중복을 제거한다(수학적 집합 개념과 동일), 단, union all은 중복 허용

4. 두개의 집합에서 중복을 제거하기 위해 각각의 집합을 정렬하는 작업이 필요
  ==> 사용자에게 결과를 보내주는 반응성이 느려짐
     ==> union all을 사용할 수 있는 상황일 경우 union을 사용하지 않아야 속도적인 측면에서 유리하다
    
알고리즘(정렬-버블 정렬, 삽입 정렬....
        자료 구조 : 트리구조(이진 트리, 밸런스 트리)
                    heap
                    stack, queue
                    list
집합연산에서 중요한 사항 : 중복제거

-----------------------------------------------------------------------------------------------------
select *
from fastfood
where sido = '서울특별시' and sigungu = '중구';

select sido, SIGUNGU, count(gb)
from fastfood
group by sido, SIGUNGU, gb
having gb != '롯데리아'
order by sido;

select *
from
(select sido, sigungu, c
from (select sido, SIGUNGU, count(gb) as c
     from fastfood
     group by sido, SIGUNGU, gb
     having gb != '롯데리아') 
group by sido, sigungu, c );



select sido, sigungu, a
from (select sido, SIGUNGU, count(gb) as a
     from fastfood
     group by sido, SIGUNGU, gb
     having gb != '롯데리아') 
group by sido, sigungu, a;

select sido, sigungu
from fastfood
group by sido, sigungu;

select m.sido, m.sigungu, m.a, n.b, round(a/b,2)
from
(select sido, sigungu, count(gb) as a
from fastfood
where gb in ('버거킹','맥도날드','KFC')
group by sido, sigungu) m,
(select sido, sigungu, count(gb) as b
from fastfood
where gb = '롯데리아'
group by sido, sigungu) n
where m.sido = n.sido and m.sigungu=n.sigungu
order by a/b desc;
-------------------------------------------------------------------------------------------------------------
--햄버거 지수 : 사용된 문법-where, group by, count, 인라인 뷰, rownum, order by, 별칭(컬럼,테이블), round, join
select rownum || '위' as 도시발전지수, x.*
from
(select m.sido, m.sigungu, m.a, n.b, round(a/b,2)
from
(select sido, sigungu, count(gb) as a
from fastfood
where gb in ('버거킹','맥도날드','KFC')
group by sido, sigungu) m,
(select sido, sigungu, count(gb) as b
from fastfood
where gb = '롯데리아'
group by sido, sigungu) n
where m.sido = n.sido and m.sigungu = n.sigungu
order by a/b desc)x;

과제1] fastfood 테이블과 tax 테이블을 이용하여 다음과 같이 조회되도록 sql 작성 : 필수
1. 도시발전지수를 구하고(지수가 높은 도시가 순위가 높다)
2. 인당 연말 신고액이 높은 시도 시군구별로 순위를 구하여
3.도시발전지수와 인당 신고액 순위가 같은 데이터 끼리(rownum) 조인하여 아래와 같이 컬럼에 조회되도록 sql 작성
순위 햄버거 시도, 햄버거 시군구, 햄버거 도시발전지수, 국세청 시도, 국세청 시군구, 국세청 연말정산 금액1인당 신고액

과제2] : 옵션 
햄버거 도시발전 지수를 구하기 위해 4개의 인라인 뷰를 사용 하였는데(fastfood 테이블을 4번 사용)
이를 개선하여 테이블을 한번만 읽는 형태로 쿼리를 개선(fastfood 테이블을 1번만 사용)
case, decode

과제3] : 옵션
햄버거 지수 sql을 다른형태로 도전하기