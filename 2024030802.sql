2024-0308-02) 기타 자료형
 - 2진 데이터를 저장하기 위한 자료형
 - BLOB, BFILE, RAW, LONG RAW 가 지원
 - 2진자료를 저장하면 DBMS는 해당 2진 자료를 변환하거나 해석하지 않음

 1. RAW
  . 상대적으로 작은 양으 이진자료 저장
  . 인덱스 처리 가능
  . 최대 2000 BYTE 저장 가능
  . 16진수와 2진수 형태로 저장
  
(사용형식)
    컬럼명 RAW (크기)
    
 (사용예시)
    CREATE TABLE TEMP08 (
        COL1 RAW(1000),
        COL2 RAW(50) );

    INSERT INTO TEMP08 VALUES (HEXTORAW('7DA5'),'0111110110100101');
    
    SELECT * FROM TEMP08;
    
 2. BFILE
  . 이진자료 저장
  . 최대 4GB까지 저장
  . 원본자료를 데이터베이스 밖에 저장하고 데이터베이스에는 파일명과 경로명만 저장
  . 자주 업데이트(변경)되는 이진자료 저장에 유리함
 (사용형식)
    컬럼명 BFILE
    
 사용 예시)
    CREATE TABLE TEMP09(
        COL1 BFILE);
    
** BFILE 형태로 그림을 저장하는 절차
 1) 원본파일(그림파일) 저장
    sample.jpg
    
 2) 디렉토리객체생성
    (사용형식)
    CREATE DIRECTORY 별칭 AS 절대경로
    CREATE DIRECTORY TEST_DIR AS 'D:\A_TeachingMaterial\02_Oracle\work';
 3) 자료 삽입
    INSERT INTO TEMP09 VALUES(BFILENAME('TEST_DIR','sample.jpg'));
    
 ** 입력확인
    SELECT * FROM TEMP09;
    
 3. BLOB
  . 이진자료 저장
  . 최대 4GB까지 저장
  . 원본자료를 데이터베이스 내부에 저장
  . 변경이 일어나지 않은 이진자료 저장에 유리함
  . 데이터의 저장과 변환은 PL/SQL의 문법을 사용해야함
  (사용형식)
    컬럼명 BLOB
    
 사용예시)
    CREATE TABLE TEMP10(
        COL1 BLOB);

 ** 자료 삽입 - 익명 BLOCK 사용
 
    DECLARE
        L_DIR   VARCHAR2(20):='TEST_DIR';
        L_FILE  VARCHAR2(30):='sample.jpg';
        L_BFILE BFILE;
        L_BLOB  BLOB;
    BEGIN
        INSERT INTO TEMP10 (COL1) VALUES(EMPTY_BLOB()) RETURN COL1 INTO L_BLOB;
        
        L_BFILE := BFILENAME(L_DIR, L_FILE);
        DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
        
        DBMS_LOB.LOADFROMFILE(L_BLOB,L_BFILE,DBMS_LOB.GETLENGTH(L_BFILE));
        DBMS_LOB.FILECLOSE(L_BFILE);
        
        COMMIT;
    END;
    