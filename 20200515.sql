rollup : 서브그룹 생성 - 기술된 컬럼을 오른쪽에서부터 지워나가며 group by를 실행

아래 쿼리의 서브 그룹
1. group by job, deptno
2. group by job
3. group by ==> 전체

select grouping(job) as job, 
        grouping(deptno) as deptno, 
        sum(sal) as sal
from emp
group by rollup (job, deptno);

--group_ad2
select decode(grouping(job),1,'총계',0,job) as job, 
        decode(grouping(deptno),0,deptno) as deptno, 
        sum(sal) as sal
from emp
group by rollup (job, deptno);


--group_ad2-1
select decode(grouping(job),1,'총',0,job) as job, 
        decode(grouping(deptno) + grouping(job), 1, '소계', 2, '계', to_char(deptno)), 
        sum(sal) as sal 
from emp
group by rollup (job, deptno);

select case 
        when grouping(job) = 1 then '총'
        else job
        end job,
        case
        when grouping(deptno) = 1 and grouping(job) = 1 then '계'
        when grouping(deptno) = 1 then '소계' 
        else to_char(deptno)
        end deptno,
        sum(sal) as sal
from emp
group by rollup (job, deptno);

--group_ad3
select deptno, job, sum(sal)
from emp
group by rollup (deptno,job);

rollup절에 기술 되는 컬럼의 순서는 조회 결과에 영향을 미친다
****서브 그룹을 기술된 컬럼의 오른쪽 부터 제거해 나가면서 생성

--group_ad4
select dept.dname, emp.job, sum(emp.sal)
from emp, dept 
where emp.deptno = dept.deptno
group by rollup (dept.dname, emp.job);

select dept.dname, a.job, a.sum_sal
from 
(select deptno, job, sum(sal) as sum_sal
from emp
group by rollup (deptno,job)) a, dept
where a.deptno = dept.deptno(+);

--group_ad5
select nvl(dept.dname, '총계') dname, emp.job, sum(emp.sal)
from emp, dept 
where emp.deptno = dept.deptno
group by rollup (dept.dname, emp.job);
-------------------------------------------------------------------------------------------------------------------
2.grouping sets
rollup의 단점 :  관심없는 서브그룹도 생성 해야 한다
                rollup절에 기술한 컬럼을 오른쪽에서 지워나가기 때문에
                만약 중간과정에 있는 서브그룹이 불필요 할 경우 낭비
grouping sets : 개발자가 직업 생성할 서브그룹을 명시
                rollup과는 다르게 방향성이 없다
사용법 : group by grouping sets (col1, col2....)
group by col1
union all
group by col2

select job, deptno, sum(sal)
from emp
group by grouping sets (job, deptno);

select job, deptno, sum(sal)
from emp
group by job
union all
select job, deptno, sum(sal)
from emp
group by deptno;

그룹기준을
1. job, deptno
2. mgr

group by grouping sets ( (job,deptno), mgr )

select job, deptno, mgr, sum(sal) 
from emp
group by grouping sets ( (job,deptno), mgr );

select job, deptno, null, sum(sal) 
from emp
group by grouping sets (job,deptno)
union all
select null, null, mgr, sum(sal) 
from emp
group by mgr;
------------------------------------------------------------------------------------------------------
report group function ==> 확장된 group by
report group function을 사용을 안하면
여러개의 SQL을 작성, union all을 통해서 하나의 결과로 합치는 과정

==> 좀 더 편하게 하는게 report group function
----------------------------------------------------------------------------------------------------------
3. CUBE
사용법 : group by cube (col1, col2...)
기술된 컬럼의 가능한 모든 조합 (순서는 지킨다)

group by cube (job, deptno);
  1           2         
job         deptno      
job         X
X           deptno
X           X

group by cube (job, deptno, mgr);
  1           2         3
job         deptno      mgr
job         deptno      x
job         x           mgr    
job         x           x
x           deptno      mgr
x           x           mgr
x           deptno      x
x           x           x    ==> 전체

select job, deptno, sum(sal)
from emp
group by cube (job, deptno);
----------------------------------------------------------------------------------------------------------
여러개의 report group 사용하기
select job, deptno, mgr, sum(sal)
from emp
group by job, rollup(deptno), cube(mgr);

**발생 가능한 조합을 계산
1       2           3
job     deptno      mgr ==>group by job, deptno, mgr
job     deptno      x  ==>group by job, deptno
job     x           mgr ==>group by job, mgr
job     x           x   ==>group by job

select job, deptno, mgr, sum(sal+nvl(comm,0))sal
from emp
group by job, rollup(job,deptno), cube(mgr);
----------------------------------------------------------------------------------------------------------------
상호연관 서브쿼리 업데이트
1. emp테이블을 이용하여 emp_test 테이블 생성
    ==> 기존에 생성된 emp_test 테이블 삭제 먼저 진행
        drop table emp_test;
    ==> 테이블 생성
        create table emp_test as
        select *
        from emp;

2. emp_test 테이블에 dname 컬럼 추가 (dept 테이블 참고)
desc dept;
alter table emp_test add (dname VARCHAR2(14));

3. subquery를 이용하여 emp_test 테이블에 추가된 dname 컬럼을 업데이트 해주는 쿼리 작성
emp_test의 dname 컬럼의 값을 dept 테이블의 dname 컬럼으로 update
emp_test테이블의 deptno값을 확인해서 dept테이블의 deptno값이랑 일치하는 dname 컬럼값을 가져와 update

emp_test테이블의 dname 컬럼을 dept 테이블이용해서 dname값 조회하여 업데이트
update 대상이 되는 행 : 14 ==> where 절을 기술하지 않음

모든 직원을 대상으로 dname컬럼을 dept 테이블에서 조회하여 업데이트
update emp_test set dname = (select dname
                            from dept
                            where emp_test.deptno = dept.deptno);

--실습 sub_a1
1.테이블 생성
drop table dept_test;

create table dept_test as
select *
from dept;

2. dept_test 테이블에 empcnt(number) 컬럼 추가
alter table dept_test add (empcnt NUMBER(2));

3. 서브쿼리 이용하여 해당 부서원 수를 업데이트
update dept_test set empcnt = (select count(*) 
                                from emp
                                where dept_test.deptno = emp.deptno); --이 서브쿼리는 비상호연관쿼리

update dept_test set empcnt = (select count(*) 
                                from emp
                                where dept_test.deptno = emp.deptno
                                group by deptno); --위의 쿼리와 다른 점은 null값이 등장

select *
from dept_test;

select deptno, count(*)
from emp
group by deptno;
---------------------------------------------------------------------------------------------------------
select 결과 전체를 대상으로 그룹 함수를 적용한 경우
대상되는 행이 없더라도 0값이 리턴

select count(*)
from emp
where 1 = 2;

group by 절을 기술할 경우 대상이 되는 행이 없을경우 조회되는 행이 없다(null-값이 지정되지 않았다)
select count(*)
from emp
where 1 = 2
group by deptno;
