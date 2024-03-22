2024-0321-02) 조인 (JOIN)
 - 필요한 자료가 복수개의 테이블에 분산되어 저장되어 있으며
   공통의 컬럼으로 관계를 형성하고 있을 때 이 관계를 이용하여 자료를 추출하는
   연산이 JOIN이다.
 - 구분
    내부조인(INNER JOIN) / 외부조인(OUTER JOIN)
    일반조인 / ANSI JOIN
     그 밖에 CARTESIAN JOIN (CROSS JOIN), NATURAL JOIN
1. 내부조인
 - 조인조건에 일치하는 자료만으로 결과를 도출
 - 조인조건을 만족하지 않는 자료는 무시함
 - 동등조인(EQUI-JOIN), 비동등조인(NONE EQUI-JOIN), INNER JOIN(ANSI JOIN)
 (일반 조인 사용형식)
    SELECT [테이블별칭.] 컬럼명 [AS 별칭] [,]
                                    :
                  [테이블 별칭.] 컬럼명 [AS 별칭]
        FROM 테이블명 [별칭], 테이블명 [별칭] [, 테이블명 [별칭] ... ]
     WHERE 조인조건
      [AND 일반조건]
                  :
     - 테이블명 [별칭] : 사용되는 모든 테이블의 컬럼명이 모두 다른 경우 '별칭'은 생략 가능
     - '테이블 별칭'은 SELECT 절이나 WHERE 절 등에서 이름이 동일한 컬럼명들을
       참조할때는 반드시 사용해야 함
    - 조인조건 : 사용되는 테이블 사이의 공통 컬럼을 동등연산자('=')으로 사용한 조건식이나
       (EQUI-JOIN), 동등연산자('=') 이외의 연산자를 사용한 조건식(NONE EQUI-JOIN)을 기술
    - 조인조건과 일반조건은 AND 연산자로 연결함
   
    (ANSI조인 사용형식)
    SELECT [테이블별칭.] 컬럼명 [AS 별칭] [,]
                                    :
                  [테이블 별칭.] 컬럼명 [AS 별칭]
        FROM 테이블명 [별칭]
        INNER JOIN 테이블명 [별칭]  ON ( 조인조건 [ AND 일반조건] )
        INNER JOIN 테이블명 [별칭]  ON ( 조인조건 [ AND 일반조건] )  
                                                :
    [ WHERE 일반조건]
    
 1) CARTESIAN JOIN (CROSS JOIN)
  - 조인조건이 생략되었거나 잘못된 조인조건이 부여된 경우
  - 결과는 두 테이블의 행은 곱한 갯수와 열은 더한 결과를 반환
  - 반드시 필요한 경우가 아니면 수행 자제
(ANSI FORMAT)
    SELECT column_list
        FROM table_name
    CROSS JOIN table_name [ON join_condition] ;
    
사용 예시)
SELECT COUNT(*)
    FROM BUYPROD, PROD, CART;
    
SELECT COUNT(*)
    FROM BUYPROD
    CROSS JOIN PROD
    CROSS JOIN CART;
    
    2) 동등조인(Equi join)
    - 조인조건에 동등연산자 '='이 사용된 조인
    - 대부분의 조인이 동등조인임
    
사용 예시) 
사원테이블에서 근속년수가 5년 이상인 사원들의 사원번호, 사원명, 부서명, 입사일을
조회하시오
SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_NAME AS 부서명,
              HIRE_DATE AS 입사일
FROM HR.EMPLOYEES, HR.DEPARTMENTS
WHERE HR.EMPLOYEES.DEPARTMENT_ID = HR.DEPARTMENTS.DEPARTMENT_ID
AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >=5;

(ANSI JOIN)

SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_NAME AS 부서명,
              HIRE_DATE AS 입사일
FROM HR.EMPLOYEES A
INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >=5;
--INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID AND
-- EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >=5);


사용 예시)
2020년 1~3월 제품별 매입집계를 조회하시오
Alias는 제품코드, 제품명, 매입수량, 매입금액
SELECT A.PROD_ID AS 제품코드,
              A.PROD_NAME AS 제품명,
              SUM(B.BUY_QTY) AS 매입수량,
              SUM(BUY_QTY*PROD_COST) AS 매입금액
FROM PROD A, BUYPROD B
WHERE B.BUY_DATE BETWEEN TO_DATE('20200101') AND LAST_DAY(TO_DATE('20200301'))
    AND A.PROD_ID=B.BUY_PROD
GROUP BY A.PROD_ID,A.PROD_NAME,B.BUY_QTY
HAVING SUM(B.BUY_QTY)>=100
ORDER BY 1;
    
(ANSI JOIN)
SELECT A.PROD_ID AS 제품코드,
              A.PROD_NAME AS 제품명,
              SUM(B.BUY_QTY) AS 매입수량,
              SUM(BUY_QTY*PROD_COST) AS 매입금액
FROM PROD A
INNER JOIN BUYPROD B ON(A.PROD_ID=B.BUY_PROD AND B.BUY_DATE 
BETWEEN TO_DATE('20200101') AND LAST_DAY(TO_DATE('20200301')))
GROUP BY A.PROD_ID,A.PROD_NAME,B.BUY_QTY
ORDER BY 1;
    

