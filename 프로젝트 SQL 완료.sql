해결된것

-- book_no
DECLARE
    v_counter NUMBER := 1;
BEGIN
    FOR rec IN (SELECT DISTINCT CATE_NO FROM BOOK) LOOP
        FOR rec2 IN (SELECT * FROM BOOK WHERE CATE_NO = rec.CATE_NO) LOOP
            UPDATE BOOK
            SET BOOK_NO = rec2.CATE_NO || LPAD(v_counter, 4, '0')
            WHERE TITLE = rec2.TITLE;
            v_counter := v_counter + 1;
        END LOOP;
        v_counter := 1;
    END LOOP;
END;

CREATE SEQUENCE mem_no_seq START WITH 2 INCREMENT BY 1;

select mem_no_seq.CURRVAL
from dual;
------------------


--회원가입(seq) ren값 입력 트리거
CREATE OR REPLACE TRIGGER trg_member_rent_insert
AFTER UPDATE OF LOC_NO ON MEMBER
FOR EACH ROW
BEGIN
    INSERT INTO MEMBER_RENT (MEM_NO, TOTAL_VOL, CUR_VOL)
    VALUES (:NEW.MEM_NO,
            CASE 
                WHEN :NEW.LOC_NO = '042' THEN 5 
                ELSE 3 
            END,
            CASE 
                WHEN :NEW.LOC_NO = '042' THEN 5 
                ELSE 3 
            END);
END;
--------------
      
--전체 랭킹 TOP 10 / 분류별랭킹
SELECT BOOK_NO, CATE_NAME,TITIE,AUTHOR,PUB_YEAR,PUBLISHER,RENT_COUNT,BOOK_STATE
FROM( SELECT A.BOOK_NO AS BOOK_NO, 
                            B.CATE_NAME AS CATE_NAME, 
                            A.TITIE AS TITIE, 
                            A.AUTHOR AS AUTHOR, 
                            A.PUB_YEAR AS PUB_YEAR, 
                            A.PUBLISHER AS PUBLISHER, 
                            A.RENT_COUNT AS RENT_COUNT,
                            C.BOOK_STATE AS BOOK_STATE
                FROM BOOK A, BOOK_CATEGORY B, BOOK_RENT C
            WHERE A.CATE_NO=B.CATE_NO
            -- AND A.CATE_NO=2
                AND A.BOOK_NO=C.BOOK_NO
            ORDER BY 7 DESC)
WHERE NUM<=10;


-- 책검색
SELECT A.BOOK_NO,B.CATE_NAME, A.TITLE, A.AUTHOR, A.PUB_YEAR, A.PUBLISHER, A.RENT_COUNT,C.BOOK_STATE
FROM BOOK A, BOOK_CATEGORY B, BOOK_RENT C
WHERE TITLE LIKE '%사회%'
AND B.CATE_NO=A.CATE_NO
AND A.BOOK_NO=C.BOOK_NO

SELECT R.*
FROM (SELECT ROWNUM AS RN, A.BOOK_NO,B.CATE_NAME, A.TITLE, A.AUTHOR, A.PUB_YEAR, A.PUBLISHER, A.RENT_COUNT,C.BOOK_STATE
FROM BOOK A, BOOK_CATEGORY B, BOOK_RENT C
WHERE TITLE LIKE '%사회%'
AND B.CATE_NO=A.CATE_NO
AND A.BOOK_NO=C.BOOK_NO) R
WHERE R.RN>=30 AND R.RN<=40

-- BOOK_NO 매기기------------------------------------------------------------
UPDATE BOOK A
SET BOOK_NO = 
    (SELECT DISTINCT CATE_NO
    FROM BOOK B
    WHERE A.BOOK_NO=B.BOOK_NO) || LPAD(SEQ_BOOK_NO.NEXTVAL, 4, '0') ;
    
    UPDATE BOOK A
SET BOOK_NO = 
    (SELECT DISTINCT CATE_NO
    FROM BOOK B
    WHERE A.BOOK_NO=B.BOOK_NO) || SUBSTR(BOOK_NO,1,4) ;


CREATE SEQUENCE seq_SEAT_NO
START WITH 1;

UPDATE BOOK
SET BOOK_NO=NULL;
-----------------------------------------------------------------------------------------------

-- 반납 (프로시저 짜기)     BOOK_RENT / MEMBER_RENT / BOOK_RENTLIST
-- 입력받는 값 BOOK_NO, MEM_NO, SYSDATE

CREATE OR REPLACE PROCEDURE PRO_book_return(
    P_DATE IN DATE,
    P_MID IN MEMBER.MEM_NO%TYPE,
    P_BID IN BOOK.BOOK_NO%TYPE)
