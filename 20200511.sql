부모-자식 테이블 관계

1. 테이블 생성시 순서
 1]부모(dept)
 2]자식(emp)

2.데이터 생성시(insert) 순서
 1]부모(dept)
 2]자식(emp)

3.데이터 삭제시(delete) 순서
 1]자식(emp)
 2]부모(dept)
----------------------------------------------------------------------------
테이블 변경시(테이블이 이미 생성되어 있는 경우) 제약조건 추가 삭제

drop table emp_test;

create table emp_test(
    empno number(4),
    ename varchar2(10),
    deptno number(2)
);

테이블 생성시 제약조건을 특별히 생성하지 않음

테이블 변경을 통한 primary key 추가

문법 : alter table 테이블명 add constraint 제약조건명 제약조건 타입 (적용할 컬럼[,]);
제약조건 타입 : primary key, unique, foreign key, check

alter table emp_test add constraint pk_emp_test primary key (empno);

--primary key를 쓰는 이유? 중복을 방지하려구!

테이블 변경시 제약조건 삭제
문법 : alter table 테이블 이름 drop constraint 제약조건명;

위에서 추가한 제약조건 pk_emp_test 삭제
alter table emp_test drop constraint pk_emp_test;
-------------------------------------------------------------------------------------------------------------
테이블 생성이후 외래키 제약조건 추가 실습
emp_test.deptno ====> dept_test.deptno

dept_tes테이블의 deptno에 인덱스 생성 되어있는지 확인

alter table 테이블명 add constraint 제약조건명 제약조건타입 (컬럼) references 참조테이블명 (참조테이블 컬럼명)

alter table emp_test add constraint fk_emp_test_dept_test foreign key (deptno) references dept_test (deptno);

삭제는 동일;
----------------------------------------------------------------------------------------------------------------
제약조건 활성화 비활성화
테이블에 설정된 제약조건을 삭제 하는 것이 아니라 잠시 기능을 끄고, 켜는 설정
문법 : alter table 테이블명 enable | disable constraint 제약조건명;

위에서 설정한 fk_emp_test_dept_test foreign key 제약조건을 비활성화

alter table emp_test disable constraint fk_emp_test_dept_test;

dept(부모)테이블에는 99번 부서만 존재하는 상황
select *
from dept_test;

fk_emp_test_dept_test 제약조건이 비활성화되어 있기 때문에 emp_test 테이블에는 99번 이외의 값이 입력 가능한 상황

dept_test 테이블에 88번 부서가 없지만 아래 쿼리는 정상적으로 실행
insert into emp_test values (9999,'brown',88);

현재 상황 : emp_test 테이블에 dept_test 테이블에 존재하지 않는 88번 부서를 사용하고 있는 상황
            fk_emp_test_dept_test 제약조건은 비활성화된 상태
            
데이터의 무결성이 깨진 상태에서 fk_emp_test_dept_test를 활성화시키면??
==> 데이터 무결성을 지킬 수 없으므로 활성화 될 수 없다

alter table emp_test enable constraint fk_emp_test_dept_test; --오류
-----------------------------------------------------------------------------------------------------------
emp,dept 테이블에는 현재 primary key, foreign key 제약이 걸려 있지 않은 상황
emp 테이블은 empno를 key로
dept테이블은 deptno를 key로 하는 primary key 제약을 추가하고

emp.deptno ==> dept.deptno를 참조하도록 foreign key를 추가

제약조건 명은 수업시간에 안내한 방법으로 명명

emp pk, dept pk, emp.deptno ==> dept.deptno fk

alter table emp add constraint pk_emp primary key (empno); 
alter table dept add constraint pk_dept primary key (deptno);
alter table emp add constraint fk_emp_dept foreign key (deptno) references dept (deptno);
-----------------------------------------------------------------------------------------------------------
제약조건 확인
1.툴에서 제공해주는 메뉴(테이블 선택==>제약조건 tab)
2.user_constraints : 제약조건 정보(master);
3.user_cons_columns : 제약조건 컬럼 정보(상제);

select *
from user_constraints;

