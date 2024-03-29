2024-0327-02) 집합연산자
-  SELECT 문의 결과를 집합으로 보고 각 집합에 대한 합집합, 차집합, 교집합 결과를
반환할 때 사용
- 여러 개의 SELECT문이 연결되어 하나의 결과로 반납 받을 때 사용
- UNION, UNION ALL, INTERSECT, MINUS 연산자 제공
- 각 SELECT 문의 SELECT절에 사용된 컬럼의 수와 타입은 반드시 일치해야함 (컬럼도 동일
컬럼을 사용해야 의미상 오류를 발생시키지 않음)
- 반환되는 컬럼들의 컬럼명은 첫 번째 SELECT문에 사용된 컬럼이 적용됨
- ORDER BY절은 가장 마지막 SELECT문에만 사용 가능

** 다음 테이블을 생성하고 아래 데이터를 입력하시오
    테이블명 : BUDGET_TBL
           컬럼 : PERIOD  CHAR(6)
                     BUDGET_AMT NUMBER(5)
    데이터
    -----------------------------------------------------
           PERIOD                 BUDGET_AMT
    ----------------------------------------------------- 
            202201                        10000
            202202                          5000
            202203                        15000
            202204                        20000
            202205                        21000
            202206                        20000
            
    테이블명 : SALE_TBL
           컬럼 : PERIOD  CHAR(6)
                     BUDGET_AMT NUMBER(5)
    데이터
    -----------------------------------------------------
           PERIOD                 BUDGET_AMT
    ----------------------------------------------------- 
            202201                          8000
            202202                          6500
            202203                        12000
            202204                        18000
            202205                        23000
            202206                        15000
            
 1. UNION (ALL)
 - 합집합의 결과를 반환
 - 구조가 다른 여러 테이블에서 동일형태의 자료를 추출하는 경우
    (테이블을 횡으로 합친 결과)
- 컬럼을 행으로 전환한 후 조회할 때
   (테이블을 분할한 후 분할된 테이블들의 내용을 결합하여 행으로 반환)
   
(사용형식)
 SELECT 문
  UNION | UNION ALL
  SELECT 문
        :

 . UNION : 공통부분의 중복을 허용하지 않음
 . UNION ALL : 공통부분의 중복을 허용함
 
사용 예시)
 SELECT JOB_ID, SALARY
    FROM HR.EMPLOYEES
  WHERE SALARY BETWEEN 2000 AND 3000
 UNION
 SELECT JOB_ID,SALARY
    FROM HR.EMPLOYEES
  WHERE SALARY BETWEEN 5000 AND 6000;
  
  
사용 예시)
상품테이블에서 분류코드 'P201'에 속한 판매가격이 30000~50000사이의 상품과
판매가격이 30000 이상인 상품들을 조회하시오
 Alias는 상품코드, 상품명, 분류코드, 판매가격이며 판매가격이 큰 상품부터 출력하시오
 
 SELECT PROD_ID AS 상품코드,
                PROD_NAME AS 상품명,
                PROD_LGU AS 분류코드,
                PROD_PRICE AS 판매가격
 FROM PROD
 WHERE UPPER(PROD_LGU)='P201'
 AND PROD_PRICE BETWEEN 30000 AND 50000
 UNION
  SELECT PROD_ID AS 상품코드,
                PROD_NAME AS 상품명,
                PROD_LGU AS 분류코드,
                PROD_PRICE AS 판매가격
 FROM PROD
 WHERE PROD_PRICE>=30000
ORDER BY 4 DESC;

사용 예시) 2022년 계획대비 판매실적을 조회하시오
SELECT PERIOD AS 년월,
              BUDGET_AMT AS 계획,
              0 AS 실적
    FROM BUDGET_TBL
UNION
SELECT PERIOD, 0, SALE_AMT
FROM SALE_TBL
ORDER BY 1, 2 DESC;

