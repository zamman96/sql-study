2024-0322-01) 외부조인
 - 내부조인은 조인조건을 만족하지 않는 자료를 무시한(자료의 종류가 적은 쪽을 기준)
   결과를 반환
 - 외부조인은 자료의 종류가 많은 쪽을 기준으로 적은 쪽에 NULL행을 추가하여 조인을 수행함
 - 일반 외부 조인 경우
   . 조인조건 기술시 자료의 종류가 적은 쪽에 외부조인 연산자 '(+)'를 기술
   . 조인조건이 여러개 이고 모두 외부 조인이 필요한 경우 해당되는 모든 조건에 '(+)'를
   사용해야 함
   . 한 테이블이 동시에 여러번 외부조인에 사용될 수 없다 예를 들어 3 테이블
   A, B, C가 외부조인되는 경우 A를 기준으로 B가 외부조인되고, 동시에 C를 기준으로
   B가 외부조인 될 수 없다(A=B(+) AND C=B(+)는 허용안됨)
   . 일반 외부조인에서 일반 조건이 부여된다면 결과는 내부조인 결과가 반환됨
     =>해결책으로 ANSI외부조인이나 서브쿼리를 사용해야 한다
 (일반 외부조인 사용형식)
    SELECT 컬럼list, ...
        FROM 테이블명1 [별칭1], 테이블명2 [별칭2] [, 테이블명3 [별칭3], ... ]
      WHERE [별칭1.]컬럼명=[별칭2.]컬럼명(+)
          [ AND [별칭1.]컬럼명=[별칭2.]컬럼명(+)
                                    :
 (ANSI 외부조인 사용형식)
    SELECT 컬럼list, ...
        FROM 테이블명1 [별칭1]           
    LEFT | RIGHT | FULL OUTER JOIN 테이블명2 [별칭2] ON (조인조건 [AND 일반조건])
                                    :
        [WHERE 일반조건]
    . LEFT OUTER JOIN : 테이블명1의 자료의 종류가 테이블명2 자료의 종류보다 많을 때
    . RIGHT OUTER JOIN : 테이블명1의 자료의 종류가 테이블명2 자료의 종류보다 적을 때
    . FULL OUTER JOIN : 양쪽 테이블 자료의 종류가 각각 적을 때
    . WHERE 일반조건 : 모든 테이블에 공통으로 적용되는 조건을 기술해야 함 이 절을 사용하면
        결과가 내부조인 결과가 반환됨    

사용 예시) 모든 분류별 상품의 수를 조회하시오
Alias는 분류코드, 분류명, 상품의수
(일반 외부조인)
SELECT  L.LPROD_GU AS 분류코드, --많은쪽을 넣어야함 적은쪽을 넣으면 NULL출력
               L.LPROD_NM AS 분류명,
               COUNT(P.PROD_LGU) AS  "상품의 수" --외부조인에선 COUNT(*) 쓰면안됨 NULL도 하나의 데이터로 측정
FROM LPROD L, PROD P
WHERE L.LPROD_GU=P.PROD_LGU(+) --적은쪽에 (+)
GROUP BY L.LPROD_GU, L.LPROD_NM
ORDER BY 1;

SELECT DISTINCT PROD_LGU
FROM PROD;                  -- 6개

SELECT LPROD_GU
FROM LPROD;                 -- 9개

(ANSI FORMAT)
SELECT  L.LPROD_GU AS 분류코드,
               L.LPROD_NM AS 분류명,
               COUNT(P.PROD_LGU) AS  "상품의 수" 
FROM LPROD L
LEFT OUTER JOIN PROD P ON(L.LPROD_GU=P.PROD_LGU)
GROUP BY L.LPROD_GU, L.LPROD_NM
ORDER BY 1;

숙제4] 모든 회원별 판매집계를 조회하시오.
SELECT M.MEM_ID AS 회원코드,
              M.MEM_NAME AS 회원명,
              NVL(SUM(C.CART_QTY*P.PROD_PRICE),0) AS "판매금액 합계"              
FROM MEMBER M, CART C, PROD P
WHERE M.MEM_ID=C.CART_MEMBER(+)
     AND P.PROD_ID(+)=C.CART_PROD
GROUP BY M.MEM_ID,M.MEM_NAME
ORDER BY 1;

(ANSI FORMAT)
SELECT M.MEM_ID AS 회원코드,
              M.MEM_NAME AS 회원명,
              NVL(SUM(C.CART_QTY*P.PROD_PRICE),0) AS "판매금액 합계"              
FROM MEMBER M
LEFT OUTER JOIN CART C ON(M.MEM_ID=C.CART_MEMBER)
LEFT OUTER JOIN PROD P ON(P.PROD_ID=C.CART_PROD)
GROUP BY M.MEM_ID,M.MEM_NAME
ORDER BY 1;

