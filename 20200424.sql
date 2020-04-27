<20200422~20200423 꼭 기억해야 할 3가지 복습>

1.null처리 하는 방법 (4가지중에 본인 편한걸로 하나 이상은 기억)
nvl, nvl2...

desc emp; --empno가 not null(empno에는 null들어가서는 안된다)

2. condition : case, decode

3.실행계획 : 실행계획이 뭔지 + 보는 순서
----------------------------------------------------------------------------------------
select*
from emp
order by deptno;

emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급 할 예정
해당 직원의 job이 salesman일 경우 sal에서 5% 인상된 금액을 보너스로 지급(ex:sal 100->105)
해당 직원이 job이 manager이면서 deptno가 10이면 sal에서 30% 인상된 금액을 보너스로 지급
                              그 외의 부서에 속하는 사람은 10% 인상된 금액을 보너스로 지급
해당 직원의 job이 president일 경우 sal에서 20% 인상된 금액을 보너스로 지급
그외 직원들은 sal만큼만 지급

decode만 사용
/*select empno, ename, job, sal, deptno,
        DECODE(job,'SALESMAN',sal*1.05,
                    'MANAGER',decode(deptno,10,sal*1.3,sal*1.1),
                    'PRESIDENT',sal*1.2,
                    sal*1.1)
from emp;*/ --if문 중복해서 사용하는거 지양함
--------------------------------------------------------------------------------------------------------
집합 A = {10, 15, 18, 23, 24, 25, 29, 30, 35, 37}
소수 : 자신과 1을 약수로 하는 수
prime Number 소수 : {23, 29, 37} : count-3, max-37, min-23, avg-29.66, sum-89
비소수 : {10, 15, 18, 24, 25, 30, 35}

group function
여러행의 데이터를 이용하여 같은 그룹끼리 묶어 연산하는 함수
여러행을 입력밭아 하나의 행으로 결과가 묶인다
ex)부서별 급여 평균
    emp테이블에는 14명의 직원이 있고, 14명의 직원은 3개의 부서(10,20,30)에 속해 있다
    부서별 급여 평균은 3개의 행으로 결과가 반환된다
    
group by 적용시 주의 사항 : select 기술할 수 있는 컬럼이 제한됨

select 그룹핑 기준 컬럼, 그룹함수
from 테이블
group by 그룹핑 기준 컬럼
[order by];

부서별로 가장 높은 급여
select deptno, max(sal)
from emp
group by deptno;

select deptno, sal
from emp
order by deptno,sal;

select deptno, ename, max(sal) --실행안됨. why? 그룹핑 기준 컬럼을 부서번호로 잡아서
from emp
group by deptno;

select deptno, min(ename), max(sal) --이거는 실행됨. 결과 : 부서번호를 기준으로 이름은 작은값..? 으로 연봉은 제일 큰 값
from emp
group by deptno;

select deptno,
        max(sal), --부서별로 가장 높은 급여 값
        min(sal), --부서별로 가장 낮은 급여 값
        round(avg(sal),2), --부서별 급여 평균
        sum(sal), --부서별로 급여 합
        count(sal), --부서별로 급여 건수(sal 컬럼의 값이 아닌 null이 아닌 row의 수)
        count(*), --부서별 행의 수
        count(mgr)
from emp
group by deptno;

*그룹 함수를 통해 부서번호 별 가장 높은 급여를 구할 수는 있지만 가장 높은 급여를 받는 사람의 이름을 알 수는 없다
==>추후 window function을 통해 해결 가능

emp 테이블의 그룹 기준을 부서번호가 아닌 전체 직원으로 설정하는 방법
select  max(sal), --전체 직원 중 가장 높은 급여 값
        min(sal), --전체 직원 중 가장 낮은 급여 값
        round(avg(sal),2), --전체 직원의 부서별 급여 평균
        sum(sal), --전체 직원의 급여 합
        count(sal), --전체 직원의 급여 건수(sal 컬럼의 값이 아닌 null이 아닌 row의 수)
        count(*), --전체 행의 수
        count(mgr) -- mgr컬럼이 null이 아닌 건수
from emp;

2020.04.27일 발표 때 정답 확인
group by절에 기술된 컬럼이
    select절에 나오지 않으면 --실행
    
group by절에 기술되지 않은 컬럼이
    select절에 나오면 --오류

그룹화와 관련 없는 문자열, 상수 등은 select절에 표현 될 수 있다(에러 아님);
select deptno, 'test', 1,
        max(sal), --부서별로 가장 높은 급여 값
        min(sal), --부서별로 가장 낮은 급여 값
        round(avg(sal),2), --부서별 급여 평균
        sum(sal), --부서별로 급여 합
        count(sal), --부서별로 급여 건수(sal 컬럼의 값이 아닌 null이 아닌 row의 수)
        count(*), --부서별 행의 수
        count(mgr)
from emp
group by deptno;

group함수 연산시 null 값은 제외가 된다
30번 부서에는 null값을 갖는 행이 있지만 sum(comm)의 값이 정상적으로 계산되는 걸 확인 할 수 있다
select deptno,sum(comm)
from emp
group by deptno;

10번, 20번 부서의 sum(comm)컬럼이 null이 아니라 0이 나오도록 null처리
* 특별한 사유가 아니면 그룹함수 계산결과에 null처리를 하는 것이 성능상 유리

nvl(sum(comm),0) : comm컬럼에 sum 그룹함수를 적용하고 최종 결과에 nvl을 적용(1회 호출)
sum(nvl(comm,0)) : 모든 comm컬럼에 nvl 함수를 적용 후(해당 그룹의 row수 만큼 호출) sum 그룹함수 적용

select deptno, sum(nvl(comm,0)), nvl(sum(comm),0) --뒤에 있는게 더 효율적인 방법
from emp
group by deptno;

single row함수는 where절에 기술 할 수 있지만
multi row 함수(group함수)는 where절에 기술할 수 없고 group by 절 이후 having절에 별도로 기술

single row 함수는 where 절에서 사용 가능
select *
from emp
where lower(ename) = 'smith';

부서별 급여 합이 5000이 넘는 부서만 조회
select deptno, sum(sal)
from emp
where sum(sal)>9000
group by deptno; --오류

select deptno, sum(sal)
from emp
group by deptno
having sum(sal) > 9000;

--grp1
select max(sal) as max_sal, min(sal) as min_sal, round(avg(sal),2) as avg_sal,
       sum(sal) as sum_sal, count(sal) as count_sal, count(mgr) as count_mgr, count(*) as count_all --all = * 
from emp;

--grp2
select  deptno, 
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno;

--grp3
select  deptno as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno
having decode(deptno,30,'ACCOUNTING',20,'RESEARCH',10,'SALES');

--grp3 *참고만
(1)
select  decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES') as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by deptno
order by max(sal) desc;
(2)
select  decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES') as dname,  
        max(sal) as max_sal,
        min(sal) as min_sal,
        round(avg(sal),2) as avg_sal,
        sum(sal) as sum_sal,
        nvl(count(sal),0) as count_sal,
        nvl(count(mgr),0) as count_mgr,
        count(*) as count_all
from emp
group by decode(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES');

--grp4
select to_char(hiredate,'yyyymm') as hire_yyyymm, count(*) as cnt
from emp
group by to_char(hiredate,'yyyymm');

--grp5
select to_char(hiredate,'yyyy') as hire_yyyymm, count(*) as cnt
from emp
group by to_char(hiredate,'yyyy');

--grp6
select count(*) as cnt
from dept;

--grp7
select count(count(deptno)) as cnt
from emp
group by deptno;



select *
from emp;