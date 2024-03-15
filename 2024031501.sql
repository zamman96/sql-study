2024-0315-01) 날짜함수
 1. SYSDATE
    - 시스템의 날짜를 반환
    - '+' 와 '-' 연산의 대상이 됨

사용 예시)
회원테이블의 생년월일 자료를 이용하여 매주 월요일에 조회할 때, 이번주에 생일인 회원들에게
문자메세지를 보내려고 한다. 해당 회원들을 조회하시오
Alias 회원번호, 회원명, 생년월일, 핸드폰번호
SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_BIR AS 생년월일,
              MEM_HP AS 핸드폰번호
   FROM MEMBER
WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR)
     AND EXTRACT(DAY FROM MEM_BIR) BETWEEN EXTRACT(DAY FROM SYSDATE)
                                                                          AND EXTRACT(DAY FROM SYSDATE+7);
    
 2. ADD_MONTHS(d1,n) 
    - 주어진 날짜자료 d1에  n개월을 더한 날짜 반환
사용 예시)
HR 계정의 사원테이블에서 입사일(HIRE_DATE)을 15년을 더한 날짜로 변경하시오
UPDATE HR.EMPLOYEES
SET HIRE_DATE=ADD_MONTHS(HIRE_DATE,180);

SELECT EMP_NAME,HIRE_DATE
FROM HR.EMPLOYEES;
COMMIT;

** UPDATE 문의 사용 형식
 UPDATE 테이블명
 SET 컬럼명=값[,]
                :
        컬럼명=값
[WHERE 조건]
 
- NEXT_DAT, LAST_DAY : (주어진 날짜 이후 가장 빠른 요일을 반환, 가장 마지막날을 반환)
- MONTHS_BETWEEN() : (두 날짜자료 사이의 달수를 반환)
- EXTRACT() : (주어진 날짜에서 원하는 부분만 출력)
- ROUND(), TRUNC() : (반올림, 올림)

