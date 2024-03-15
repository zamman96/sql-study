2024-0314-01)  숫자함수
 1. 수학적함수
 ABS(n1)
- 주어진 숫자자료 n1의 절대값 반환
SIGN(n1)
- 주어진 숫자자료 n1의 음수이면 -1, 0이면 0, 양수이면 1을 반환
POWER(n1, n2)
- n1을 n2번 거듭 곱한 결과(n1의 n2승)
SQRT(n1)
- n1의 평방근(루트) 반환

사용예시)
 SELECT ABS(-10), ABS(200),
               SIGN(-100000), SIGN(0.00001), SIGN(0),
               POWER(2,10), POWER(10,10),
               SQRT(3.3)
     FROM DUAL;
   
 2. GREATEST(n1,n2, ... , n), LEAST(n1,n2, ... , n)
   - 주어진 데이터 n1 ~ n 값중 가장 큰 값(GREATEST) 또는 가장 작은 값(LEAST)으로 반환
   - GREATEST와 LEAST는 한 행에서 큰 값 | 작은 값을 구할 때 사용하고
     MAX(컬럼명), MIN(컬럼명)은 한 컬럼에서 최대(최소) 값을 구할 때 사용한다
   - 문자열도 적용할 수 있음
   
사용예시)
 SELECT GREATEST (100, 50, 900),
               ASCII('홍'),
               GREATEST ('홍길동', 23000, '대한민국')
      FROM DUAL;
      
SELECT LEAST(PROD_COST, PROD_PRICE, PROD_SALE)
  FROM PROD;
      
사용예시)
회원테이블에서 회원들의 마일리지를 조회하여 1000미만인 회원의 마일리지를 1000으로,
1000이상인 회원마일리지는 해당회원의 마일리지는 그대로 출력하시오.
Alias는 회원번호, 회원명, 보유마일리지, 변경마일리지
SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 보유마일리지,
              GREATEST(MEM_MILEAGE,'1000')  AS 변경마일리지
  FROM MEMBER;
  
 3. ROUND(n1, loc), TRUNC(n1, loc)
   - 주어진 수 n1에서 소숫점 이하 loc+1번째 자리에서 반올림(ROUND) 또는 자리버림(TRUNC)을 하여
     loc자리까지 반환
   - loc가 생략되면 0으로 간주되어 소숫점 이하를 잘라버림
   - loc가 음수이면 정수부분의 loc자리에서 반올림(ROUND)/자리버림(TRUNC)을 수행함
  
사용 예시) 
HR계정의 사원테이블에서 각 부서별 평균 임금을 구하시오
Alias는 부서번호, 부서명, 평균임금
평균임금은 소숫점 1자리까지 출력
SELECT A.DEPARTMENT_ID AS 부서번호,
              B.DEPARTMENT_NAME AS 부서명,
              ROUND(AVG(A.SALARY),1) AS 평균임금1,
              TRUNC(AVG(A.SALARY),1) AS 평균임금2,
              ROUND(AVG(A.SALARY),-2) AS 평균임금3,
              TRUNC(AVG(A.SALARY),-2) AS 평균임금4
        FROM HR.EMPLOYEES A, HR.DEPARTMENTS B  -- JOIN
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        
 4. FLOOR(n1), CEIL(n1)
  -  FLOOR : 주어진 수 n1과 같거나(n1이 정수) n1보다 작은 가장 큰 정수
  - CEIL : 주어진 수 n1과 같거나(n1이 정수) n1보다 큰 가장 작은 정수
  
  사용예시)
SELECT FLOOR(123.5678), FLOOR(23), FLOOR(-123.4567),
              CEIL(123.5678), CEIL(23), CEIL(-123.4567)
   FROM DUAL;
 
 5. MOD(n1, n2)
  - 주어진 수 n1을 n2로 나눔 나머지 반환
  - 자바의 '%'연산자와 동일
  - 내부 연산방식 : 나머지=n1 - n2 * FLOOR(n1/n2)
    
사용 예시)
 SELECT MOD(21,5), MOD(21,8) FROM DUAL;
 
사용 예시)
키보드로 년도를 입력받아 윤년과 평년을 구별하시오
윤년 : ( (4의 배수이면서) (100의 배수가 아니거나)) 또는 (400의 배수)가 되는 해

ACCEPT P_YEAR PROMPT '년도입력 : '
DECLARE
    L_YEAR NUMBER := TO_NUMBER('&P_YEAR');  -- 크기를 지정하지 않으면 시스템이 알아서 지정 NUMBER(4)
    L_RESULT VARCHAR2(500);                                
    L_FLAG BOOLEAN := FALSE;
BEGIN
    L_FLAG:=(MOD(L_YEAR,4)=0 AND MOD(L_YEAR,100)!=0 ) OR MOD(L_YEAR,400)=0;
    IF L_FLAG=FALSE THEN
        L_RESULT:=L_YEAR||'년은 평년입니다.';
    ELSE
        L_RESULT:=L_YEAR||'년은 윤년입니다.';
    END IF;
    DBMS_OUTPUT.PUT_LINE(L_RESULT);
END;

 6. WIDTH_BUCKET(n1, min_val, max_val, block_count)
    - min_val에서 max_val 까지의 구간을 block_count 개수의 그룹으로 나누었을 때
      주어진 값 n1이 그 중 어느 구간에 포함되었는지를 구간의 순번을 반환
    - 각 구간의 범위는 '구간 하한값'<=구간<'구간 상한값' 으로 구간 상한값은 해당 구간에 포함되지 않고
      다음 구간에 포함된다.
    - 표현하는 구간의 수는 block_count+2개임 ('max_val'보다 큰 구간, 'min_val'미만 구간 표현)
    
사용 예시)
회원테이블에서 회원들의 마일리지를 조회하여 회원 등급을 부여하시오
회원등급은 1000~8000 까지 7로 구분하고 등급명은 다음과 같다
1 미만 : 새싹회원
1-2 등급 :  평회원
3-5 등급 : 열심회원
6 이상 등급 : VIP회원
Alias는 회원번호, 회원명, 마일리지, 등급, 회원등급명이다
SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지,
              WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) AS 등급,
CASE WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7)<1THEN '새싹회원'
          WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7)<3 THEN '평회원'
          WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7)<5 THEN '열심회원'
          ELSE 'VIP회원'                                                      
END AS 회원등급명
        FROM MEMBER;

    UPDATE MEMBER
    SET MEM_MILEAGE = 7500
    WHERE LOWER(MEM_ID)='s001';
    
    COMMIT;
    
사용 예시) 
회원테이블에서 회원들의 마일리지를 조회하여 회원 등급을 부여하시오
회원등급은 1000~8000까지 7로 구분하고 마일리지가 많은 회원부터 1 등급에서 등급값이 큰 등급을 순차적으로 부여하시오
Alias는 회원번호, 회원명, 마일리지, 등급이다
SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지,
              9-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) AS 등급
    --        WIDTH_BUCKET(MEM_MILEAGE,8000,1000,7)+1 AS 등급
    FROM MEMBER;
