2024-0312-01) 기타연산자
    - IN, ANY(SOME), ALL, EXISTS, LIKE, BETWEEN, IS(IS NOT)
    
1. IS (IS NOT)
 - NULL값을 비교할 때 사용하는 연산자
 - NULL은 '='연산자로 동등성을 평가할 수 없음
 사용 예시) 상품테이블에서 크기 (PROD_SIZE)컬럼에 데이터가 없는 상품을 조회하시오
                Alias는 상품코드, 상품명, 매출가격, 크기
 SELECT PROD_ID AS 상품코드,
               PROD_NAME AS 상품명,
               PROD_PRICE AS 매출가격,
               PROD_SIZE AS 크기
        FROM PROD
        WHERE PROD_SIZE IS NULL;
    
 2. IN 연산자
    (사용형식)
        컬럼명 IN(값1, 값2, ...,값n)
  . '컬럼명'의 값이 '값1'이거나 또는 '값2'이거나 또는 .... '값n'이면 전체가 참을 반환
  . OR 연산자로 대신할 수 있음
  . (   ) 안에 서브쿼리가 올 수 있음
  . '값1, 값2, ...,값n'에 포함되지 않는 경우를 판단할 때는 NOT IN(값1, 값2, ....,값n) 사용
  . 주로 불연속적이거나 비규칙적인 값들에 대한 OR연산이 필요할 때 사용
  . IN연산자에는 '=' 기능이 내포
  
 사용 예시)
 HR계정의 부서테이블에서 20, 30, 60, 90, 110번 부서의 부서코드, 부서명, 관리사원번호를
                조회하시오.
    SELECT DEPARTMENT_ID AS 부서코드,
                 DEPARTMENT_NAME AS 부서명,
                 MANAGER_ID AS 관리사원번호
    FROM HR.DEPARTMENTS
    WHERE DEPARTMENT_ID IN (20, 30, 60, 90, 110);
  --WHERE DEPARTMENT_ID = 20 OR DEPARTMENT_ID = 30 
  --       OR  DEPARTMENT_ID = 60 OR DEPARTMENT_ID = 90 OR DEPARTMENT_ID = 110;    
 
 사용 예시)
 회원테이블에서 다음을 조회하시오
 회원번호, 회원명, 주민번호,나이, 연령대
 단, 나이는 주민등록번호를 이용하시오
  SELECT MEM_ID AS 회원번호, 
                MEM_NAME AS 회원명, 
                MEM_REGNO1 || '-' || MEM_REGNO2 AS 주민번호,
                CASE WHEN SUBSTR(MEM_REGNO2,1,1) = '1' OR 
                                      SUBSTR(MEM_REGNO2,1,1) = '2' THEN
                                      --SUBSTR(MEM_REGNO2,1,1) IN ('1','2') THEN
                          EXTRACT( YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900)
               ELSE 
                        EXTRACT( YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+2000)                    
               END  AS 나이,
               ROUND ((CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','2') THEN
                         EXTRACT( YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900)
               ELSE 
                         EXTRACT( YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+2000)                  
               END)/10)*10 ||'대'  AS 연령대            
     FROM MEMBER;
      
 3. ANY(SOME) 연산자
 (사용형식)
    컬럼명 관계연산자 ANY(값1, 값2, ..., 값n)
    . '컬럼명'의 값이 ANY다음 ( ) 안의 값 중 어느 하나와 과 기술된 '관계연산자'의
      조건을 만족하면 결과가 참이 되는 연산자
    . ANY와 SOME은 동일함
    . ANY 앞의 관계연산자가 '='인 경우가 IN 연산자
    
사용 예시)
사원테이블에서 20번 부서의 최소급여, 40번 부서의 최소 급여, 70번부서의 최소 급여보다
더 많은 급여의 사원을 조회하시오.
Alias 사원번호, 사원명, 부서번호, 급여
 (20번 부서 최소급여, 40번부서 최소급여, 70번부서의 최소급여)
                6000                    6500                     10000
SELECT EMPLOYEE_ID AS 사원번호, 
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
    FROM HR.EMPLOYEES
    WHERE SALARY >ANY(6000,6500,10000)
    ORDER BY 4;
    
 SELECT EMPLOYEE_ID AS 사원번호, 
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
    FROM HR.EMPLOYEES
    WHERE SALARY >ANY(SELECT MIN (SALARY)
                                             FROM HR.EMPLOYEES
                                            WHERE DEPARTMENT_ID IN(20,40,70))
    ORDER BY 4;   

