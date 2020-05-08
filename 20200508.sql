제약 조건
1. PRIMARY KEY
2. UNIQUE
3.FOREIGN KEY
4. CHECK
    -NOT NULL
5. NOT NULL
    CHECK 제약 조건이지만 많이 사용하기 때문에 별도의 KEWORD를 제공
    
NOT NULL 제약조건
:컬럼에 값이 NULL이 들어오는 것을 방지하는 제약 조건

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14) not null,
	loc varchar2(13)
);

dname 컬럼에 설정된 not null 제약조건에 의해 아래 insert 구문은 실패한다
insert into dept_test values (99, null, 'daejeon');

문자열의 경우 ''를 null로 인식한다
아래의 insert 구문도 에러(test)
insert into dept_test values (99, '', 'daejeon');
---------------------------------------------------------------------------------------------------------
unique 제약
해당컬럼에 동일한 값이 중복되지 않도록 제한
테이블의 모든행중 해당 컬럼에 값은 중복되지 않고 유일해야함
ex : 직원 테이블의 사번 컬럼, 학생 테이블의 학번 컬럼

DROP TABLE dept_test;

select *
form dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14) unique,
	loc varchar2(13)
);

dept_test 테이블의 dname 컬럼은 unique 제약이 있기 때문에 동일한 값이 들어갈 수 없다
insert into dept_test values (99, 'ddit', 'daejeon');
insert into dept_test values (98, 'ddit', '대전');

DROP TABLE dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0),
	dname varchar2(14),
	loc varchar2(13),
    
    --constraint 제약조건명 제약조건타입 (컬럼,...)
      constraint u_dept_test unique (dname, loc)
);

dname컬럼과 loc컬럼이 동시에 동일한 값이어야만 중복으로 인식
밑에 두개의 쿼리는 데이터 중복이 아니므로 정상 실행
insert into dept_test values (99,'ddit','deajeon');
insert into dept_test values (98,'ddit','대전');

아래 쿼리는 unique 제약 조건에 의해 입력되지 않는다
insert into dept_test values (97,'ddit','대전');

select *
from dept_test;
---------------------------------------------------------------------------------------------------
foreign key 제약조건
입력하고자 하는 데이터가 참조하는 테이블에 존재할 때만 입력 허용
ex : emp 테이블에 데이터를 입력할 때 deptno 컬럼의 값이 dept 테이블에 존재하는 deptno 값이어야 입력 가능

데이터 입력시(emp) 참조하는 테이블(dept)에 데이터 존재 유무를 빠르게 알기 위해서 
참조하는 테이블(dept)의 컬럼(deptno)에 인덱스가 반드시 생성 되어 있어야만
foreign key 제약조건을 추가 할 수 있다

unique 제약조건을 생성할 경우 해당 컬럼의 값 중복 체크를 빠르게 하기 위해서
오라클에서는 해당 컬럼에 인덱스가 없을 경우 자동으로 생성한다

primary key 제약조건 : unique 제약 + not null
primary key 제약조건만 생성해도 해당 컬럼으로 인덱스를 생성 해준다

foreign key 제약조건은 참조하는 테이블이 있기 때문에 두개의 테이블간 설정한다

DROP TABLE dept_test;

CREATE TABLE dept_test(
	deptno number(2, 0) primary key,
	dname varchar2(14),
	loc varchar2(13)
);

insert into dept_test values (99,'ddit','deajeon');
commit;

select *
from dept_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0) references dept_test (deptno)
);

현재 부서 테이블에는 99번 부서만 존재
foreign key 제약조건에 의해 emp 테이블의 deptno 컬럼에는 99번 이외의 부서번호는 입력될 수 없다

99번 부서는 존재 하므로 정상적으로 입력 가능
insert into emp_test values (9999, 'brown', 99);

98번 부서는 존재 하지 않으므로 정상적으로 입력할 수 없다
insert into emp_test values (9998, 'sally', 98);
-------------------------------------------------------------------------------------------------------
foreign key 제약조건 테이블 레벨에서 기술

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0), 
    
    --constraint 제약조건명 제약조건타입 컬럼 references 참조하는 테이블(컬럼)
    constraint fk_emp_test_dept_test foreign key (deptno) references dept_test (deptno)
);

rollback;

