2024-0329-01) SEQUENCE 객체
- 자동으로 증가 또는 감소되는 번호를 생성하기 위한 객체
- 테이블에 독립적
- 주로 적당한 PK를 선정할 수 없는 경우(ex. 게시판의 게시글번호 등) 사용
- 지나간 시퀀스 값은 재사용할 수 없다.

(사용 형식)
    CREATE SEQUENCE 시퀀스명
        [START WITH  값]  -- 시작 값, 기본값은 MINVALUE
        [INCREMENT BY 값]  -- 증감 값 기본은 1
        [MAXVALUE 값 | NOMAXVALUE]  -- 최대 값 NOMAXVALUE가 default이며 10^27
        [MINVALUE 값 | NOMINVALUE]  -- 최소 값 NOMINVALUE가 default이며 1
        [CYCLE | NOCYCLE]  -- 최대[최소]까지 도달 후 다시 시퀀스 생성 여부 결정
                                          -- default는 NOCYCLE
        [CACHE n | NOCACHE]  -- 시퀀스를 캐쉬에 생성해 놓고 사용할지 여부
                                              -- default는 CACHE 20 (더 빠르다)
        [ORDER | NOORDER]  -- 요청순서대로 생성 보장여부 default는 NOORDER
       
       - 시퀀스는 의사컬럼(Pseudo Column : 시스템에서 제공)을 사용하여 참조 됨
 ---------------------------------------------------------------------------------------------------------
                 의사 컬럼                                   내용
 ---------------------------------------------------------------------------------------------------------
    시퀀스명.NEXTVAL                    시퀀스의 다음 값
    시퀀스명.CURRVAL                   시퀀스가 가지고 있는 현재 값
 ---------------------------------------------------------------------------------------------------------
 **** 시퀀스가 생성된 후 반드시 NEXTVAL부터 호출되어야 한다
        NEXTVAL이 호출될 때 마다 증감값 만큼 증감됨 (주의)

사용 예시)
분류테이블에 다음 자료를 입력하시오
-------------------------------------------------------------------------
              컬럼                          값
-------------------------------------------------------------------------
    LPROD_ID                    10 부터 증가되는 값 (시퀀스 이용)
    LPROD_GU                    'P501'
    LPROD_NM                    '농산물'
-------------------------------------------------------------------------
    LPROD_ID                    11
    LPROD_GU                    'P502'
    LPROD_NM                    '임산물'
    -------------------------------------------------------------------------
    LPROD_ID                    12
    LPROD_GU                    'P503'
    LPROD_NM                    '수산물'
-------------------------------------------------------------------------

CREATE SEQUENCE seq_lprod_id
    START WITH 10;
    
INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
VALUES(seq_lprod_id.NEXTVAL, 'P501', '농산물');

INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
VALUES(seq_lprod_id.NEXTVAL, 'P502', '임산물');

INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
VALUES(seq_lprod_id.NEXTVAL, 'P503', '수산물');

SELECT * FROM LPROD;

SELECT seq_lprod_id.CURRVAL FROM DUAL;
