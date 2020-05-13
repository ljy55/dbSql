--index 실습1
create table dept_test2 as
select *
from dept
where 1 = 1; --여기서 where절은 써도되고 안써도 됨

select *
from dept_test2;

create UNIQUE index idx_u_dept_test2_01 on dept_test2 (deptno);
create index idx_u_dept_test2_02 on dept_test2 (dname);
create index idx_u_dept_test2_03 on dept_test2 (deptno, dname);

--index 실습2
drop index idx_u_dept_test2_01;
drop index idx_u_dept_test2_02;
drop index idx_u_dept_test2_03;

--index 실습3
--equals 조건이 일반적으로는 선행조건으로 오는게 유리(사실은 분포(데이터의 수)도 고려해야함)
1]
empno(=)
2]
deptno(=)
3]
ename(=)
4]
deptno(=), mgr=empno
5]
deptno(=), empno(like :empno || '%')
6]
deptno(=), hiredate(=)

create UNIQUE index idx_u_emp_01 on emp (empno);
create index idx_emp_02 on emp (deptno, mgr, hiredate, sal);
create index idx_emp_03 on emp (ename);
-----------------------------------------------------------------------------------------------------------
실행계획

수업시간에 배운 조인
==>논리적 조인 형태를 이야기 함, 기술적인 이야기가 아님
inner join : 조인에 성공하는 데이터만 조회하는 조인 기법
null = '7698'
outer join : 조인에 실패해도 기준이 되는 테이블의 컬럼정보는 조회하는 조인 기법
cross join : 묻지마 조인(카티션 프러덕트), 조인 조건을 기술하지 않아서 연결 가능한 모든 경우의 수로 조인되는 기법
self join : 같은 테이블끼리 조인 하는 형태

개발자가 DBMS에 SQL을 실행 요청 하면 DBMS는 SQL을 분석해서
어떻게 두 테이블 연결할지를 결정,3가지 방식의 조인 방식(물리적 조인 방식, 기술적인 이야기)
1. Nested Loop Join : 이중 루프, 소량의 데이터, 찾는 족족 출력
2. Sort Merge Join : 대량의 데이터, 정렬이 끝나야 출력(응답 느림)
3. Hash Join : 대량의 데이터, 조인 테이블의 건수가 한쪽이 많고 한쪽이 적은 경우, 반드시 연결 조건은 =


OLTP(OnLine Transaction Processing) : 실시간 처리 
                                      ==> 응답이 빨라야 하는 시스템(일반적인 웹 서비스)
OLAP(OnLine Analysis Processing) : 일괄 처리 
                                    ==> 전체 처리 속도가 중요한 경우(은행 이자 계산 -> 새벽 한번에 계산)

