--과제1
/*select sido, sigungu
from tax

minus

select sido,sigungu
from fastfood;*/ --누락되는 자료 있는지 검증

select a.sido, a.sigungu, a.city_idx, q.tax
from
(select rownum rank, sido, sigungu, city_idx
from
(select sido, sigungu, round((kfc + mac + bk) / lot ,2) city_idx
from
(select sido, sigungu, 
        nvl(sum(case when gb = '롯데리아' then 1 end), 1) lot, 
        nvl(sum(case when gb = 'KFC' then 1 end), 0) kfc,
        nvl(sum(case when gb = '맥도날드' then 1 end), 0) mac, 
        nvl(sum(case when gb = '버거킹' then 1 end), 0) bk
from fastfood
where gb in ('버거킹','KFC','맥도날드','롯데리아')
group by sido, sigungu)
order by city_idx desc)) a,
(select rownum rank, sido, sigungu, tax
from
    (select sido, sigungu, round(sal/people,2) tax
    from tax
    order by tax desc)) q 

where a.rank(+) = q.rank;

--과제2
fastfood 테이블 한번만 읽고 도시발전지수 구하기;

개별 햄버거점의 주소(파파이스, 맘스터치 제외하고 계산)
select rownum, sido, sigungu, city_idx
from
(select sido, sigungu, round((kfc + mac + bk) / lot ,2) city_idx
from
(select sido, sigungu, 
        nvl(sum(case when gb = '롯데리아' then 1 end), 1) lot, 
        nvl(sum(case when gb = 'KFC' then 1 end), 0) kfc,
        nvl(sum(case when gb = '맥도날드' then 1 end), 0) mac, 
        nvl(sum(case when gb = '버거킹' then 1 end), 0) bk
from fastfood
where gb in ('버거킹','KFC','맥도날드','롯데리아')
group by sido, sigungu)
order by city_idx desc);

----------------------------------------------------------------------------------------------------
DNL
데이터를 입력(INSERT), 수정(UPDATE), 삭제(DELETE) 할 때 사용하는 SQL

INSERT

구문
INSERT INTO 테이블명[(테이블의 컬럼명,....)] VALUES(입력할 값,.....);

크게 다음 두가지 형태로 사용
1.테이블의 모든 컬럼에 값을 입력하는 경우, 컬럼명을 나열하지 않아도 된다
  단, 입력할 값의 순서는 테이블에 정의된 컬럼 순서로 인식된다
INSERT INTO 테이블명 VALUES (입력할 값, 입력할 값2...);

2.입력하고자 하는 컬럼을 명시하는 경우
  사용자가 입력하고자 하는 컬럼을 선택하여 데이터를 입력할 경우
  단, 테이블에 NOT NULL 설정이 되어있는 컬럼이 누락되면 INSERT는 실패한다
INSERT INTO 테이블명 (컬럼1, 컬럼2) VALUES (입력할 값, 입력할 값2);

3.select 결과를 insert 
  select 쿼리를 이용해서 쿼리에 의해 조회되는 결과를 테이블에 입력 가능
  ==> 여러건의 데이터를 하나의 쿼리로 입력 가능 (ONE-QUERY)==> 성능 개선
  
  사용자로부터 데이터를 직접 입력 받는 경우 (ex 회원가입)는 적용이 불가
  db상에 존재하는 데이터를 갖고 조작하는 경우 활용 가능(이런 경우가 많음)
  
  insert into 테이블명 [(컬럼명1, 컬럼명2...)]
  select .....
  from .....
----------------------------------------------------------------------------------------------------------------
dept 테이블에 deptno 99, dname DDIT, loc daejeon 값을 입력하는 INSERT 구문 작성
select *
from dept;

INSERT INTO dept VALUES (99, 'DDIT', 'daejeon');
rollback;

데이터를 확정 지으려면  : commit - 트랜잭션 완료
데이터 입력을 취소 하려면 : rollback - 트랜잭션 취소