사용 예시)
2020년 1~6월 상품의 분류별 판매집계를 조회하시오
Alias는 분류코드, 분류명, 판매금액

--틀린답
SELECT B.PROD_ID AS 분류코드,
              C.LPROD_NM AS 분류명,
              SUM(B.PROD_PRICE * A.CART_QTY) AS 판매금액
FROM CART A, PROD B, LPROD C
WHERE SUBSTR(CART_NO,1,6) BETWEEN '202001' AND '202006'
 AND B.PROD_ID=A.CART_PROD
 AND C.LPROD_GU=B.PROD_LGU
 GROUP BY B.PROD_ID, C.LPROD_NM
 ORDER BY 1;             
 ---------
  
 
 
 (ANSI JOIN)
 SELECT L.LPROD_GU AS 분류코드,
              L.LPROD_NM AS 분류명,
              SUM(P.PROD_PRICE * C.CART_QTY) AS 판매금액
FROM LPROD L 
INNER JOIN PROD P ON (L.LPROD_GU=P.PROD_LGU)                 
INNER JOIN CART C ON (P.PROD_ID=C.CART_PROD AND 
            SUBSTR(C.CART_NO,1,6) BETWEEN '202001' AND '202006')
 GROUP BY L.LPROD_GU, L.LPROD_NM;     


사용 예시)
HR계정에서 부서가 미국 이외에 위치한 부서에 근무하는 사원정보를 조회하시오
Alias는 사원번호, 사원명, 부서코드, 부서명
미국의 국가코드는 'US'임
SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명
    FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
    WHERE C.COUNTRY_ID != 'US'
    AND B.LOCATION_ID=C.LOCATION_ID
    AND A.DEPARTMENT_ID=B.DEPARTMENT_ID;
    
(ANSI JOIN)
SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명
    FROM HR.EMPLOYEES A 
    INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID=B.DEPARTMENT_ID)
    INNER JOIN HR.LOCATIONS C ON(B.LOCATION_ID=C.LOCATION_ID
                                                   AND C.COUNTRY_ID != 'US');
                                                   
                                                   
숙제1] 2020년 6-7월 회원별 구매집계를 조회하시오.
          Alias는 회원번호, 회원명, 구매금액
(일반조인)
SELECT M.MEM_ID AS 회원번호,
              M.MEM_NAME AS 회원명,
              SUM(P.PROD_PRICE*C.CART_QTY) AS 구매금액
FROM CART C, MEMBER M, PROD P
WHERE M.MEM_ID=C.CART_MEMBER
    AND C.CART_PROD=P.PROD_ID
    AND SUBSTR(CART_NO,1,6) BETWEEN '202006' AND '202007'
GROUP BY M.MEM_ID,M.MEM_NAME;

(ANSI조인)
SELECT M.MEM_ID AS 회원번호,
              M.MEM_NAME AS 회원명,
              SUM(P.PROD_PRICE*C.CART_QTY) AS 구매금액
FROM CART C
INNER JOIN MEMBER M ON(M.MEM_ID=C.CART_MEMBER
                                            AND SUBSTR(CART_NO,1,6) BETWEEN '202006' AND '202007')
INNER JOIN PROD P ON(C.CART_PROD=P.PROD_ID)
GROUP BY M.MEM_ID,M.MEM_NAME;

숙제2]2020년 거래처별 제품별 판매집계를 조회하시오.
         Alias는 거래처번호, 거래처명, 제품명, 판매금액
(일반조인)
SELECT B.BUYER_ID AS 거래처번호,
              B.BUYER_NAME AS 거래처명,
              P.PROD_NAME AS 제품명,
              SUM(P.PROD_PRICE*CART_QTY) AS 판매금액
FROM CART C, PROD P, BUYER B
WHERE SUBSTR(CART_NO,1,4)='2020'
AND C.CART_PROD=P.PROD_ID
AND P.PROD_LGU=B.BUYER_LGU
GROUP BY B.BUYER_ID,B.BUYER_NAME, P.PROD_NAME ;

(ANSI조인)
SELECT B.BUYER_ID AS 거래처번호,
              B.BUYER_NAME AS 거래처명,
              P.PROD_NAME AS 제품명,
              SUM(P.PROD_PRICE*CART_QTY) AS 판매금액
FROM CART C
INNER JOIN PROD P ON(C.CART_PROD=P.PROD_ID 
                     AND SUBSTR(CART_NO,1,4)='2020')
INNER JOIN BUYER B ON(P.PROD_LGU=B.BUYER_LGU)
GROUP BY B.BUYER_ID,B.BUYER_NAME, P.PROD_NAME ;

숙제3]회원테이블에서 'n001회원'(구길동)의 마일리지보다 많은 마일리지를  보유한
     회원들을 조회하시오
     Alias는 회원번호,회원명,마일리지
 SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_MILEAGE AS 마일리지
FROM MEMBER A
WHERE MEM_MILEAGE > (SELECT MEM_MILEAGE
                                            FROM MEMBER
                                             WHERE MEM_ID='n001');


                  :