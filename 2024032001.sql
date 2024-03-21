2024-03-20-01) ROLLUP 과 CUBE
 - GROUP BY 절에서만 사용되어 다양한 집계결과를 반환
 1. ROLLUP
 (사용 형식)
    GROUP BY ROLLUP (컬럼명1 [, 컬럼명2, ... 컬럼명n]) [, 컬럼명, ... ]
    - 사용된 컬럼명n부터 컬럼명 1이 모두 적용된 집계를 반환한 후 
      컬럼명n부터 하나씩 제거한 집계를 반환함
    - 마지막은 모든 컬럼이 적용되지 않는 집계(전체집계)를 반환
    - ROLLUP절에 기술된 컬럼의 수가 n개일 때 n+1개의 집계반환
    - ROLLUP절 전, 후에 컬럼이 올 수가 있으며 이를 '부분 ROLLUP'이라 함
    
사용 예시)
2020년 월별, 회원별, 제품별 구매수량 합계를 조회하시오
Alias는 월,회원번호,상품번호,구매수량합계

SELECT SUBSTR(CART_NO,5,2) AS 월,
              CART_MEMBER AS 회원번호,
              CART_PROD AS 상품번호,
              SUM(CART_QTY) AS 구매수량합계
    FROM CART
    WHERE CART_NO LIKE '2020%'
    GROUP BY SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD
    ORDER BY 1, 2, 3;
    
(ROLLUP절 사용)
    SELECT SUBSTR(CART_NO,5,2) AS 월,
              CART_MEMBER AS 회원번호,
              CART_PROD AS 상품번호,
              SUM(CART_QTY) AS 구매수량합계
    FROM CART
    WHERE CART_NO LIKE '2020%'
    GROUP BY ROLLUP(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD)
    ORDER BY 1, 2, 3;
    
2. CUBE
(사용형식)
    GROUP BY CUBE (컬럼명1 [, 컬럼명2, ... 컬럼명n]) [, 컬럼명, ... ]
    - 사용된 컬럼들로 조합 가능한 모든 경우의 집계를 반환함
    - 마지막은 모든 컬럼이 적용되지 않는 집계(전체집계)를 반환
    - CUBE절에 기술된 컬럼의 수가 n개일 때 2^n개의 집계반환
    - CUBE절 전, 후에 컬럼이 올 수가 있으며 이를 '부분 CUBE'이라 함
    
사용 예시)
2020년 월별, 회원별, 제품별 구매수량 합계를 조회하시오
Alias는 월,회원번호,상품번호,구매수량합계

(CUBE절 사용)
    SELECT SUBSTR(CART_NO,5,2) AS 월,
              CART_MEMBER AS 회원번호,
              CART_PROD AS 상품번호,
              SUM(CART_QTY) AS 구매수량합계
    FROM CART
    WHERE CART_NO LIKE '2020%'
    GROUP BY CUBE(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD)
    ORDER BY 1, 2, 3;
    
    
    
    
    
    
    
    
    
    
    
    