INSERT INTO dept (loc, deptno, dname) values ('deajeon', 99, 'DDIT');
rollback;

위의 insert 구문은 고정된 문자열, 상수를 입력한 경우
---------------------------------------------------------------------------------------------------------------------
insert 구문에서 스칼라 서브쿼리, 함수도 사용 가능
ex : 테이블에 데이터가 들어갈 당시의 일시정보를 기록 하는 경우가 많음 ==>sysdate;

select *
from emp;

emp 테이블의 경우 컬럼 총 개수는 8개, not null은 1개(empno)
empno가 9999이고 ename은 본인이름, hiredate는 현재 일시를 저장하는 insert 구문을 작성
insert into emp (empno, ename, hiredate) values (9999, '이지윤', sysdate);

9998번 사번으로 jw사원을 입력, 입사일자는 2020년4월13일로 설정하여 데이터 입력
insert into emp (empno, ename, hiredate) values (9998, 'jw', to_date('20200413','yyyymmdd'));

empno테이블은 not null(desc emp), 아래 쿼리 실행하면 오류남
insert into emp (ename, hiredate) values ('jw', to_date('20200413','yyyymmdd'));
----------------------------------------------------------------------------------------------------------------------
select 결과를 테이블에 입력하기(대량 입력);

desc dept;

dept 테이블에는 4건의 데이터가 존재(10~40)
아래쿼리를 실행하면 기존 존재 4건 + select로 입력되는 4건 총 8건의 데이터가 dept 테이블에 입력됨
insert into dept
select *
from dept;

데이터 확인
select *
from dept;
---------------------------------------------------------------------------------------------------------------------
UPDATE : 데이터 수정
UPDATE 테이블명 SET 수정할 컬럼1 = 수정할 값1,
                   [수정할 컬럼1 = 수정할 값1, .....]
[WHERE condition-SELECT 절에서 배운 WHERE절과 동일
        수정할 행을 인식하는 조건을 기술]

dept 테이블에 99,ddit,daejeon;
insert into dept values (99, 'DDIT', 'deajeon');

데이터 입력 확인
select *
from dept;

99번 부서의 부서명을 대덕IT로, 위치를 영민빌딩으로 변경
update dept set dname = '대덕IT', loc = '영민빌딩'
where deptno = 99;

아래 쿼리는 dept 테이블의 모든 행의 부서명과 위치를 변경하는 쿼리
update dept set dname = '대덕IT', loc = '영민빌딩'

insert : 없던 걸 새로 생성
update, delete : 기존에 있는걸 변경, 삭제
 ==> 쿼리를 작성할 경우 주의
        1. where절이 누락되지 않았는지
        2. update, delect 문을 실행하기전에 where절을 복사해서 select를 하여
           영향이 가는 행을 눈으로 확인
           
서브쿼리를 이용한 데이터 수정;
insert into emp (empno, ename, job) values (9999, 'brown', null);

9999번 직원의 deptno, job 두개의 컬럼을 smith 사원의 정보와 동일하게 변경
update emp set deptno = (select deptno from emp where ename = 'SMITH'), 
                job = (select job from emp where ename = 'SMITH') 
where empno = 9999;
일반적인 update 구문에서는 컬럼별로 서브쿼리를 작성하여 비효율이 존재
==> merge 구문을 통해 비효율을 제거 할 수 있다

where절로 위의 쿼리 제대로 작성했는지 확인하기!
select *
from emp
where empno = 9999;

변경사항을 취소
rollback;
-----------------------------------------------------------------------------------------------------------
delete : 테이블에 존재하는 데이터를 삭제
구문
delete [from] 테이블명
[where condition]

주의점
1. 특정 컬럼만 값을 삭제 ==> 해당 컬럼을 null로 update
    delete절은 행 자체를 삭제
2. update 마찬가지로 delete 쿼리를 실행하기 전에 select를 통해 삭제 대상이되는 행을 조회, 확인하자