select *
from user_cons_columns;

컬럼확인
1.툴
2.select *
3.desc
4.user_tab_columns(data dictionary, 오라클에서 내부적으로 관리하는 view);

select *
from user_tab_columns
where table_name = 'emp';

select 'select * from ' || table_name || ';'
from user_tables;
--------------------------------------------------------------------------------------------------------------
주석
/**/
select * /*테스트*/
from emp;

테이블,컬럼 주석 : user_tab_comments, user_col_comments;

실제 서비스서 사용되는 테이블의 수는 수십개로 끝나지 않는 경우가 많다
테이블명명 : 카테고리 + 일련번호

select *
from user_tab_comments;

테이블의 주석 생성하기
문법 : comment on table 테이블명 is '주석';

emp테이블에 주석 생성하기
comment on table emp is '직원';

컬럼 주석 확인
select *
from user_col_comments
where table_name = 'EMP'; --테이블명 대문자로 해야함..ㅇㅇ 소문자하면 아무것도 안뜸

컬럼 주석 생성
comment on column 테이블명.컬럼명 is '주석';

empno : 사번, ename : 이름, hiredate : 입사일자 생성 후 user_col_comments를 통해 확인
comment on column emp.empno is '사번';
comment on column emp.ename is '이름';
comment on column emp.hiredate is '입사일자';

--주석을 생성합시다!

--comments 실습1
select *
from user_col_comments
where table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select *
from user_tab_comments
where table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select tab.TABLE_NAME, tab.TABLE_TYPE, tab.COMMENTS as tab_comment, col.COLUMN_NAME, col.COMMENTS as col_comment
from user_tab_comments tab, user_col_comments col
where tab.table_name = col.table_name
    and tab.table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');

select tab.*, col.COLUMN_NAME, col.COMMENTS
from user_tab_comments tab, user_col_comments col
where tab.table_name = col.table_name
    and tab.table_name in ('CUSTOMER','PRODUCT','CYCLE','DAILY');
-------------------------------------------------------------------------------------------------------------
View는 쿼리다
논리적인 데이터 집합 = SQL
물리적인 데이터 집합이 아니다

view 사용 용도
- 데이터 보안(불필요한 컬럼 공개를 제한)
- 자주 사용하는 복잡한 쿼리 재사용
    IN LINE VIEW 를 사용해도 동일한 결과를 만들어 낼 수 있으나
    MAIN 쿼리가 길어지는 단점이 있다

view를 생성하기 위해서는 create view 권한을 갖고 있어야 한다(DBA설정)

system 계정을 통해
grant create view to 뷰생성권한을 부여할 계정명;

문법 : create [or replace] view 뷰이름 [컬럼별칭1, 컬럼별칭2...] as
        select 쿼리;

emp테이블에서 sal, comm 컬럼을 제외한 6가지 컬럼만 조회가 가능한 v_emp view를 생성

create or replace view v_emp as
select empno, ename, job, mgr, hiredate, deptno
from emp;

view (v_emp)를 통한 데이터 조회
select *
from v_emp;

v_emp view는 YOON계정 소유
HR계정에게 인사 시스템 개발을 위해서 EMP테이블이 아닌 SAL,COMM조회가 제한된
v_emp view를 조회할 수 있도록 권한을 부여

[hr계정에서 실행]권한부여전 hr 계정에서 v_emp를 조회
select *
from YOON.v_emp;

[YOON계정에서 실행]YOON계정에서 hr계정으로 v_emp view를 조회할 수 있는 권한 부여
grant select on v_emp to hr;

[hr계정에서 실행]V_emp view 권한을 hr 계정에게 부여한 이후 조회 테스트
select *
from YOON.v_emp;

select *
from YOON.emp; --이 쿼리는 오류. 권한 안줬으니까...ㅇㅇ

--실습
v_emp_dept 뷰를 생성
emp, dept 테이블을 deptno컬럼으로 조인하고
emp.empno, ename, dept.deptno, dname 4개의 컬럼으로 구성

