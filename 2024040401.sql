2024-0404-01) Stored Procedure(procedure)
    - 미리 컴파일 되어 서버에 저장된 모듈
    - 반환값이 없는 서브프로그램
    - 프로시저 캐쉬에 저장되어 호출 실행되므로 처리속도가 빠름
    - DB 내부 구조 보안
(사용 형식)
CREATE [OR REPLACE] PROCEDURE 프로시저명 [ (
변수명 [ IN | OUT | INOUT 타입명] [,]
        :
변수명 [ IN | OUT | INOUT 타입명] ) ] 
IS | AS
선언영역 (변수/상수/커서) ;
BEGIN
    비지니스 로직처리 sql문  ;
END;

[실행]
    - 반환값이 없으므로 SELECT문 등 표준 SQL문에는 사용할 수 없음
(실행문 형식-1 : 독립적으로 실행)
EXEC | EXECUTE 프로시저명 [ (매개변수list) ] ;

(실행문 형식-2 : 다른 블록이나 함수, 프로시저에서 실행)
프로시저명 [ (매개변수list)];

사용 예시) 키보드로 기간을 입력 받아 해당 기간동안 상품별 매입현황을 조회하시오
출력 사항은 상품코드, 상품명, 매입수량, 매입금액이다
-- 여러개의 행일 때 커서
CREATE OR REPLACE PROCEDURE proc_buyprod_01(
    P_SDATE IN CHAR, P_EDATE IN CHAR)
    IS
        L_SDATE DATE:= TO_DATE (P_SDATE||'01');
        L_EDATE DATE:= LAST_DAY (TO_DATE(P_EDATE||'01'));
        L_RES VARCHAR2(500);   -- 기억장소
    
    CURSOR cur_buyprod_01 IS 
        SELECT A.BUY_PROD AS BID, B.PROD_NAME AS BNAME,
                       SUM(A.BUY_QTY) AS BQTY, SUM(A.BUY_QTY*B.PROD_COST) AS BSUM
            FROM BUYPROD A, PROD B
            WHERE A.BUY_PROD = B.PROD_ID 
                AND A.BUY_DATE BETWEEN L_SDATE AND L_EDATE
            GROUP BY A.BUY_PROD, B.PROD_NAME
            ORDER BY 1;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('상품번호     매입수량        매입금액        상품명');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
        FOR BREC IN cur_buyprod_01 LOOP
            L_RES:=BREC.BID||'   '||TO_CHAR(BREC.BQTY,'9,999') || '   ' ||
                            TO_CHAR(BREC.BSUM,'99,999,999')||'  '||BREC.BNAME;
            DBMS_OUTPUT.PUT_LINE(L_RES);
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
        END LOOP;
    END;
    
    
    [실행]
    EXECUTE proc_buyprod_01('202001','202003')
    
 사용 예시)
 부서번호를 입력 받아 해당 부서의 평균급여와 부서명, 관리사원명을 출력하는
 프로시저를 작성하시오
 CREATE OR REPLACE PROCEDURE proc_emp_01(
    P_DEPT_ID IN HR.DEPARTMENTS.DEPARTMENT_ID%TYPE,
    P_AVG_SAL OUT NUMBER,
    P_DEPT_NAME OUT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE,
    P_MAN_NAME OUT HR.EMPLOYEES.EMP_NAME%TYPE)
IS
BEGIN
    -- 평균급여
    SELECT ROUND(AVG(SALARY)) INTO P_AVG_SAL
        FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID = P_DEPT_ID;
    -- 부서명과 관리사원번호
    SELECT  B.DEPARTMENT_NAME, A.EMP_NAME
          INTO P_DEPT_NAME, P_MAN_NAME
        FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE B.DEPARTMENT_ID=P_DEPT_ID
        AND B.MANAGER_ID = A.EMPLOYEE_ID;
END;
    
[실행] - 키보드로 부서번호 입력

ACCEPT P_DID PROMPT '부서번호 (10~100) : '
DECLARE
    L_DID   DEPARTMENTS.DEPARTMENT_ID%TYPE :=TO_NUMBER('&P_DID');
    L_ASAL  NUMBER:=0;
    L_DNAME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    L_ENAME EMPLOYEES.EMP_NAME%TYPE;