사용 예시)
대전거주 회원 중 충남에 거주하는 회원들의 가장 적은 마일리지보다 더 많은 마일리지를
보유한 회원의 회원번호, 회원명, 마일리지를 조회하시오
(충남거주 회원들의 마일리지)

    
    SELECT MEM_ID AS 회원번호,
                  MEM_NAME AS 회원명,
                  MEM_MILEAGE AS 마일리지
        FROM MEMBER
      WHERE MEM_ADD1 LIKE '대전%'
            AND MEM_MILEAGE >ANY (SELECT MEM_MILEAGE
                                                        FROM MEMBER
                                                        WHERE MEM_ADD1 LIKE '충남%')
        ORDER BY 3;

 4. ALL 연산자
  (사용형식)
    컬럼명 관계연산자ALL(값1, 값2, ... , 값n)
    . '컬럼명'의 값이 ALL 다음 ( ) 안의 값 중 어느 하나와 기술된 '관계연산자'의 조건을 만족하면
      결과가 참이 되는 연산자
    . 관계연산자에 '='은 사용할 수 없다
    
 5. LIKE 연산자
  - 패턴을 비교하는 연산자
  - 와일드카드로 '%'와 '_'를 사용함
  - '%'
   '%'가 사용된 이후 모든 문자열과 대응됨
   .ex) '김%' -> '김'으로 시작되는 모든 문자열은 모두 허용됨 (NULL 포함)
         '%김' -> '김'으로 끝나는 모든 문자열은 모두 허용
         '%김%' -> 단어 중 '김' 글자가 포함된 모든 문자열은 모두 허용
         
  - '_'
   '_'가 사용된 이후 하나의 문자열과 대응됨
   .ex) '김_' -> '김'으로 시작하고 2글자인 문자열과 대응
         '_김' -> '김'으로 끝나는 2글자의 문자열과 대응
         '_김_' -> 3글자로 구성된 단어 중 '김' 글자가 포함된 모든 문자열은 모두 허용
 - LIKE 연산자는 문자열 비교에 사용되며, 많은 결과를 산출하기 때문에 쿼리의 효율성은 낮은편임
 - 문자열이외의 자료(날짜, 숫자) 에 사용은 자제할 것
 
 사용 예제)
 회원테이블에서 거주지가 대전인 회원들의 이름, 주소, 직업, 마일리지를 조회하시오.
 SELECT MEM_NAME AS 이름,
               MEM_ADD1 ||' '|| MEM_ADD2 AS 주소,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_ADD1 LIKE '대전%';
    -- WHERE SUBSTR(MEM_ADD1,1,2)='대전'; 
 
 사용 예제)
 장바구니에서 2020년 5월 판매정보를 조회하시오
  Alias는 회원번호, 상품번호, 구매수량
  SELECT CART_MEMBER AS 회원번호,
                CART_PROD AS 상품번호,
                CART_QTY AS 구매수량
    FROM CART
    WHERE CART_NO LIKE '202005%';
  
  사용 예제)
  매입테이블에서 2020년 2월 매입정보를 조회하시오.
  Alias는 일자, 상품번호, 매입수량, 매입금액
  매입금액= 수량* 단가
   SELECT BUY_DATE AS 일자,
                 BUY_PROD AS 상품번호,
                 BUY_QTY AS 매입수량,
                 BUY_QTY*BUY_COST AS 매입금액
            FROM BUYPROD
            WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201'));
            
 6. BETWEEN 연산자
  - 모든 자료형에 사용가능
  - 구간을 정할때 사용
  (사용 형식)
    컬럼명 BETWEEN 하한값 AND 상한값
    . 논리연산자 AND로 치환 가능함
    
    사용 예시)
    매입테이블(BUYPROD)에서 2020년 3월 1일부터 3월 15일까지 매입정보
    (매입일자(BUY_DATE), 매입상품(BUY_PROD), 매입수량(BUY_QTY))를  일자순으로 조회하시오.
    SELECT BUY_DATE AS 매입일자,
                  BUY_PROD AS 매입상품,
                  BUY_QTY AS 매입수량
            FROM BUYPROD
            WHERE BUY_DATE BETWEEN TO_DATE('20200301') AND TO_DATE('20200315')
            ORDER BY 1;
    
    사용 예시)
    매출테이블에서 2020년 6~7월에 판매된 상품 중 분류코드 'P100' ~ 'P200'에 속한 상품들의 매출정보
    (날짜, 상품코드, 매출수량)를 날짜, 분류코드 순으로 조회하시오.
    SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 날짜,
                  CART_PROD AS 분류코드,
                  CART_QTY AS 매출수량
            FROM CART
            WHERE SUBSTR(CART_NO,1,6) BETWEEN '202006' AND '202007' 
                  AND SUBSTR(CART_PROD,1,2) BETWEEN 'P1' AND 'P2'
            ORDER BY 1, SUBSTR(CART_PROD,1,4);