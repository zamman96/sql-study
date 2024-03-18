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

 3. NEXT_DAY(d1, fmt)
    - 주어진 날짜 d1이후 처음 만나는 'fmt' 요일의 날짜를 반환
    - fmt : '월요일', '월', '화요일', .... 등 의 요일명
    
사용 예시)
SELECT NEXT_DAY(SYSDATE,'월요일') FROM DUAL;

 4. LAST_DAY(d1)
    - 주어진 날짜 d1에 포함된 월의 마지막 날짜
    - 주로 2월의 마지막일자나 사용자가 실행 중 입력 받은 날짜 월의 마지막 일자를
      구할 때 사용
      
사용 예시)
매입테이블에서 2020년 2월 매입건수를 구하시오
SELECT COUNT(*) AS 매입건수
   FROM BUYPROD
 WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201'));

사용 예시)
키보드로 월을 입력 받아 해당 월의 전체 매출금액 합계를 구하시오.
ACCEPT P_MONTH  PROMPT '월 입력 :  '
DECLARE
    L_SDAY  DATE := TO_DATE('2020'||TRIM('&P_MONTH')||TRIM('01'));
    L_EDAY  DATE := LAST_DAY(L_SDAY); 
    L_AMT    NUMBER := 0;
BEGIN
    SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO L_AMT
        FROM CART A, PROD B
        WHERE A.CART_PROD=B.PROD_ID
              AND TO_DATE(SUBSTR(A.CART_NO,1,8)) BETWEEN L_SDAY AND L_EDAY;
 
    DBMS_OUTPUT.PUT_LINE(EXTRACT(MONTH FROM L_SDAY)||'의 매출 합계 : '|| L_AMT);
END;

5. MONTHS_BETWEEN(d1, d2) 
    - 두 날짜자료  d1과 d2 사이의 달수를 반환
    
사용 예시)
사원테이블에서 근속년수를 구하시오. 근속년수는 월까지 고려하여 구하시오.
SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))||'개월' AS 근속월수,
              TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)||'년 '||
              TRUNC(MOD(MONTHS_BETWEEN(SYSDATE,HIRE_DATE),12))||'개월' AS 근속년수
 FROM HR.EMPLOYEES;

 6. EXTRACT(fmt FROM d1)
    - 주어진 날짜자료 d1에서 fmt를 반환
    - fmt는 YEAR, MONTH, DAY, HOUR, MINUTE, SECOND 이며 반환되는 값의
      타입은 숫자형이다.
      
사용 예시)
사원테이블에서 각 월별 입사인원수를 조회하시오.
SELECT EXTRACT(MONTH FROM HIRE_DATE) AS  월,
              COUNT(*)  AS 사원수
   FROM HR.EMPLOYEES
GROUP BY EXTRACT(MONTH FROM HIRE_DATE)
ORDER BY 1;

사용 예시)
매입테이블에서 2020년 상반기 월별 매입집계를 조회하시오.
SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY*B.PROD_PRICE) AS 매입금액합계
FROM BUYPROD A, PROD B
WHERE A.BUY_PROD=B.PROD_ID
     AND EXTRACT(YEAR FROM A.BUY_DATE)=2020
     AND EXTRACT(MONTH FROM A.BUY_DATE) BETWEEN 1 AND 6
GROUP BY EXTRACT(MONTH FROM A.BUY_DATE)
ORDER BY 1;

 7. ROUND(d1), TRUNC(d1) 
    - 주어진 날짜자료 d1을 시간 단위에서 반올림 또는 자리버림 수행
