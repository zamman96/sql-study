2024-0326-02) 서브쿼리를 이용한 DML 명령
 1. UPDATE 명령
    (사용 형식)
    UPDATE 테이블명
           SET (컬럼명, 컬럼명, ....) = (서브쿼리)
    [WHERE 조건];
    - SET 절에 하나 이상의 컬럼을 기술하려면 반드시 ( ) 안에 기술해야하고
      서브쿼리의 SELECT절의 컬럼과 갯수, 순서가 반드시 일치해야 한다.

사용 예시)
2020년 1월 제품별 매입수량을 구하여 재고수불 테이블을 갱신하시오.
단, 처리일자는 2020/03/31이다.

UPDATE REMAIN A
       SET (A.REMAIN_I,A.REMAIN_J_99,A.REMAIN_DATE) = 
                  ( SELECT A.REMAIN_I + B.BQTY,
                                 A.REMAIN_J_99 + B.BQTY,
                                TO_DATE('20200331')
                    FROM (SELECT BUY_PROD,
                                             SUM(BUY_QTY) AS BQTY
                                  FROM BUYPROD
                                WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
                                GROUP BY BUY_PROD) B
                   WHERE B.BUY_PROD(+)=A.PROD_ID)
                   -- 전체를 수정하면 변함없는 것은 NULL출력 WHERE절을 통해 바꾼것만 지정
 WHERE A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                                        FROM BUYPROD
                                    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'));
 
 
COMMIT;
숙제] 
2020년 2~7월 제품별 매입/매출 수량을 조회하여 재고수불테이블을 갱신하시오
단, 갱신일은 2020/07/31 이다
풀이1)
UPDATE REMAIN A
      SET (A.REMAIN_I, A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE) =
             (SELECT A.REMAIN_I + B.BQTY,
                            A.REMAIN_O + C.CQTY,
                            A.REMAIN_J_99 + B.BQTY - C.CQTY,
                            TO_DATE('20200731')
                FROM (SELECT BUY_PROD,
                                          SUM(BUY_QTY) AS BQTY
                               FROM BUYPROD
                               WHERE BUY_DATE BETWEEN TO_DATE('20200201')
                                     AND TO_DATE('20200731')
                                GROUP BY BUY_PROD) B,
                          (SELECT CART_PROD,
                                         SUM(CART_QTY) AS CQTY
                              FROM CART
                            WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007'
                             GROUP BY CART_PROD) C
             WHERE B.BUY_PROD(+)=A.PROD_ID
                  AND C.CART_PROD(+)=A.PROD_ID)
 WHERE A.PROD_ID IN (SELECT BUY_PROD          
                                          FROM BUYPROD
                                       WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200731'))
       AND A.PROD_ID IN (SELECT CART_PROD
                                          FROM CART
                                       WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007') ;                            

풀이2)
UPDATE REMAIN R
      SET (R.REMAIN_I, R.REMAIN_O, R.REMAIN_J_99, R.REMAIN_DATE) =
             (SELECT R.REMAIN_I + P.BSUM,
                            R.REMAIN_O + P.CSUM,
                            R.REMAIN_J_99 + P.BSUM - P.CSUM,
                            TO_DATE('20200731')
                FROM (SELECT A.PROD_ID AS PID,
                                          NVL(B.BQTY,0) AS BSUM,
                                          NVL(C.CQTY,0) AS CSUM
                               FROM PROD A,
                                     (SELECT BUY_PROD,
                                                    SUM(BUY_QTY) AS BQTY
                                         FROM BUYPROD
                                       WHERE BUY_DATE BETWEEN TO_DATE('20200201')
                                                                        AND TO_DATE('20200731')
                                        GROUP BY BUY_PROD) B,
                                      (SELECT CART_PROD,
                                                     SUM(CART_QTY) AS CQTY
                                            FROM CART
                                         WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007'
                                         GROUP BY CART_PROD) C
                             WHERE A.PROD_ID=B.BUY_PROD(+)
                                AND A.PROD_ID=C.CART_PROD(+) ) P
             WHERE R.PROD_ID=P.PID);
    



사용 예제 1)
상품테이블에서 상품별 마일리지가 NULL인 상품을 찾아 '0'으로 치환하시오
UPDATE PROD 
    SET PROD_MILEAGE=0
WHERE PROD_ID IN (SELECT PROD_ID
                                                FROM PROD 
                                            WHERE PROD_MILEAGE IS NULL);
                                            
사용 예제 1-1)
상품테이블에서 판매가에서 매입가를 뺀 값의 0.1% 값을 구하여 상품의 마일리지로
갱신
UPDATE PROD A
       SET A.PROD_MILEAGE = (SELECT ROUND((B.PROD_PRICE - B.PROD_COST)*0.001,-1)
                                                FROM PROD B
                                              WHERE A.PROD_ID=B.PROD_ID );
    
사용 예제 2)
회원테이블의 마일리지를 모두 0으로 갱신하시오.
UPDATE MEMBER
    SET MEM_MILEAGE = 0;

사용 예제 3)
2020년 회원별 상품별 구매수량을 조회하여 마일리지를 새로 부여하시오.
풀이 1 ) 서브쿼리 2개 활용)
UPDATE MEMBER A
       SET A.MEM_MILEAGE = ( SELECT BSUM
                                                        FROM  (SELECT B.CART_MEMBER AS CID,
                                                                                  SUM (B.CSUM*A.PROD_MILEAGE) AS BSUM
                                                                       FROM PROD A,
                                                                              (SELECT CART_MEMBER,
                                                                                             CART_PROD,
                                                                                             SUM(C.CART_QTY) AS CSUM
                                                                                   FROM CART C
                                                                                WHERE SUBSTR(CART_NO,1,4)='2020'
                                                                                GROUP BY CART_MEMBER, CART_PROD) B     
                                                                      WHERE A.PROD_ID=B.CART_PROD
                                                                     GROUP BY B.CART_MEMBER)
                                                        WHERE CID=A.MEM_ID)
 WHERE A.MEM_ID IN (SELECT DISTINCT CART_MEMBER
                                       FROM CART
                                    WHERE SUBSTR(CART_NO,1,4)='2020') ;

풀이 2 ) 서브쿼리 1개활용
UPDATE MEMBER A
       SET A.MEM_MILEAGE = (SELECT SUM(C.CART_QTY*B.PROD_MILEAGE)
                                FROM PROD B, CART C
                               WHERE C.CART_PROD=B.PROD_ID
                                 AND SUBSTR(CART_NO,1,4)='2020'
                                 AND A.MEM_ID = C.CART_MEMBER
                               GROUP BY C.CART_MEMBER)
WHERE A.MEM_ID IN (SELECT DISTINCT CART_MEMBER
                     FROM CART
                    WHERE SUBSTR(CART_NO,1,4)='2020');

            
        COMMIT;