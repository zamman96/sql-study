-- 과거 빌린 책 목록 조회
SELECT A.BOOK_NO,
              A.TITIE,
              A.AUTHOR,
              B.BOR_DATE,
              B.RETURN_DATE
    FROM BOOK A, BOOK_BORLIST B
    WHERE A.BOOK_NO=B.BOOK_NO
        AND B.MEM_NO = ?;
    
-- 현재 빌린 책 목록 조회       
SELECT A.BOOK_NO,
              A.TITIE,
              A.AUTHOR,
              B.BOR_DATE,
              B.RETURN_EXPDATE,
              B.POSTPONE
FROM BOOK A, BOOK_BORROW B
WHERE A.BOOK_NO=B.BOOK_NO
AND B.MEM_NO= ?;

-- 책 대여
-- MEM_STATE 판단
SELECT MEM_STATE
FROM MEMBER_BORROW
WHERE ?

-- 대출가능 날짜 조회

    

-- 연장 가능 확인 여부
SELECT DELAYYN
FROM BOOK_RENT
WHERE BOOK_NO = ?
AND MEM_NO = ?

-- 연장
UPDATE BOOK_BORROW
SET BOOK_STATE = '대출불가',
        RETURN_EXPDATE = RETURN_EXPDATE+7,
        POSTPONE = 'N'
WHERE BOOK_NO = ?
AND MEM_NO = ?

-- 반납 프로시저 실행
EXECUTE pro_book_return (SYSDATE, ? , ?);   --MEM_NO, BOOK_NO 

-- 대출 프로시저 실행
EXECUTE pro_book_rent (SYSDATE, ? , ?);   --MEM_NO, BOOK_NO 

-- 책 추가 프로시저 실행
EXECUTE pro_book_insert (?, ?, ?, ?, ?); --title, author, pub, pub_year, cate_no

-- 회원가입 프로시저
INSERT INTO MEMBER (MEM_NO, MEM_NAME, MEM_REGNO, MEM_ID, MEM_PASS, MEM_ADD) 
SELECT B.NO, '김테스트', '900114-1234567', 'test', 'test', '대전 둔산동' AS MEM_ADD)
FROM DUAL, (SELECT NVL(MAX(MEM_NO),0)+1 AS NO FROM MEMBER) B

EXECUTE pro_member_insert ('김영희', '950204-1234567', 'a001', '1234', '충남 어딜까')
-- 관리자 대출불가 책 조회
SELECT A.BOOK_NO,
              A.TITIE,
              A.AUTHOR,
              B.BOR_DATE,
              B.RETURN_EXPDATE,
              B.MEM_NO,
              C.MEM_NAME
    FROM BOOK A, BOOK_BORROW B, MEMBER C
    WHERE A.BOOK_NO=B.BOOK_NO
        AND BOOK_STATE='대출불가'
        AND C.MEM_NO=B.MEM_NO;
        
-- 관리자 연체된 회원 조회
SELECT A.BOOK_NO,
              A.TITIE,
              A.AUTHOR,
              B.BOR_DATE,
              B.RETURN_EXPDATE,
              B.MEM_NO,
              C.MEM_NAME
    FROM BOOK A, BOOK_BORROW B, MEMBER C
    WHERE A.BOOK_NO=B.BOOK_NO
        AND RETURN_EXPDATE>SYSDATE
        AND C.MEM_NO=B.MEM_NO;
  
        
-- 카테고리 번호와 이름 출력
SELECT CATE_NO, CATE_NAME
FROM BOOK_CATEGORY

--좌석파악
SELECT SEAT_NO, REF_HOUR
FROM PDS_REF
WHERE SEAT_NO IS NOT NULL   
AND TO_CHAR(REF_DATE,'YYYYMMDD')=TO_CHAR(SYSDATE,'YYYYMMDD');






