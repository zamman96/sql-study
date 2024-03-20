2024-0319-01) NULL처리 함수
1. IS NULL, IS NOT NULL 
    - NULL인지 여부 판단

2. NVL(col, value)
    - 'col' 값이 NULL이면 'value'를 반환하고 NULL이 아니면 'col'값을 반환함
    - 'col'과 'value'는 반드시 같은 타입이어야 함

** 회원테이블에서 마일리지가 1000미만인 회원의 마일리지를 NULL로 변경하시오.
UPDATE MEMBER                          --테이블명
       SET MEM_MILEAGE=NULL      --컬럼명= 변경할 값
 WHERE MEM_MILEAGE<1000;       --변경할 행 선택

**상품테이블에서 각 상품의 마일리지(PROD_MILEAGE)를 다음 조건에 맞게 계산하여 입력하시요
   상품의 마일리지(PROD_MILEAGE)=상품의 이익(판매가-매입가)의 1%
   단, 상품의 마일리지가 100 미만이면 NULL처리하시오.

CREATE OR REPLACE PROCEDURE PROC_PROD_MILEAGE(
       P_PID IN PROD.PROD_ID%TYPE)
     IS
       L_MILEAGE NUMBER:=0;
       CURSOR CUR_MILE IS
        SELECT (PROD_PRICE - PROD_COST) * 0.01 AS PMILE, PROD_ID
          FROM PROD;
     BEGIN
       FOR REC IN CUR_MILE LOOP
            IF REC.PMILE <100 THEN
                L_MILEAGE:=NULL;
            ELSE
                L_MILEAGE:=REC.PMILE;
            END IF;
         
            UPDATE PROD 
                SET PROD_MILEAGE=L_MILEAGE
            WHERE PROD_ID=REC.PROD_ID;
            COMMIT;
       END LOOP;      -- FOR END
     END;  
    
 --[실행]-----------------------------------------------------   
    DECLARE
        CURSOR AA IS
        SELECT PROD_ID
            FROM PROD;
    BEGIN
        FOR REC IN AA LOOP
                PROC_PROD_MILEAGE(REC.PROD_ID);
            END LOOP;
    END;
---------------------------------------------------------------

사용 예시)
사원테이블에서 50-90 부서에 속한 사원들의 보너스를 계산하여 출력 하시오
보너스=급여*영업실적코드이며 보너스가 없으면 '보너스 없음'을 출력하시오
Alisa는 사원번호, 부서번호, 급여, 영업실적코드,보너스
부서번호 순으로 출력
SELECT EMPLOYEE_ID AS 사원번호,
              DEPARTMENT_ID AS 부서번호,
              SALARY AS 급여,
              COMMISSION_PCT AS 영업실적코드,
              NVL(TO_CHAR(SALARY * COMMISSION_PCT,'99,999'),'보너스 없음') AS 보너스
              -- 타입이 달라서 실행이되지 않음 '보너스 없음'은 CHAR
    FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID BETWEEN 50 AND 90
    ORDER BY 2;

사용 예시)
회원 테이블에서 마일리지가 NULL인 회원을 찾아 비고란에 '휴면회원'을, NULL이
아닌 회원은 해당 마일리지를 출력하시오
Alias는 회원번호, 회원명, 비고
SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
             NVL(TO_CHAR(MEM_MILEAGE,'99,999'),'휴면회원') AS 비고
--              NVL2(MEM_MILEAGE,TO_CHAR(MEM_MILEAGE,'99,999'),'휴면회원') AS 비고
    FROM MEMBER;

사용예시)
다음은 2020년 5월 회원별 구매실적에 따른 마일리지를 계산한 쿼리이다.
마일리지가 없는 상품에는 마일리지는 0으로 계산할 것
잘못된 명령을 고쳐 정상 수행되게 하시오.
SELECT A.MEM_ID AS 회원번호,
              A.MEM_NAME AS 회원명,
              NVL(A.MEM_MILEAGE,0) AS 원본마일리지,
              NVL(D.MSUM,0) AS 추가마일리지,
              NVL(A.MEM_MILEAGE,0)+NVL(D.MSUM,0) AS 변경마일리지
    FROM MEMBER A, (SELECT B.CART_MEMBER AS CID,
                                                  SUM(B.CART_QTY*C.PROD_MILEAGE) AS MSUM
                                        FROM CART B, PROD C
                                    WHERE B.CART_PROD=C.PROD_ID
                                          AND B.CART_NO LIKE '202005%'
                                    GROUP BY B.CART_MEMBER)   D                             
    WHERE A.MEM_ID=D.CID (+);
    -- OUTER JOIN (+) 아우터 조인 (외부조인)

3. NVL2(col, value1, value2)
    - 'col'값이 NULL이면 'value2'를 반환하고, NULL이 아니면 'value1'을 반환
    - 'value1'과 'value2'의 데이터 타입은 일치해야 함 
    - NVL의 기능을 포함

사용 예시)
상품테이블에서 생상정보(PROD_COLOR)를 조회하여 NULL이면 ' 색상 없는 상품',
NULL이 아니면 '색상 보유 상품'을 출력
Alias는 상품코드, 상품명, 비고
SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              NVL2(PROD_COLOR,'색상 보유 상품','색상 없는 상품') AS 비고
   FROM PROD;

4. NULLIF(col1, col2)
    - 'col1'과 'col2'를 비교하여 같은 값이면 NULL을 반환하고 다른 값이면
      'col1'의 값을 반환 함
      
 ** 상품테이블에서 분류코드 'P301' 에 속한 상품의 매출가격을 매입 가격으로 조정하시오.
 UPDATE PROD
        SET PROD_PRICE=PROD_COST
    WHERE PROD_LGU='P301';
COMMIT;

사용 예시) 
상품테이블에서 매입가격과 매출가격이 동일한 품목은 매출가에 '단종예정상품'을
출력하시오
Alias는  상품코드, 상품명, 매입가, 매출가
SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              PROD_COST AS 매입가,
              LPAD(NVL(TO_CHAR(NULLIF(PROD_PRICE,PROD_COST)),'단종예정상품'),LENGTHB('단종예정상품')) AS 매출가
FROM PROD