SELECT A.PER AS 기간,
              SUM(A.BUDGET) AS 계획,
              SUM(A.SALE) AS 실적,
              LPAD(ROUND(SUM(A.SALE)/SUM(A.BUDGET)*100)||'%',6,' ') AS 달성율
    FROM ( SELECT PERIOD AS PER, 
                                BUDGET_AMT AS BUDGET, 0 AS SALE
                     FROM BUDGET_TBL
                UNION
                  SELECT PERIOD, 0, SALE_AMT 
                     FROM SALE_TBL ) A
GROUP BY A.PER
ORDER BY 1;

2. INTERSECT
    - 교집합(공통부분)의 결과를 반환함
    
사용 예시) 2020년 5월 매입과 판매가 모두 발생된 상품을 조회하시오.
상품코드, 상품명, 매입가

SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_COST AS 매입가
FROM BUYPROD A, PROD B
WHERE A.BUY_DATE BETWEEN TO_DATE('20200501') AND TO_DATE('20200531')
AND A.BUY_PROD=B.PROD_ID
INTERSECT
SELECT A.CART_PROD,
              B.PROD_NAME,
              B.PROD_PRICE
FROM CART A, PROD B
WHERE SUBSTR(CART_NO,1,6)='202005'
AND A.CART_PROD=B.PROD_ID
-- 내용까지 같아야 하나로 취급

사용 예시 ) 2020년 5월 6월 7월에 구매한 회원을 조회하시오
SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 이름
FROM CART A, MEMBER B
WHERE A.CART_MEMBER=B.MEM_ID
AND SUBSTR(CART_NO,1,6)='202005'
INTERSECT
SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 이름
FROM CART A, MEMBER B
WHERE A.CART_MEMBER=B.MEM_ID
AND SUBSTR(CART_NO,1,6)='202006'
INTERSECT
SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 이름
FROM CART A, MEMBER B
WHERE A.CART_MEMBER=B.MEM_ID
AND SUBSTR(CART_NO,1,6)='202007'


(조인)
SELECT DISTINCT D.MEM_ID,
                              D.MEM_NAME
FROM (SELECT CART_MEMBER
                FROM CART
             WHERE SUBSTR(CART_NO,1,6)='202005') A,
          (SELECT CART_MEMBER
              FROM CART
            WHERE SUBSTR(CART_NO,1,6)='202006') B,
         (SELECT CART_MEMBER
              FROM CART
            WHERE SUBSTR(CART_NO,1,6)='202007') C, MEMBER D
WHERE D.MEM_ID=A.CART_MEMBER
      AND D.MEM_ID=B.CART_MEMBER
      AND D.MEM_ID=C.CART_MEMBER
      
 3. MINUS 연산자
 - 차집합의 결과를 반환
 (사용형식)
 A MINUS B : A의 원소 중 B의 원소를 제거한 값
 B MINUS A : B의 원소 중 A의 원소를 제거한 값

사용 예시)
2020년 6월에는 판매되었지만 2020년 7월에는 판매되지 않은 상품 조회
SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
FROM CART A, PROD B
WHERE A.CART_PROD=B.PROD_ID
AND SUBSTR(CART_NO,1,6)='202006'
AND A.CART_PROD NOT IN(SELECT DISTINCT CART_PROD
                                                FROM CART
                                             WHERE SUBSTR(CART_NO,1,6)='202007');
 
SELECT C.CID
    FROM ( SELECT B.CART_PROD AS CID
                    FROM (SELECT DISTINCT CART_PROD
                                    FROM CART
                                    WHERE CART_NO LIKE '202006%'
                                     ORDER BY 1) B
                WHERE B.CART_PROD NOT IN (SELECT DISTINCT CART_PROD
                                                                     FROM CART
                                                                    WHERE CART_NO LIKE '202007%')) C
 ORDER BY 1;


SELECT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
FROM CART A, PROD B
WHERE A.CART_PROD=B.PROD_ID
AND SUBSTR(CART_NO,1,6)='202006'
MINUS
SELECT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 이름
FROM CART A, PROD B
WHERE A.CART_PROD=B.PROD_ID
AND SUBSTR(CART_NO,1,6)='202007'

    
              
            
            
            
            
            
            
            
            
            