삭제 테스트 데이터 입력;
insert into emp (empno, ename, job) values (9999, 'brown', null);

사번이 9999번인 행을 삭제 하는 쿼리 작성
delete emp
where empno = 9999;

where절로 위의 쿼리 제대로 작성했는지 확인하기!
select *
from emp
where empno = 9999;

rollback;

아래 쿼리의 의미 : emp 테이블의 모든 행을 삭제
delete emp;

select *
from emp;

rollback;

update, delete 절의 경우 테이블에 존재하는 데이터에 변경, 삭제를 하는 것이기 때문에
대상 행을 제한하기 위해 where 절을 기술할 수 있고
where절을 select 절에서 사용한 내용을 적용 할 수 있다
예를 들어 서브쿼리를 통한 행의 제한이 가능

매니저가 7698인 직원들을 모두 삭제 하고 싶을 때
delete emp
where empno in
        (select empno
        from emp
        where mgr = 7698);

select *
from emp
where mgr = 7698;

rollback;

DML : select, insert, update, delete
where 절을 사용 사능한 DML : select, update, delete
    3개의 쿼리는 데이터를 식별하는 where절이 사용 될 수 있다
    데이터를 식별하는 속도에 따라 쿼리의 실행 성능이 좌우 됨
    ==> index 객체를 통해 속도 향상이 가능

insert : 빈공간에 신규 데이터를 입력 하는 것
         빈공간을 식별하는게 중요
         ==> 개발자가 할 수 있는 튜닝 포인트가 많이 않음
         
테이블의 데이터를 지우는 방법 (모든 데이터 지우기)
1. delete : where절을 기술하지 않으면 됨
2. truncate
    사용법 : truncate table 테이블명
    특징 : 1) 삭제시 로그를 남기지 않음
            ==> 복구가 불가능
          2) 로그를 남기지 않기 때문에 실행 속도가 빠르다
            ==> 운영환경에서는 잘 사용하지 않음 (복구가 안되기 때문에)
                테스트 환경에서 주로 사용
                
데이터를 복사하여 테이블 생성(따라 해보기)

create table emp_copy as 
select *
from emp;

select *
from emp_copy;

emp_copy 테이블을 truncate 명령을 통해 모든 데이터를 삭제
truncate table emp_copy;

select *
from emp_copy;

rollback;

트랜잭션 : 논리적인 일의 단위
ex : ATM - 출금과 입금이 둘다 정상적으로 이루어져야 문제가 발생되지 않음
            출금은 정상 처리 되었지만 입금이 비정상 처리 되었다면
            정상 처리된 출금도 취소를 해줘야 한다
            
출금
입금(실패)
rollback;

오라클에서는 첫번째 DML이 시작이 되면 트랜의 시작으로 인식
트랜잭션은 rollback, commit을 통해 종료가 된다

트랜잭션 종료 후 새로운 DML이 실행되면 새로운 트랜잭션이 시작


평소 사용하는 게시판을 생각해보자
게시글 입력할 때 입력 하는것 : 제목(1개), 내용(1개), 첨부파일(복수 가능)
RDBMS에서는 속성이 중복될 경우 별도의 엔터티(테이블)로 분리를 한다
게시글 테이블(제목,내용) / 게시글 첨부파일 테이블(첨부파일에 대한 정보)

게시글을 하나 등록을 하더라도
게시글 테이블과, 게시글 첨부파일 테이블에 데이터를 신규로 등록을 한다
insert into 게시글 테이블 (제목, 내용, 등록자, 등록일시) values (....);
insert into 게시글 첨부파일 테이블 (첨부파일명, 첨부파일사이즈) values (....);

두개의 insert 쿼리가 게시글 등록의 트랜잭션 단위
즉 두개중에 하나라도 문제가 생기면 일반적으로 rollback을 통해 두 개의 insert 구문을 취소