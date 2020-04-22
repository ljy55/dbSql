페이징 처리
    .ROWNUM
    .INLINE-VIEW(오라클 한정)
    .페이징 공식
    .바인드 변수
----------------------------------------------------------------------------------------
함수 : 로직을 모듈화 한 코드
==> 실제 사용(호출)하는 곳과 함수가 구현되어있는 부분을 분리 ==> 유지보수의 편의성을 도모
 함수를 사용하지 않을 경우
    호출하는 부분에 함수 코드를 직접 기술해야 하므로, 코드가 길어진다 ==> 가독성이 나빠진다

오라클 함수를 구분
입력 구분 : 
    . single row function
    . multi row fumction
    
제작자 구분 : 
 . 내장 함수 : 오라클에서 제공해주는 함수
 . 사용자 정의 함수 : 개발자가 직접 정의한 함수(pl/sql 배울 때)
 ----------------------------------------------------------------------------------------
 프로그래밍언어, 식별이름 부여....중요한 원칙
 
 DUAL TABLE
 
 SYS계정에 속해 있는 테이블
 오라클의 모든 사용자가 공통으로 사용할 수 있는 테이블
 
 한개의 행, 하나의 컬럼(dummy)-값은'x';
 
 사용 용도
 1. 함수를 테스트할 목적
 2.  merge 구문
 3. 데이터 복제
 
 오라클 내장 함수 테스트(대소문자 관련)
 LOWER, UPPER, INITCAP : 인자로 문자열 하나를 받는다;
 
 SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
 FROM dual;
 
 SELECT empno, 5, 'test', LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
 FROM emp;
 
 함수는 whrere절에서도 사용이 가능하다
 emp 테이블의 SMITH 사원의 이름은 대문자로 저장되어 있음 : 데이터값은 대소문자를 가린다
 
 SELECT *
 FROM emp
 WHERE ename = 'smith'; 테이블에는 데이터 값이 대문자로 저장되어 있으므로 조회건수0
 WHERE ename = 'SMITH'; 정상 실행
 WHERE ename = UPPER ('smith'); 아래 방식과 비교해 아래보다는 지금것이 더 올바른 방식이다(smith만 대문자로)
 WHERE UPPER(ename) = 'smith'; 이런식으로 작성하면 안된다->행 갯수만큼 전부 다 바꿔버림(즉 행 갯수만큼 실행됨)//컬럼을 건드리지 마라,,
 -------------------------------------------------------------------------------------------------------
 문자열 연산 함수
 CONCAT : 2개의 문자열을 입력으로 받아, 결합한 문자열을 반환한다--(CONCAT('Hello','World'))->이 자체가 하나의 문자열이 되는거임
 
 SELECT CONCAT('start', 'end')
 FROM dual;
 
SELECT table_name, tablespace_name, CONCAT('start','end'),
        CONCAT(table_name, tablespace_name),
        'SELECT * FROM ' || table_name || ';' --CONCAT 함수로 작성하기(단 ||은 사용하지 않는다)
FROM user_tables;

SELECT table_name, tablespace_name, CONCAT('start','end'),
        CONCAT(table_name, tablespace_name),
        CONCAT(CONCAT('SELECT * FROM ',table_name),';') 
FROM user_tables;

SUBSTR(문자열,시작 인덱스,종료 인덱스) : 문자열의 시작 인덱스 부터 종료 인덱스 까지의 부분 문자열
시작인덱스는 1부터(*java의 경우는 0부터)

LENGTH(문자열) : 문자열의 길이를 반환

INSTR(문자열,찾을 문자열,[검색 시작 인덱스]) : 문자열에서 찾을 문자열이 존재하는지, 존재할 경우 찾을 문자열의 인덱스(위치) 반환

LPAD, RPAD(문자열, 맞추고 싶은 전체 문자열 길이, [패딩 문자열-기본 값은 공백])

REPLACE(문자열, 검색할 문자열, 변경할 문자열) : 문자열에서 검색할 문자열을 찾아 변경할 문자열로 변경

TRIM(문자열) : 문자열 앞 뒤의 존재하는 공백을 제거, 문자열 중간에 있는 공백은 제거 대상이 아님

SELECT SUBSTR('Hello, World', 1, 5) as  sub,
       LENGTH('Hello, World') as len,
       INSTR('Hello, World','o') as ins,
       INSTR('Hello, World','o',6) as ins2,
       INSTR('Hello, World','o',INSTR('Hello, World','o')+1) as ins3,
       LPAD('hello', 15, '*') as lp,
       RPAD('hello', 15, '*') as rp,       
       REPLACE('Hello, World', 'll', 'LL') as rep,
       TRIM('      He llo      ') as tr,
       TRIM('H' FROM 'Hello') as trr