--인덱스  : 검색 할 때 속도향상을 할 수 있게 하는 것..ㅇㅇ(속도 개선 가능하게 함)
------------------------------------------------------------------------------------------------------
외래키와 데이터 삭제

select *
from dept_test;

select *
from emp_test;

(9999, 'brown', 99) ==> (99, 'ddit', 'daejeon');
emp_test.deptno ==> dept_test.deptno 참조 중

dept_test 테이블의 99번 부서의 데이터를 지우면 어떻게 될까?
(9999, 'brown', 99) ==> 

부모 레코드(dept_test.deptno)를 참조하고 있는 자식 레코드(emp_test.deptno)가 존재하기 때문에 
자식 레코드 입장에서는 데이터 무결성이 깨지게 되어 정상적으로 삭제 할 수 없다
delete dept_test
where deptno = 99;
-----------------------------------------------------------------------------------------------------------------
참조키와 관련된 데이터를 삭제시 부여할 수 있는 옵션

부모 데이터를 삭제시..
foreign key 옵션에 따라 자식 데이터를 처리할 수 있는 옵션
1. defualt ==> 참조하고 있는 부모가 삭제 될 수 없다
2. on delete cascade ==> 부모가 삭제되면 참조하고 있는 자식 데이터도 같이 삭제
3. on delete set null ==> 부모가 삭제되면 참조하고 있는 자식 데이터를 null로 설정

쌤 주관적 의견 : default 가 맞다..ㅇㅇ
1.개발자가 테이블의 순서를 명확하게 알고 있어야지만 로직 제어할 수 있음
    ==>지우거나, 입력 할 데이터의 순서를 알고 있어야 함
2.테이블 명세서가 정확하지 않으면 신규 개발자는 해당 내용을 모를 수가 있음
    (java 코드 + 테이블 내역 확인 필요)
    java코드에는 dept테이블만 삭제하는 코드가 있는데
    신기하게도 emp테이블의 데이터가 삭제되거나 null로 설정되는 경우를 볼 수 있음
-------------------------------------------------------------------------------------------------------------------
check 제약조건 : 컬럼의 값을 제한하는 제약 조건

emp 테이블에서 급여정보(sal)를 관리 할때 sal 컬럼의 값은 0보다 작은 값이 들어가는 것은 로직적으로 이상함
sal 컬럼의 값이 음수가 들어가지 않도록 체크 제약 조건을 이용하여 방지 할 수 있다

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    sal number(7, 2) check (sal > 0),
    deptno number(2, 0) references dept_test (deptno)
);

아래 쿼리는 정상 실행
insert into emp_test values (9999, 'brown', 1000, 99);
아래 쿼리는 sal 컬럼에 설정된 check 제약조건(sal > 0 에 의해 정상적으로 실행되지 않는다)
insert into emp_test values (9998, 'sally', -1000, 99);

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    sal number(7, 2),
    deptno number(2, 0) references dept_test (deptno),
    --테이블 레벨 sal 체크 제약조건 기술 후 테스트
    --constraint 제약조건명 제약조건타입 컬럼
     constraint sal_check check (sal > 0) 
);
-----------------------------------------------------------------------------------------------
CTAS : create table as
select 결과를 이용하여 테이블을 생성하는 명령
not null 제약조건 제외한 다른 제약조건은 복사되지 않는다
용도
    1. 개발자 레벨의 백업
    2. 개발자 레벨의 테스트
    
문법
create table 테이블명 ([컬럼명,...]) as
    select 쿼리;

dept_test 테이블을 복사 ==> dept_test_copy
create table dept_test_copy as
select *
from dept_test;

데이터 없이 테이블을 복사 하고 싶을 떄
create table dept_test_copy2 as
select *
from dept_test
where 1 != 1;

select *
from dept_test_copy2;

직원 검색 기능을 개발
요구조건 : 직원 이름으로 검색 or 전체 검색 or 급여 검색..+통합 검색

직원 이름 검색
select *
from emp
where ename like '%' || 검색 키워드 || '%';

전체 검색
select *
from emp;

급여 검색
select *
from emp
where sal > 검색값