BEGIN
    proc_emp_01(L_DID, L_ASAL, L_DNAME, L_ENAME);       -- 블록에서 실행 EXECUTE 
    
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || L_DID);
    DBMS_OUTPUT.PUT_LINE('부서명: ' || L_DNAME);
    DBMS_OUTPUT.PUT_LINE('평균임금 : ' || L_ASAL);
    DBMS_OUTPUT.PUT_LINE('관리사원: ' || L_ENAME);
END;
 
 CREATE TABLE TEMP_MEMBER(
    MEM_ID VARCHAR2(15),
    MEM_NAME VARCHAR2(20),
    MEM_JOB VARCHAR2(40),
    MEM_MILEAGE NUMBER(5));
    
 )
 -- 프로시저는 저장, 되돌려주는 값이 없음
 -- 되돌려줘야된다면 함수  
 사용 예시)
 회원아이디를 입력받아 이름, 직업, 마일리지를 출력하는 프로시저를 작성하시오
 
CREATE OR REPLACE PROCEDURE proc_member_01(
    P_MID IN MEMBER.MEM_ID%TYPE)
IS
    L_NAME MEMBER.MEM_NAME%TYPE;
    L_JOB MEMBER.MEM_JOB%TYPE;
    L_MILEAGE NUMBER(5):=0;
BEGIN
    SELECT MEM_NAME, MEM_JOB, MEM_MILEAGE
    INTO L_NAME, L_JOB, L_MILEAGE
    FROM MEMBER
    WHERE MEM_ID=P_MID;
    
    INSERT INTO TEMP_MEMBER VALUES (P_MID, L_NAME,L_JOB,L_MILEAGE);
    COMMIT;
END;

[실행]
EXECUTE proc_member_01 ('c001');

사용예시)
오늘(2024/04/04) 'f001' 회원이 'P201000017' 상품을 3개 구매 했다
이를 처리하는 프로시저를 작성하시오
1) CART테이블에 저장
2) REMAIN 테이블에 재고수량 UPDATE
3) 'f001'회원의 마일리지 UPDATE

CREATE OR REPLACE PROCEDURE proc_cart_insert(
     P_DATE IN DATE,
    P_MID IN MEMBER.MEM_ID%TYPE,
    P_PID IN PROD.PROD_ID%TYPE,
    P_QTY IN NUMBER)
IS
    L_CART_NO CHAR(13);
    L_MILEAGE NUMBER:=0;
    L_REC_CNT NUMBER :=0;       -- CART 테이블의 오늘 날짜 판매 행의 수
BEGIN
    --카트번호(CART_NO) 생성
    SELECT COUNT(*) INTO L_REC_CNT
    FROM CART
    WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD');
    
    IF L_REC_CNT=0 THEN
        L_CART_NO:=TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('00001');
    ELSE
        SELECT MAX(CART_NO)+1 INTO L_CART_NO
        FROM CART
        WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD')
        AND ROWNUM=1;
    END IF;
    -- CART에 저장
    INSERT INTO CART
    VALUES(P_MID,L_CART_NO,P_PID,P_QTY);
    
    -- 재고 UPDATE
    UPDATE REMAIN A
            SET A.REMAIN_O = A.REMAIN_O +P_QTY,
                    A.REMAIN_J_99 = A.REMAIN_J_99 - P_QTY,
                    A.REMAIN_DATE = P_DATE
     WHERE A.PROD_ID=P_PID;
     
     -- 마일리지 UPDATE
     SELECT PROD_MILEAGE*P_QTY INTO L_MILEAGE
        FROM PROD
      WHERE PROD_ID=P_PID;

     UPDATE MEMBER
            SET MEM_MILEAGE = MEM_MILEAGE+L_MILEAGE
    WHERE MEM_ID=P_MID;
    COMMIT;
END;
    
EXECUTE proc_cart_insert (SYSDATE,'f001','P201000017',3);

