2024-0311-01) 연산자
 - 산술연산자(+, -, *, /), 비교(관계)연산자(>, <, ==,>= , <=, !=(<>)), 
   논리연산자(NOT, AND, OR), 기타연산자(IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE)
 - WHERE절에 사용될 조건문 구성이나 표현식의 조건문에 사용
 - FROM->WHERE->SELECT 절 순서로 수행

  -- 외래키는 변형하지않고 그대로 쓰기 EX. BUYER_LGU <- LPROD_GU 분류코드 (안좋은 예)
  -- MEMBER는 예약어이므로 MEMBER 단어는 지양해야함
  
   사용 예시) 회원테이블에서 마일리지가 3000이상인 회원의 정보를 조회하시오.
                    Alias는 회원번호, 회원명, 직업, 성별, 마일리지
                    단, 성별 별로 출력
                    -- ( 조건 : 마일리지 3000이상 )
                    -- ( 성별은 검사해서 조회)
    SELECT MEM_ID AS 회원번호,
                 MEM_NAME AS 회원명,
                 MEM_JOB AS 직업,
                 CASE WHEN SUBSTR (MEM_REGNO2, 1 , 1 ) IN ( '2' , '4' ) THEN '여성회원'
                           ELSE '남성회원' END AS 성별,
                 MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE>=3000
        ORDER BY CASE WHEN SUBSTR (MEM_REGNO2, 1 , 1 ) IN ( '2' , '4' ) THEN '여성회원'
                           ELSE '남성회원' END;

   사용 예시) 상품테이블에서 매출가격이 50만원 이상인 상품을 조회하시오.
                    Alias는 상품번호, 상품명, 분류코드, 매출가격
                    단, 분류코드별로 조회하시오.
                -- ( 조건 : 매출가격이 50만원 이상)
    SELECT PROD_ID AS 상품번호,
              PROD_NAME AS 상품명,
              PROD_LGU AS 분류코드,
              PROD_PRICE AS 매출가격
            FROM PROD
            WHERE PROD_PRICE>=500000
            ORDER BY 3;
            
            
1. 산술연산자 ( +, -, /, *)
 - 연산 결과는 수치데이터
 
 사용 예시) 이번달 급여를 계산하여 출력하시오.
                  지급액은 기본급(SALARY)+보너스이다.
                  보너스는 기본급(SALARY)*영업실적(COMMISSION_PCT) 의 50% 이다.
                  Alias는 사원번호(EMPLOYEE_ID), 사원명(EMP_NAME), 기본급(SALARY),
                 보너스(BONUS), 지급액(SLAARY_AMT) 이다.
  SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               SALARY AS 기본급,
               COMMISSION_PCT AS 영업실적,
               NVL(SALARY*COMMISSION_PCT*0.5,0)  AS 보너스,
               SALARY+NVL(SALARY*COMMISSION_PCT*0.5,0) AS 지급액
               -- 변수가 없어 그대로 대입 /  PL/SQL에선 사용가능
               -- 사용자가 데이터를 입력하지 않으면 데이터타입에 상관없이 NULL값이 들어감
               -- NULL과 산술이 되면 NULL값이 나옴
        FROM HR.EMPLOYEES;
        
        
2. 비교(관계)연산자 (>, <, >=, <=,=, !=(<>))와 논리연산자 (NOT, AND, OR)
    - 연산결과는 참(true) 또는 거짓 (false)
    - 조건무 구성에 사용
    - 논리연산자는 하나 이상의 조건문을 결합할 때 사용
    --------------------------------------------------------------------------
                입력                                                   출력
     --------------------------------------------------------------------------
           A             B                 AND            OR           EX-OR
     --------------------------------------------------------------------------
           0              0                      0                0              0
           0              1                      0                1              1      
           1              0                      0                1              1
           1              1                      1                1              0
     --------------------------------------------------------------------------
     
    사용 예시) 매입정보(BUYPROD) 테이블에서 2020년 1월 매입수량이 10개 이상인
                    정보만 출력하시오
                    Alias는 매입일자, 매입상품코드, 수량
 SELECT BUY_DATE AS 매입일자,
              BUY_PROD AS 매입상품코드,
              BUY_QTY AS 수량
                        FROM BUYPROD
                        WHERE BUY_DATE >= TO_DATE('20200101')
                                    AND BUY_DATE<=TO_DATE('20200131') 
                                    AND BUY_QTY>=10;
                        
    사용 예시) 매입정보(BUYPROD) 테이블에서 2020년 1월 매입금액을 계산하시오
                    Alias는 매입일자, 매입상품코드, 수량, 단가, 금액
  SELECT BUY_DATE AS 매입일자,
               BUY_PROD AS 매입상품코드,
               BUY_QTY AS 수량,
               BUY_COST AS 단가,
               BUY_QTY*BUY_COST AS 금액
       FROM BUYPROD
       WHERE BUY_DATE >= TO_DATE('20200101') 
       AND BUY_DATE<=TO_DATE('20200131') 
    
    사용 예시) 매입정보(BUYPROD) 테이블에서 2020년 1월 매입금액이 100만원 이상인 매입만 조회하시오
                    Alias는 매입일자, 매입상품코드, 수량, 단가, 금액
  SELECT BUY_DATE AS 매입일자,
               BUY_PROD AS 매입상품코드,
               BUY_QTY AS 수량,
               BUY_COST AS 단가,
               BUY_QTY*BUY_COST AS 금액
        FROM BUYPROD
        WHERE BUY_DATE >= TO_DATE('20200101') AND BUY_DATE<=TO_DATE('20200131') 
        --BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131)
        AND BUY_QTY*BUY_COST>=1000000;
        
        
        <숙제>
        
    사용 예시) 회원테이블에서 직업이 '주부'이면서 마일리지가 2000이상인 회원의
                    회원번호, 회원명, 직업,마일리지를 조회하시오.
 SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지
        FROM MEMBER
        WHERE MEM_JOB='주부' 
            AND MEM_MILEAGE >= 2000;
                    
    사용 예시) 2020년 6월 제품을 구매하지 않은 회원을 조회하시오
                    Alias는 회원번호
                    -- 구매정보는 CART
   -- 6월에 구매한 회원번호
   SELECT DISTINCT CART_MEMBER AS 회원번호
        FROM CART
            WHERE CART_NO LIKE '202006%' ;   

  -- 6월에 구매하지않은 회원번호
   SELECT MEM_ID AS 회원번호,
                MEM_NAME AS 이름
            FROM MEMBER
             WHERE MEM_ID NOT IN( SELECT DISTINCT CART_MEMBER
                                                     FROM CART
                                                    WHERE CART_NO LIKE '202006%' ) ;
 
    사용 예시) HR계정 사원테이블에서 영업실적이 없는 사원들을 조회하시오
                    Alias는 사원번호, 사원명, 부서코드
 SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서코드
        FROM HR.EMPLOYEES
        WHERE COMMISSION_PCT IS NULL;
        -- NVL(COMMISSION_PCT,0)=0
                    
    사용 예시) HR계정 사원테이블에서 소속부서가 없는 사원들을 조회하시오
                    Alias는 사원번호, 사원명, 입사일, 급여, 직무코드
   SELECT EMPLOYEE_ID AS 사원번호,
                 FIRST_NAME AS 사원명,
                 HIRE_DATE AS 입사일,
                 SALARY AS 급여,
                 MANAGER_ID AS 직무코드
        FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID IS NULL;                  
                
    
    
    
           