create or replace view v_emp_dept as
select emp.empno, ename, dept.deptno, dname
from emp, dept
where emp.deptno = dept.deptno;

--in line view
select *
from
   ( select emp.empno, ename, dept.deptno, dname
    from emp, dept
    where emp.deptno = dept.deptno);

--view
select *
from v_emp_dept;

view 삭제
문법 : drop view 삭제할 뷰 이름;

drop view v_emp;

인라인뷰 ==> 일회성
뷰 ==> 자주 쓰는 쿼리
------------------------------------------------------------------------------------------------------------
view를 통한 DML 처리
simple view일 때만 가능

simple view : 조인되지 않고, 함수, group by, rownum을 사용하지 않은 간단한 형태의 view
complex view : simple view가 아닌 상태

v_emp : simple view

select *
from v_emp;

v_emp를 통해 7369 SMITH 사원의 이름을 brown으로 변경
update v_emp set ename = 'brown'
where empno = 7369;

select *
from emp;

v_emp 컬럼에는 sal 컬럼이 존재하지 않기 때문에 에러
update v_emp set sal =1000
where empno = 7369;

rollback;
-----------------------------------------------------------------------------------------------------------
SEQUENCE
유일한 정수값을 생성해주는 오라클 객체
인조 식별자 값을 생성할 때 주로 사용

식별자 ==> 해당 행을 유일하게 구별할 수 있는 값
본질 <==> 인조 식별자
본질 : 원래 그러한 것
인조 : 꾸며낸 것

일반적으로 어떤 테이블(앤터티)의 식별자를 정하는 방법은
[누가],[언제],[무엇을]

게시판의 게시글 : 게시글 작성자가 언제 어떤글을 작성 했는지
게시글의 식별자 : 작성자id, 작성일지, 글제목
        ==>본질 식별자가 너무 복잡하기 때문에 개발의 용이성을 위해 
            본질 식별자를 대체할 수 있는(중복되지 않는) 인조 식별자를 사용

개발을 하다보면 유일한 값을 생성해야할때가 생김
ex : 사번, 학번, 게시글 번호
    사번, 학번 : 체계
    사번 : 15101001 - 회사 설립년차 15, 10월 10일, 해당 날짜에 첫번째 입사한 사람 01
    학번 : 
-- 체계가 있는 경우는 자동화되기 보다는 사람의 손을 타는 경우가 많음
    
    게시글 번호 : 체계가 없..., 겹치지 않는 순번
/* 체계가 없는 경우는 자동화가 가능 ==> SEQUENCE 객체를 활용하여 손쉽게 구현 가능
                                  ==>중복되지 않는 정수 값을 반환 */

중복되지 않는 값을 생성하는 방법
1. key table을 생성
    ==> select for update 다른 사람이 동시에 사용하지 못하도록 막는게 가능
    ==> 손이 많이 가는 편, 하지만 값을 아름답게 유지하는게 가능(SEQUENCE에서는 불가능)

2.JAVA의 UUID 클래스를 활용, 별도의 라이브러리 활용(유료) ==> 금융권, 보험, 카드
    ==> jsp 게시판 개발

3.ORACLE DB - SEQUENCE

SEQUENCE 생성
문법 : create sequence 시퀀스명;

seq_emp라는 시퀀스를 생성
create sequence seq_emp;
CREATE SEQUENCE  "YOON"."SEQ_EMP"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE ;

사용법 : 객체에서 제공해주는 함수를 통해서 값을 받아온다
NEXTVAL : 시퀀스를 통해 새로운 값을 받아온다
CURRVAL : 시퀀스 객체의 NEXTVAL를 통해 얻어온 값을 다시 확인할 때 사용
         (트랜잭션에서  NEXTVAL 실행하고 나서 사용이 가능);

select seq_emp.NEXTVAL
from dual;

select seq_emp.CURRVAL
from dual;

select *
from emp_test;

SEQUENCE를 통한 중복되지 않는 empno값 생성 하여 insert 하기
아래 쿼리를 여러번 실행
insert into emp_test values (seq_emp.NEXTVAL, 'sally', 88);