IS
    L_T_DATE DATE;      -- 오늘날 - 반납예정일
    L_L_DATE DATE;      -- 대출일
BEGIN
     -- INSERT BOOK_RENTLIST
     SELECT RENT_DATE INTO L_L_DATE
     FROM BOOK_RENT
     WHERE BOOK_NO=P_BID;
     
     INSERT INTO BOOK_HISTORY
     VALUES(P_BID,P_MID,L_L_DATE,P_DATE);

    -- UPDATE BOOK_RENT
UPDATE BOOK_RENT
SET BOOK_STATE = '대출가능',
        RENT_DATE = NULL,
        RETURN_PREDATE = NULL,
        MEM_NO = NULL,
        DELAYYN = NULL
WHERE BOOK_NO=P_BID;
    
    -- UPDATE MEMBER_RENT
SELECT RETURN_PREDATE INTO L_T_DATE
FROM BOOK_RENT
WHERE MEM_NO=P_MID AND BOOK_NO = P_BID;
    
UPDATE MEMBER_RENT
        SET CUR_VOL = CUR_VOL + 1,
                MEM_STATE = CASE WHEN EXISTS (
                                        SELECT 1
                                        FROM BOOK_RENT 
                                        WHERE RETURN_PREDATE >= P_DATE
                                      AND BOOK_NO = P_BID
                                       AND MEM_NO = P_MID
                                  )  THEN 'Y' ELSE 'N' END,
                RENT_AVADATE = CASE WHEN EXISTS (
                                      SELECT 1
                                        FROM BOOK_RENT 
                                        WHERE RETURN_PREDATE < P_DATE
                                        AND BOOK_NO = P_BID
                                        AND MEM_NO = P_MID
                                    ) THEN P_DATE + (P_DATE - L_T_DATE)*2 END
WHERE MEM_NO =P_MID;
    
    COMMIT;
END;
-------------------------------------------------------------------------------------
-- 대출 프로시저
-- BOOK RENT / MEMBER_RENT / BOOK

CREATE OR REPLACE PROCEDURE pro_book_RENT(
    P_DATE IN DATE,
    P_MID IN MEMBER.MEM_NO%TYPE,
    P_BID IN BOOK.BOOK_NO%TYPE)
IS
L_NUM NUMBER:=0;
BEGIN
-- UPDATE BOOK RENT
UPDATE BOOK_RENT
SET BOOK_STATE='대출불가',
        RENT_DATE=P_DATE,
        RETURN_PREDATE=P_DATE+14,
        MEM_NO=P_MID,
        DELAYYN='Y'
WHERE BOOK_NO = P_BID;

-- UPDATE MEMBER_RENT 
SELECT TOTAL_VOL-(CUR_VOL+1) INTO L_NUM
FROM MEMBER_RENT
WHERE MEM_NO=P_MID;

UPDATE MEMBER_RENT
SET MEM_STATE = CASE WHEN L_NUM=0 THEN '대출불가' ELSE '대출가능' END,
        CUR_VOL = CUR_VOL-1,
        RENT_AVADATE = P_DATE
WHERE MEM_NO = P_MID;
    
-- UPDATE BOOK RENT_COUNT
UPDATE BOOK
SET RENT_COUNT = RENT_COUNT+1
WHERE BOOK_NO = P_BID;

    COMMIT;
END;
-----------------------------------------------------------------------------------------------
--책 추가 프로시저
CREATE OR REPLACE PROCEDURE pro_book_insert(
    P_TITLE IN BOOK.TITLE%TYPE,
    P_AUTHOR IN BOOK.AUTHOR%TYPE,
    P_PUB IN BOOK.PUBLISHER%TYPE,
    P_PUB_YEAR IN BOOK.PUB_YEAR%TYPE,
    P_CATE_NO IN BOOK.CATE_NO%TYPE)
IS
L_NO NUMBER:=0;
BEGIN
-- BOOK_NO구하기
SELECT CATE_NO||LPAD(MAX(BOOK_NO)+1,4,0) INTO L_NO
FROM BOOK
WHERE CATE_NO=P_CATE_NO
GROUP BY CATE_NO;

-- INSERT BOOK 
INSERT INTO BOOK (BOOK_NO,TITLE,AUTHOR,PUBLISHER,PUB_YEAR,CATE_NO,RENT_COUNT)
SELECT L_NO,P_TITLE, P_AUTHOR, P_PUB, P_PUB_YEAR, P_CATE_NO,0
FROM DUAL;

--INSERT BOOK_RENT
INSERT INTO BOOK_RENT(BOOK_NO,BOOK_STATE)
VALUES(L_NO,'대출가능');
    COMMIT;
END;
------------------------------------------------------------------------------------------------