숙제5] (NULL 부서코드를 제외하고) 모든 부서별 사원수와 평균급여를 조회하시오
SELECT D.DEPARTMENT_ID AS 부서코드,
              D.DEPARTMENT_NAME AS 부서명,
              COUNT(E.DEPARTMENT_ID) AS 사원수,
              ROUND(NVL(AVG(E.SALARY),0)) AS 평균급여
FROM HR.EMPLOYEES E, HR.DEPARTMENTS D
WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
ORDER BY 1;

(ANSI FORMAT)
SELECT D.DEPARTMENT_ID AS 부서코드,
              D.DEPARTMENT_NAME AS 부서명,
              COUNT(E.DEPARTMENT_ID) AS 사원수,
              ROUND(NVL(AVG(E.SALARY),0)) AS 평균급여
FROM HR.EMPLOYEES E
RIGHT OUTER JOIN HR.DEPARTMENTS D ON(D.DEPARTMENT_ID = E.DEPARTMENT_ID)
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
ORDER BY 1;

사용 예시) 2020년 7월 모든 회원별 구매금액집계 (회원번호, 회원명, 구매금액합계)를 조회하시오.
SELECT M.MEM_ID AS 회원번호, 
              M.MEM_NAME AS 회원명,
              SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
FROM MEMBER M, CART C, PROD P
WHERE M.MEM_ID=C.CART_MEMBER (+)
--AND P.PROD_ID=C.CART_PROD 모든 회원별이기 때문에 상품별로 늘릴 필요는 없다
AND SUBSTR(CART_NO,1,6)='202007' --날짜때문에 모든 회원의 정보는 뜨지않음 (INNER)
GROUP BY M.MEM_ID,M.MEM_NAME
ORDER BY 1; 

(ANSI FORMAT)
SELECT M.MEM_ID AS 회원번호, 
              M.MEM_NAME AS 회원명,
              NVL(SUM(C.CART_QTY*P.PROD_PRICE),'0') AS 구매금액합계
FROM MEMBER M
LEFT OUTER JOIN CART C ON (M.MEM_ID=C.CART_MEMBER)
LEFT OUTER JOIN PROD P ON (P.PROD_ID=C.CART_PROD AND SUBSTR(CART_NO,1,6)='202007')
GROUP BY M.MEM_ID,M.MEM_NAME
ORDER BY 1;
-----------------------------------------------------------------------------
(SUBQUERY)
2020년 7월 회원별 구매금액집계
SELECT A.CART_MEMBER AS CID,
              SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
FROM CART A, PROD B
WHERE A.CART_PROD=B.PROD_ID
AND A.CART_NO LIKE '202007%'
GROUP BY A.CART_MEMBER;

SELECT  M.MEM_ID AS 회원번호, 
               M.MEM_NAME AS 회원명,
               NVL(C.CSUM,0) AS 구매금액합계
FROM MEMBER M, (SELECT A.CART_MEMBER AS CID,
                                          SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
                                FROM CART A, PROD B
                             WHERE A.CART_PROD=B.PROD_ID
                                   AND A.CART_NO LIKE '202007%'
                              GROUP BY A.CART_MEMBER) C
WHERE M.MEM_ID=C.CID (+)
ORDER BY 1;
----------------------------------------------------------------------------------------------------


숙제6] 2020년 모든 상품별 매입/매출 집계를 조회하시오
Alias는 상품번호, 상품명, 매입수량, 매입금액, 매출수량, 매출금액

-----매출
(일반)
SELECT LPROD_NM FROM LPROD; --상품 총 9개

SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              SUM(C.CART_QTY) AS 매출수량,
              SUM(C.CART_QTY*P.PROD_PRICE) AS 매출금액
FROM LPROD L, PROD P, CART C
WHERE L.LPROD_GU=P.PROD_LGU(+)
    AND P.PROD_ID=C.CART_PROD(+)
    AND SUBSTR(CART_NO,1,4)='2020'
GROUP BY L.LPROD_GU, L.LPROD_NM
ORDER BY 1;
(서브쿼리)
SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              NVL(C.CQT,0) AS 매출수량,
              NVL(C.CSUM,0) AS 매출금액
FROM LPROD L, (SELECT P.PROD_LGU AS CLGU,
                                          SUM(C.CART_QTY) AS CQT,
                                          SUM(C.CART_QTY*P.PROD_PRICE) AS CSUM
                                FROM CART C, PROD P
                                WHERE P.PROD_ID=C.CART_PROD
                                        AND SUBSTR(CART_NO,1,4)='2020'
                                    GROUP BY P.PROD_LGU) C
WHERE L.LPROD_GU=C.CLGU(+)
ORDER BY 1;
(ANSI)
SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              NVL(SUM(C.CART_QTY),0) AS 매출수량,
              NVL(SUM(C.CART_QTY*P.PROD_PRICE),0) AS 매출금액
