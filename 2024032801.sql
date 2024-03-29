2024-0328-01) VIEW
 - 가상의 테이블
 - 기존의 테이블이나 뷰를 이용하여 SELECT문을 수행한 결과 집합
 - VIEW를 사용하는 경우
    . 필요한 정보가 복수개의 테이블에 분산되어 있는 경우
    . 특정자료에 대한 접근을 제한해야 하는 경우
    . 필요한 자료를 반환하기 위하여 매우 복잡한 동일한 서브쿼리를
      매번 실행해야 하는 경우
    . 주기적으로 변동되는 쿼리의 결과를 이용해야 하는 경우 (그래프로 변동 상황을
      자주 갱신하여 나타내야 하는 경우)

(사용형식)
CREATE [OR REPLACE] VIEW  뷰이름[ (컬럼list) ] AS
    SELECT 문
    [WITH CHECK OPTION]
    [WITH READ ONLY]
    . 'OR REPLACE' : 이름이 동일한 뷰가 이미 있으면 대치하고 없으면 새롭게 생성
    . '컬럼list' : 뷰에서 사용할 컬럼명들. 생략하면 SELECT문에 사용된 컬럼의 별칭이 뷰의
      컬럼명이 되며, SELECT문에서 별칭을 사용하지 않은 경우 SELECT문의 컬럼명이
      뷰의 컬럼명이 됨
    . WITH CHECK OPTION : SELECT 문의 WHERE 절을 위배하는 DML명령을 뷰에 
       적용할 수 없다 ( 원본 테이블은 WITH CHECK OPTION에 상관없이 DML명령을 수행할 수 있다)
    . WITH READ ONLY : 읽기 전용 뷰를 생성함
    . WITH CHECK OPTION와 WITH READ ONLY는 같이 사용할 수 없다.

사용 예시) --------------------------------------------------------------------------생성
회원테이블에서 마일리지가 3000이상인 회원들의 회원번호, 회원명, 마일리지로 뷰를
생성하시오
CREATE OR REPLACE VIEW V_MEM_MILEAGE
 AS
    SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, MEM_MILEAGE AS 마일리지
        FROM MEMBER
    WHERE MEM_MILEAGE>=3000
 WITH CHECK OPTION;
    
(조회)
 SELECT *  FROM V_MEM_MILEAGE;
 
(뷰의 갱신)
    UPDATE V_MEM_MILEAGE
    SET MEM_MILEAGE = 8960
    WHERE MEM_ID='b001'
    
(원본테이블 갱신)
 UPDATE MEMBER
    SET MEM_MILEAGE = 4960
    WHERE MEM_ID='b001'
    
사용 예시)
뷰  V_MEM_MILEAGE에서 'b001' 회원의 마일리지를 2960으로 변경하시오
    UPDATE V_MEM_MILEAGE
    SET 마일리지 = 2960
    WHERE 회원번호='b001';

(원본테이블 갱신)
 UPDATE MEMBER
    SET MEM_MILEAGE = 1960
    WHERE MEM_ID='b001'                ----------------------------------변경
    
CREATE OR REPLACE VIEW V_CNT_MEMBER
AS
    SELECT COUNT (*) AS CNT
       FROM MEMBER
    WHERE MEM_MILEAGE>=3000;

SELECT * FROM V_CNT_MEMBER;

-- MEMBER가 업데이트 된 다음에 트리거 실행
-- VIEW있는 내용을 꺼내서 화면에 출력시켜주는것
CREATE OR REPLACE TRIGGER TG_CNT_MEMBER
    AFTER UPDATE ON MEMBER
DECLARE
    L_CNT NUMBER:=0;
BEGIN
    SELECT CNT INTO L_CNT 
       FROM V_CNT_MEMBER;
       
    DBMS_OUTPUT.PUT_LINE('회원수 : ' || L_CNT);
END;

UPDATE MEMBER
    SET MEM_MILEAGE=3500
WHERE MEM_ID='n001';

UPDATE MEMBER
    SET MEM_MILEAGE=3500
WHERE MEM_ID='k001';

SELECT * FROM V_CNT_MEMBER;