FROM dual;
----------------------------------------------------------------------------------------------------
NUMBER 관련 함수
ROUND(숫자, [반올림 위치-defalt 0]) : 반올림
 ROUND(105.54, 1) : 소수점 첫번째자리까지 결과를 생성 ==> 소수점 두번째 자리에서 반올림
  : 105.5
TRUCK(숫자, [내림 위치-defalt 0]) : 내림
MOD(피제수, 제수) : 나머지 연산

SELECT  round(105.54, 1) as ro1,
        round(105.55, 1) as ro2,
        round(105.55, 0) as ro3,
        round(105.55, -1) as ro4
FROM dual;

SELECT  TRUNC(105.54, 1) as t1,
        TRUNC(105.55, 1) as t2,
        TRUNC(105.55, 0) as t3,
        TRUNC(105.55, -1) as t4
FROM dual;

select mod(10, 3), sal, mod(sal, 1000)
from emp;
-----------------------------------------------------------------------------------------------
날짜 관련 함수
SYSDATE : 사용중인 오라클 데이터베이스 서버의 현재 시간, 날짜를 반환한다
        함수이지만 인자가 없는 함수
        (인자가 없을 경우 JAVA : 메소드()
                        SQL : 함수명)

date type +- 정수 : 일자 더하기 빼기
정수 1 = 하루
1/24 = 한시간
1/24/60 = 일분

리터럴
 숫자 
 문자:'' 
 날짜:to_date('날짜 문자열','포맷')

SELECT SYSDATE
FROM dual;

--fn1        
select to_date('2019/12/31','yyyy/mm/dd') as lastday,
        to_date('2019/12/31','yyyy/mm/dd')-5 as lastday_before5,
        sysdate as now,
        sysdate -3 as now_before3
FROM dual;

TO_DATE(문자열,포맷) : 문자열을 포맷에 맞게 해석하여 날짜 타입으로 형변환
TO_CHAR(날짜,포맷) : 날짜 타입의 포맷에 맞게 해석하여 문자 타입으로 형변환
YYYY : 년도
MM : 월
DD : 일자
D : 주간일자(1~7, 1-일요일, 2-월요일....7-토요일)
IN : 주차 (52주~53주)
HH : 시간(12시간)
HH24 : 24시간 표기
MI : 분
SS : 초

현재시간(SYSDATE) 시분초 단위까지 표현 ==> TO_CHAR을 이용하여 형변환

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as now,
        TO_CHAR(SYSDATE, 'd') as d,
        TO_CHAR(SYSDATE -3, 'YYYY/MM/DD HH24:MI:SS') as now_before3,
        TO_CHAR(SYSDATE -1/24, 'YYYY/MM/DD HH24:MI:SS') as now_before3
from dual;

--fn2
select to_char(sysdate,'yyyy-mm-dd') as dt_dash,
        to_char(sysdate,'yyyy-mm-dd hh24-mi-ss')as dt_dash_wth_time,
        to_char(sysdate, 'dd-mm-yyyy') as dt_dd_mm_yyyy
from dual;
-----------------------------------------------------------------------------------------------------
months_between(date1,date2) : date1과 date2사이의 개월수를 반환
4가지 날짜 관련함수중에 사용 빈도가 낮음
select months_between (to_date('2020/04/21', 'yyyy/mm/dd'),to_date('2020/03/21', 'yyyy/mm/dd')) as a,
       months_between (to_date('2020/04/22', 'yyyy/mm/dd'),to_date('2020/03/21', 'yyyy/mm/dd')) as b
from dual;

add_months(date1,가감할 개월 수) : date1로부터 두번째 입력된 개월 수 만큼 가감한 date
오늘 날짜로부터 5개월 뒤  날짜
select add_months(sysdate, 5) as dt1,
       add_months(sysdate, -5) as dt2
from dual;

next_day(date1,주간일자) : date1 이후 등장하는 첫번째 주간일자의 날짜를 반환
select next_day(sysdate, 7)
from dual;

last_day(date1) : date1이 속한 월의 마지막 날짜를 반환
select last_day(sysdate)
from dual;

날짜가 속한 월의 첫번째 날짜 구하기(1일)
sysdate = 20200421==>20200401

select sysdate, last_day(sysdate), last_day(sysdate)+1, 
        add_months(last_day(sysdate)+1, -1)
from dual;

select to_date(to_char(sysdate,'yyyymm') || '01' , 'yyyymmdd')
from dual;