FROM CART C
RIGHT OUTER JOIN PROD P ON(P.PROD_ID=C.CART_PROD)
RIGHT OUTER JOIN LPROD L ON(L.LPROD_GU=P.PROD_LGU 
                                                     AND SUBSTR(CART_NO,1,4)='2020')
GROUP BY L.LPROD_GU, L.LPROD_NM
ORDER BY 1;


-----매입
(일반)
SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              SUM(B.BUY_QTY) AS 매입수량,
              SUM(B.BUY_QTY*P.PROD_COST) AS 매입금액
  FROM LPROD L, PROD P, BUYPROD B
WHERE L.LPROD_GU=P.PROD_LGU
    AND P.PROD_ID=B.BUY_PROD(+)
    AND EXTRACT(YEAR FROM B.BUY_DATE)=2020
    GROUP BY L.LPROD_GU, L.LPROD_NM
    ORDER BY 1;
    
(서브쿼리)
SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              NVL(B.BQTY,0) AS 매입수량,
              NVL(B.BSUM,0) AS 매입금액
  FROM LPROD L, (SELECT P.PROD_LGU AS BLGU,
                                            SUM(B.BUY_QTY) AS BQTY,
                                            SUM(B.BUY_QTY*P.PROD_COST) AS BSUM
                                 FROM PROD P, BUYPROD B
                               WHERE P.PROD_ID=B.BUY_PROD
                                    AND EXTRACT(YEAR FROM B.BUY_DATE)=2020
                                GROUP BY P.PROD_LGU ) B          
WHERE L.LPROD_GU=B.BLGU(+)
ORDER BY 1;
              
(ANSI)
SELECT L.LPROD_GU AS 상품번호,
              L.LPROD_NM AS 상품명,
              NVL(SUM(B.BUY_QTY),0) AS 매입수량,
              NVL(SUM(B.BUY_QTY*P.PROD_COST),0) AS 매입금액
  FROM BUYPROD B
  RIGHT OUTER JOIN PROD P ON(P.PROD_ID=B.BUY_PROD)  
  RIGHT OUTER JOIN LPROD L ON(L.LPROD_GU=P.PROD_LGU 
                                            AND EXTRACT(YEAR FROM B.BUY_DATE)=2020)
  GROUP BY L.LPROD_GU, L.LPROD_NM
  ORDER BY 1;
  
  
  2020년 4월 모든 상품별 매입/매출 집계를 조회하시오
  Alias는 상품번호, 상품명, 매입수량, 매입금액, 매출수량, 매출금액
일반
  SELECT A.PROD_ID AS 상품번호,
                A.PROD_NAME AS 상품명,
                SUM(B.BUY_QTY) AS 매입수량,
                SUM(B.BUY_QTY*A.PROD_COST) AS 매입금액,
               SUM(C.CART_QTY) AS 매출수량,
               SUM(C.CART_QTY*A.PROD_PRICE) AS 매출금액
    FROM PROD A, BUYPROD B, CART C
WHERE A.PROD_ID=B.BUY_PROD (+)
      AND A.PROD_ID=C.CART_PROD (+)
      AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY(TO_DATE('20200401'))
      AND SUBSTR(C.CART_NO,1,6)='202004'
GROUP BY A.PROD_ID, A.PROD_NAME
ORDER BY 1;

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
                                    AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY(TO_DATE('20200401'))
                                GROUP BY A.PROD_ID ) B,
                                ( SELECT A.PROD_ID AS CID,
                                               SUM(C.CART_QTY) AS CQTY,
                                               SUM(C.CART_QTY*A.PROD_PRICE) AS CSUM
                                    FROM PROD A, CART C     
                                WHERE A.PROD_ID=C.CART_PROD
                                    AND SUBSTR(C.CART_NO,1,6)='202004'
                                GROUP BY A.PROD_ID) C
 WHERE A.PROD_ID=BID(+)
 AND A.PROD_ID=CID(+)
 ORDER BY 1;

(ANSI)
  SELECT A.PROD_ID AS 상품번호,
                A.PROD_NAME AS 상품명,
                NVL(SUM(B.BUY_QTY),0) AS 매입수량,
                NVL(SUM(B.BUY_QTY*A.PROD_COST),0) AS 매입금액,
                NVL(SUM(C.CART_QTY),0) AS 매출수량,
                NVL(SUM(C.CART_QTY*A.PROD_PRICE),0) AS 매출금액
    FROM PROD A
    LEFT OUTER JOIN BUYPROD B ON(A.PROD_ID=B.BUY_PROD
                                                       AND B.BUY_DATE BETWEEN TO_DATE('20200401') 
                                                       AND LAST_DAY(TO_DATE('20200401')))
    LEFT OUTER JOIN CART C ON(A.PROD_ID=C.CART_PROD
                                                AND SUBSTR(C.CART_NO,1,6)='202004')    
GROUP BY A.PROD_ID, A.PROD_NAME
ORDER BY 1;


  
  
    
