2024-0307-01)오라클 데이터 타입
    - 오라클의 자료는 문자열, 숫자, 날짜,2진 자료형으로 구분
    1. 문자열 자료
     . ' ' 안에 표현된 자료를 문자열 자료라 함
     . 문자열자료를 저장하기 위한 데이터 타입은 고정형과 가변형으로 구분
     . 고정길이 문자열 : CHAR
     . 가변길이 문자열 : VARCHAR, VARCHAR2, NVARCHAR, LONG, CLOB 등이 제공
     
    1) CHAR
        - 고정길이 문자열을 저장
        - 최대 2000BYTE까지 저장 가능
        - 남는 공간은 공백으로 채워짐
        - 한글 한 글자는 3BYTE가 필요
        - 보통 기본키나 길이가 고정된 자료(우편번호, 주민등록번호 등)에 주로 사용
        (사용형식)
        컬럼명 CHAR(크기 [BYTE | CHAR])
            . '크기'는 정수로 기술
            . 'BYTE | CHAR' : '크기'가 BYTE인지 CHAR(글자수) 인지 판별
            . 'CHAR(글자수)'가 사용되더라도 한글 저장시 2000BYTE를 초과 할 수 없음
            . DEFAULT는 BYTE임
    사용예)
    CREATE TABLE TEMP01(
        COL1 CHAR(20 BYTE),
        COL2 CHAR(20 CHAR),
        COL3 CHAR(20));
        
    INSERT INTO TEMP01(COL1,COL2,COL3) VALUES('대전시 중구 846','대전시 중구 계룡로 846',
                                              '대전시 중구');
                                              
    SELECT * 
        FROM TEMP01;
        -- * : ALL
        
    SELECT LENGTHB(COL1) AS "컬럼1",
           LENGTHB(COL2) AS "컬럼2",
           LENGTHB(COL3) AS "컬럼3"
        FROM TEMP01;
        
    2) VARCHAR2
      - 가변길이 문자열을 저장
      - 최대 4000BYTE까지 저장 가능
      - 데이터가 저장되고 남는 공간은 시스템에 반환됨 (공간 부족 시 에러)
      - 한글 한 글자는 3BYTE가 필요
      - VARCHAR, NVARCHAR, NVARCHAR2 와 기능은 동일
      - NVARCHAR, NVARCHAR2 는 UTF-8, UTF-16형식으로 데이터를 변환하여 저장 (국제 표준 형식)
      (사용형식)
        컬럼명 VARCHAR2 (크기 [BYTE | CHAR])
        
    사용 예시)
        CREATE TABLE TEMP02(
            COL1 CHAR(100),
            COL2 VARCHAR2(100),
            COL3 VARCHAR2(100 BYTE),
            COL4 VARCHAR2(100 CHAR) );
            
        INSERT INTO TEMP02 VALUES('IL POSTINO BOYHOOD','IL POSTINO BOYHOOD',
                                  'IL POSTINO BOYHOOD', 'IL POSTINO BOYHOOD');
                                  
        SELECT * FROM TEMP02;
        
    3) LONG
    - 가변길이 문자열을 저장
    - 최대 2GB(Giga Byte) 까지 저장 가능
    - 데이터가 저장되고 남는 공간은 시스템에 반환 됨 (공간 부족시 에러)
    - 한글 한 글자는 3BYTE가 필요
    - 한 테이블에 하나의 LONG타입 컬럼만 정의 할 수 있음
    - 기능 개선 서비스가 중단됨 => CLOB (Character Large OBject)로 기능이 개선되어 제공
    - 일부 기능(함수)은 사용할 수 없음 
    (사용형식)
        컬럼명 LONG
        
    사용 예시)
    CREATE TABLE TEMP03 (
        COL1 VARCHAR2(4000),
--      COL2 LONG,
        COL3 LONG);
        
    INSERT INTO TEMP03 VALUES('BANANA APPLE PERSIMMON','BANANA APPLE PERSIMMON');
    
    SELECT * FROM TEMP03;
    
    SELECT SUBSTR(COL1, 5, 10) AS "VARCHAR2",
       --  SUBSTR(COL3, 5, 10) AS "LONG"
        FROM TEMP03;

    4) CLOB (Character Large OBject)
    - 가변길이 문자열 저장
    - 최대 4GB (Giga Byte)까지 저장 가능
    - 데이터가 저장되고 남는 공간은 시스템에 반환됨 (공간부족시 에러)
    - 한글 한 글자는 3byte가 필요
    - 한 테이블에 복수개의 CLOB 컬럼 정의 할 수 있음
    - 일부 기능(함수)은 DBMS_LOB API지원을 받아 사용 가능
    (사용형식)
    컬럼명 CLOB
    
    사용 예시)
     CREATE TABLE TEMP04 (
        COL1 VARCHAR2(4000),
        COL2 CLOB,
        COL3 CLOB);
        
    INSERT INTO TEMP04(COL1,COL2) VALUES('BANANA APPLE PERSIMMON','BANANA APPLE PERSIMMON');
     
    SELECT * FROM TEMP04;
    
    SELECT MOD((TO_DATE('20240307') - TO_DATE('00010101'))-1, 7) FROM DUAL;

    SELECT LENGTHB(COL1) AS "VARCHAR2",
           DBMS_LOB.GETLENGTH(COL2) AS "CLOB_LENGTH"
    --     LENGTHB(COL2) AS "CLOB"
        FROM TEMP04;
        

        
      