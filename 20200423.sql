NVL(expr1, expr2)
if expr1 == null        
    return expr2
else 
    return expr1
    
NVL2(expr1, expr2, expr3)
if expr1 != null
    return expr2
else 
    return expr3
    
---------------------------------------------------------    
NULLIF(expr1, expr2)
if expr1 == expr2
    return null
else
    return expr1
    
sal 컬럼의 값이 3000이면 null을 리턴
select empno, ename, sal, nullif(sal,3000)
from emp;

------------------------------------------------------------
가변인자 : 함수의 인자의 갯수가 정해져 있지 않음
          가변인자들의 타입은 동일해야함
          display("test"), display("test","test","test"...)
coalesce(expr1,expr2.....)

인자들중에 가장 먼저나오는 null이 아닌 인자 값을 리턴
coalesce(expr1, expr2, expr3....)
if expr1 != null
    return expr1
else
    coalesce(expr2,expr3...)
    
mgr 컬럼 null
comm 컬럼 null

select empno,ename,comm,sal, coalesce(comm,sal)
from emp;
------------------------------------------
--fn4
select empno, ename, mgr, 
        nvl(mgr,9999) as mgr_n,
        nvl2(mgr,mgr,9999) as mgr_n_1,
        coalesce(mgr,9999) as mgr_n_2
from emp;

--fn5
select userid, usernm, reg_dt,
        nvl(reg_dt, sysdate) as n_reg_dt
from users
where userid != 'brown';
------------------------------------------
condition
조건에 따라 컬럼 혹은 표현식을 다른 값으로 대체
java if; switch 같은 개념
1. case 구문
2. decode 함수

1. case
case
    when 참/거짓을 판별할 수 있는 식 true 리턴할 값
    [when 참/거짓을 판별할 수 있는 식 true 리턴할 값]
    [else 리턴할 값 판별식이 참인 when절이 없을 경우 실행)]
end

emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급 할 예정
해당 직원의 job이 salesman일 경우 sal에서 5% 인상된 금액을 보너스로 지급(ex:sal 100->105)
해당 직원이 job이 manager일 경우 sal에서 10% 인상된 금액을 보너스로 지급
해당 직원의 job이 president일 경우 sal에서 20% 인상된 금액을 보너스로 지급
그외 직원들은 sal만큼만 지급

select empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal * 1.05
        when job = 'MANAGER' then sal * 1.10
        when job = 'PRESIDENT' then sal * 1.20
        else sal * 1   
    end
from emp;

2. DECODE(expr1, search1, return1, search2, return2, search3, return3....[default])
    DECODE(expr1, 
            search1, return1, 
            search2, return2, 
            search3, return3....
            [default])
if expr == search1
    return return1
else if expr == search2
    return return2
else if expr == search3
    return return3
.....
else
    return default
    
--decode보다 case가 이것저것(복잡하게) 쓰기 좋음. but 같은 것을 비교한다면 decode가 코드도 깔끔하고 좋음

select empno, ename, job, sal,
    decode(job, 'salesman', sal*1.05, 'manager', sal*1.10, 'president', sal*1.20, sal*1) as bonus
from emp;

--cond1
select empno, ename,
    decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPPERATIONS', 'DDIT') AS DNAME
FROM emp;

select empno, ename,
    case
        WHEN deptno = 10 then 'ACCOUNTING'
        WHEN deptno = 20 then 'RESRARCH'
        WHEN deptno = 30 then 'SALES'
        WHEN deptno = 40 then 'OPERATIONS'
        else 'DDIT'
    end as dname
from emp;

select empno, ename,
    decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPPERATIONS', 'DDIT') AS DNAME,
    case
        WHEN deptno = 10 then 'ACCOUNTING'
        WHEN deptno = 20 then 'RESRARCH'
        WHEN deptno = 30 then 'SALES'
        WHEN deptno = 40 then 'OPERATIONS'
        else 'DDIT'
    end as dname
from emp;
--------------------------------------------------------------------------------------------------
--cond2
(현재 년도 짝/홀수, 직원의 출생년도 짝/홀수)
(1,1)==> 대상자
(1,0)==>비대상자
(0,1)==>비대상자
(0,0)==>대상자;

select empno, ename, hiredate, 
--mod(to_char(sysdate,'yyyy'),2) , mod(to_char(hiredate,'yyyy'),2), 
case
    when mod(to_char(sysdate,'yyyy'),2) = 1 and mod(to_char(hiredate,'yyyy'),2) =1 then '건강검진대상자'
    when mod(to_char(sysdate,'yyyy'),2) = 0 and mod(to_char(hiredate,'yyyy'),2) =0 then '건강검진대상자'
    when mod(to_char(sysdate,'yyyy'),2) = 1 and mod(to_char(hiredate,'yyyy'),2) =0 then '건강검진비대상자'
    when mod(to_char(sysdate,'yyyy'),2) = 0 and mod(to_char(hiredate,'yyyy'),2) =1 then '건강검진비대상자'
end contact_to_doctor
from emp;

select empno, ename, hiredate, 
--mod(to_char(sysdate,'yyyy'),2) , mod(to_char(hiredate,'yyyy'),2), 
case
    when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(hiredate,'yyyy'),2) then '건강검진대상자'
    else '비대상자'
end contact_to_doctor
from emp;

--cond3
select userid, usernm, alias, reg_dt, 
    case
        when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(reg_dt,'yyyy'),2) then '건강검진대상자'
        when mod(to_char(sysdate,'yyyy'),2)!= mod(to_char(reg_dt,'yyyy'),2) then '건강검진비대상자'
        else '건강검진비대상자'
    end as contacttodoctor   
from users;
        
select userid, usernm, alias, reg_dt, 
    case
        when mod(to_char(sysdate,'yyyy'),2) = mod(to_char(reg_dt,'yyyy'),2) then '건강검진대상자'
        else '건강검진비대상자'
    end as contacttodoctor   
from users;
        

