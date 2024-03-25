2024-0325-01 ) 서브쿼리
(서브쿼리)
  SELECT A.PROD_ID AS 상품번호,
                A.PROD_NAME AS 상품명,
                NVL(B.BQTY,0) AS 매입수량,
                NVL(B.BSUM,0) AS 매입금액,
                NVL(C.CQTY,0) AS 매출수량,
                NVL(C.CSUM,0) AS 매출금액
    FROM PROD A, (SELECT A.PROD_ID AS BID,
                                            SUM(B.BUY_QTY) AS BQTY,
                                            SUM(B.BUY_QTY*A.PROD_COST) AS BSUM
                                  FROM PROD A, BUYPROD B      
                               WHERE A.PROD_ID=B.BUY_PROD 
                                    AND B.BUY_DATE BETWEEN TO_DATE('20200101') AND LAST_DAY(TO_DATE('20201201'))
                                GROUP BY A.PROD_ID ) B,
                                ( SELECT A.PROD_ID AS CID,
                                               SUM(C.CART_QTY) AS CQTY,
                                               SUM(C.CART_QTY*A.PROD_PRICE) AS CSUM
                                    FROM PROD A, CART C     
                                WHERE A.PROD_ID=C.CART_PROD
                                    AND SUBSTR(C.CART_NO,1,4)='2020'
                                GROUP BY A.PROD_ID) C
 WHERE A.PROD_ID=BID(+)
 AND A.PROD_ID=CID(+)
 ORDER BY 1;
 
 (ANSI FORMAT)
   SELECT A.PROD_ID AS 상품번호,
                A.PROD_NAME AS 상품명,
                NVL(B.BQTY,0) AS 매입수량,
                NVL(B.BSUM,0) AS 매입금액,
                NVL(C.CQTY,0) AS 매출수량,
                NVL(C.CSUM,0) AS 매출금액
    FROM PROD A
    LEFT OUTER JOIN (SELECT A.PROD_ID AS BID,
                                                SUM(B.BUY_QTY) AS BQTY,
                                                SUM(B.BUY_QTY*A.PROD_COST) AS BSUM
                                     FROM PROD A, BUYPROD B      
                                 WHERE A.PROD_ID=B.BUY_PROD 
                                      AND B.BUY_DATE BETWEEN TO_DATE('20200101') AND LAST_DAY(TO_DATE('20201201'))
                                 GROUP BY A.PROD_ID ) B 
                    ON (A.PROD_ID=B.BID)
  LEFT OUTER JOIN (SELECT A.PROD_ID AS CID,
                                               SUM(C.CART_QTY) AS CQTY,
                                               SUM(C.CART_QTY*A.PROD_PRICE) AS CSUM
                                    FROM PROD A, CART C     
                                WHERE A.PROD_ID=C.CART_PROD
                                    AND SUBSTR(C.CART_NO,1,4)='2020'
                                GROUP BY A.PROD_ID) C 
                    ON(A.PROD_ID=C.CID)
 ORDER BY 1;
 
 - 서브쿼리는 SQL구문 안에 또다른 SQL 구문이 포함된 형태
 - 알려지지않은 조건에 근거하여 값들을 조회하는 쿼리가 필요한 경우
 - 서브쿼리는 SELECT, INSERT, UPDATE, DELETE 문에서 사용됨
 - 서브쿼리는 ' ( ) '로 묶어야 함 (예외 : INSERT와 CREATE 문에 사용되는 서브쿼리)
 - 조건절에 서브쿼리가 사용될 경우 서브쿼리는 반드시 연산자 오른쪽에 기술 되어야 함
 - 서브쿼리는 SELECT절(일반 서브쿼리) , FROM절(인라인 서브쿼리), WHERE절(중첩 서브쿼리)
   에 사용 가능
 - 실행 순서는 해당 절이 수행될 때 서브 쿼리가 가장 먼저 수행 됨
 - 서브쿼리의 분류
   . 단일행/복수행 : 사용되는 연산자에 의한 구분
   . 연관성 없는 서브쿼리/연관성 있는 서브 쿼리 : 메인쿼리와 서브쿼리에 사용된
      테이블이 조인연산을 사용하는 여부에 따른 분류
    
 1. 단일행 서브쿼리
 - 오직 한개의 행만을 반환하는 서브쿼리
 - 단일행 연산자 ( =, >, >=, <, <=, != )만 사용 가능
 
 사용 예시)
 사원테이블에서 평균임금보다 더 적은 급여를 받는 사원들을 조회하시오.