--JAVA + SQL
/*String sql = " select * ";
       sql += " from emp ";
       sql += " where 1 = 1"; 
if(사용자가 급여검색을 요청 했다면){
    sql += " and sal > " + 사용자가 입력한 검색값;
}
if(사용자가 급여검색을 요청 했다면){
    sql += " and ename like '%' || " + 사용자가 입력한 검색값 + " '%' ";
}*/

table 수정
지금까지 위에서 table 생성만 했음
이미 생성된 테이블을 수정 할 수도 있음
    1. 새로운 컬럼을 추가
       ******새로운 컬럼은 테이블의 마지막 컬럼으로 추가가 된다
       ******기존 생성되어 있는 컬럼 중간에는 새로운 컬럼을 추가할 수가 없다
            ===> 기존 테이블을 삭제하고 컬럼순서를 조정한 새로운 테이블 생성 DDL로 새롭게 만들어야 함
                 운영중이라면 이미 데이터가 쌓여있을 가능성이 굉장히 높음
                 ==> 테이블을 생성할 때 신중하게 컬럼 순서를 고려
    2. 기존 컬럼 삭제, 컬럼 이름 변경, 컬럼 사이즈 변경, (타입도 제한적으로 변경 가능)
        참조키가 걸려있는 테이블의 컬럼 이름을 변경하더라도 참조하는 테이블에는 영향이 가지 않음(알아서 이름을 변경 해준다)
        emp_test.deptno ==> dept_test.deptno 참조
        dept_test.deptno 이름변경하여 dept_test.dno로 수정하더라도 fk(foreign key)는 변경된 이름으로 잘 유지가 된다
    3. 제약 조건추가


기존 테이블에 새로운 컬럼 추가
alter table 테이블명 add (컬럼명, 컬럼타입);

drop table emp_test;

create table emp_test(
    empno number(4, 0) primary key,
    ename varchar2(10),
    deptno number(2, 0) references dept_test (deptno)
);

desc emp_test;
---------------
emp_test 테이블이 hp 컬럼(varchar2(20)을 신규로 추가

--alter table 테이블명 add (컬럼명, 컬럼타입);
alter table emp_test add (hp varchar2(20));
---------------
컬럼 사이즈, 타입 변경
alter table 테이블명 modify (컬럼명 컬럼타입)

위에서 추가한 hp 컬럼의 컬럼 사이즈를 20에서 30으로 변경-->사이즈를 늘리는건 값이 있어도 가능. 축소는 불가능
alter table emp_test modify (hp varchar2(30));

위에서 추가한 hp 컬럼의 타입을 varchar2(30)에서 date로 변경-->hp 컬럼에 값이 없어서 가능했음. 값이 있으면 실행안됨
alter table emp_test modify (hp date);

데이터가 존재하는 컬럼에 대해서는 타입 변경이 불가능 하다
insert into emp_test values (9999, 'brown', 99, sysdate);
alter table emp_test modify (hp varchar2(30));
-----------------
컬럼 이름 변경
alter table 테이블명 rename column 기존컬럼명 to 신규컬럼명;

위에서 추가한 emp_test 테이블의 hp 컬럼을 hp_n으로 이름 변경
alter table emp_test rename column hp to hp_n;
-----------------
컬럼 삭제
alter table 테이블명 drop (삭제할 컬럼명)
alter table 테이블명 drop column 삭제할 컬럼명

위에서 추가한 emp_test 테이블에 hp_n 컬럼을 삭제;
alter table emp_test drop (hp_n);
alter table emp_test drop column hp_n
---------------------------------------------------------------------------------------

SQL 종류
DML : SELECT, INSERT, UPDATE, DELETE ==> 트랜잭션 제어 가능(취소 가능)
DDL : CREATE...., ALTER......==> 트랜잭션 제어 불가능(취소가 안된다) / 자동 커밋(내가 그전에 실행한 DML문장도 다 커밋됨..ㅇㅇ)

기존 ename은 brown ==> sally로 변경
update emp_test set ename = 'sally'
where empno = 9999;

select *
from emp_test;

롤백 또는 커밋을 안함

alter table emp_test add (hp number);
 desc emp_test;
 
 rollback;
 
 select *
 from emp_test;
 
 DDL은 자동 커밋이기 때문에 DML 문장에도 영향을 받는다
 DDL을 실행 할 경우 주의깊게 이전에 했던 작업을 살펴 볼 필요가 있다
 SQLD 시험 단골 문제