Alias는 사원번호, 사원명, 급여, 사원들의 평균급여
(WHERE절)
SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              SALARY AS 급여,
              (SELECT ROUND(AVG(SALARY))
                                FROM HR.EMPLOYEES) AS "사원들의 평균급여"
               -- WHERE절에 만족하는 56명 수행
FROM HR.EMPLOYEES
WHERE SALARY < (SELECT AVG(SALARY)
                                FROM HR.EMPLOYEES)
                                --전체 107명 수행
ORDER BY 1;
 
 (FROM절)
 SELECT A.EMPLOYEE_ID AS 사원번호,
               A.EMP_NAME AS 사원명,
               A.SALARY AS 급여,
               B.ASAL AS "사원들의 평균급여"
    FROM HR.EMPLOYEES A, (SELECT ROUND(AVG(SALARY)) AS ASAL
                                                FROM HR.EMPLOYEES) B
 WHERE A.SALARY<B.ASAL
 ORDER BY 1;
 
 사용 예시)
 2020년 5월 회원별 구매액을 계산하여 구매액이 많은 5명의 회원정보를
 조회하시오
 Alias는 회원번호, 회원명, 주소, 직업, 마일리지, 구매액
 SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_ADD1 || ' ' || A.MEM_ADD2 AS 주소,
               A.MEM_JOB AS 직업,
               A.MEM_MILEAGE AS 마일리지,
               B.CSUM AS 구매액 
FROM MEMBER A, ( SELECT A.CART_MEMBER AS CID,
                                              SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
                                    FROM CART A, PROD B
                                  WHERE A.CART_PROD=B.PROD_ID
                                        AND SUBSTR(CART_NO,1,6)='202005'
                                  GROUP BY A.CART_MEMBER
                                  ORDER BY 2 DESC) B
WHERE A.MEM_ID=B.CID
AND ROWNUM<=5;
 

** 재고수불 테이블을 생성하시오
--------------------------------------------------------------------------------------------------
    컬럼명                        데이터타입                  default value            FK/PK
--------------------------------------------------------------------------------------------------
REMAIN_YEAR             CHAR(4)                                                       PK
PROD_ID                      VARCHAR2(10)                                            PK & FK
REMAIN_J_00               NUMBER(5)                         0
REMAIN_I                     NUMBER(5)                         0
REMAIN_O                    NUMBER(5)                         0
REMAIN_J_99               NUMBER(5)                         0
REMAIN_DATE              DATE                             SYSDATE
--------------------------------------------------------------------------------------------------

사용 예시)
생성된 재고수불테이블에 다음자료를 삽입하시오
년도 : 2020
상품번호 : PROD 테이블의 상품번호
기초재고 : PROD 테이블의 PROD_PROPERSTOCK
입고/출고 수량 : 없음
현재고 : 기초재고와 같음
갱신일 : 2020년 1월 1일

** 서브쿼리를 사용하는 INSERT
(사용 형식)
INSERT INTO 테이블명 [(컬럼list)]      서브쿼리;
    . 서브쿼리의 SELECT절의 컬럼의 갯수, 순서와 INTO절에 사용된 (컬럼list)의 갯수,
      순서와 반드시 일치
      
      
INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID,REMAIN_J_00,
                                    REMAIN_J_99,REMAIN_DATE)
        SELECT '2020', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20200101')
           FROM PROD;
COMMIT;


































 