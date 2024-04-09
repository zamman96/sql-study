2024-0401-01) PL/SQL
    - Procedure Language - SQL
    - 구조적 언어인 SQL의 제한적 성질(분기문, 반복문, 변수의 부재)을 보완한 SQL
    - block구조로 여러 SQL문을 한번에 실행 가능
    - 모듈화/캡슐화가 가능
    - 서버에 저장되어 빠른 실행과 반복사용 가능
    - 표준 문법이 없음 (각 DBMS에 종속적)
    - 익명블록(Anonymous Block), User Defined Function, Stored Procedure,
      Trigger, Package 등이 제공됨
1. 익명블록
    - 이름이 없는 블록
    - PL/SQL의 기본 구조 제공
    - 선언부/실행부로 구성
(구성요소)
 DECLARE
    선언부 : 변수/상수/커서 선언
 BEGIN
    실행부 : 처리할 비지니스 로직을 구현한 SQL문
        :
    [EXCEPTION
        예외처리;
    ]
 END;
 
사용 예시)
 2020년 5월 가장 많이 구매한 고객의 회원번호, 이름, 주소, 구매액을 출력하는 익명블록 작성
DECLARE
    L_MID MEMBER.MEM_ID%TYPE; -- 회원번호
    L_MNAME VARCHAR2(100); -- 이름
    L_ADDR VARCHAR2(255); --  주소
    L_AMT NUMBER:=0; -- 구매금액
 BEGIN
 --2020년 5월 가장 많이 구매한 고객
 SELECT TA.CID, TB.MEM_NAME, TB.MEM_ADD1 || ' ' || MEM_ADD2, TA.CSUM
   INTO L_MID, L_MNAME, L_ADDR, L_AMT
   FROM (SELECT A.CART_MEMBER AS CID,
                SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
           FROM CART A, PROD B
          WHERE A.CART_PROD=B.PROD_ID
            AND SUBSTR(CART_NO,1,6) = '202005'
          GROUP BY A.CART_MEMBER
          ORDER BY 2 DESC) TA, MEMBER TB
WHERE TA.CID=TB.MEM_ID
  AND ROWNUM=1;
  -- system.out.println 역할
    DBMS_OUTPUT.PUT_LINE('회원번호 : ' || L_MID);
    DBMS_OUTPUT.PUT_LINE('회원명 : ' || L_MNAME);
    DBMS_OUTPUT.PUT_LINE('주소 : ' || L_ADDR);
    DBMS_OUTPUT.PUT_LINE('구매금액 : ' || L_AMT);
    
    EXCEPTION
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('오류발생 : ' || SQLERRM);
 END;
 
1) 변수와 상수
(사용 형식)
 식별자 [CONSTANT] 데이터타입 [:= 초기값]
 . 'CONSTANT' : 식별자를 상수로 선언할 때 사용
 . 데이터타입 : 오라클에서 사용하는 모든 타입 사용 가능
 . ':=초기값'을 생략하면 '식별자'에는 NULL값으로 초기화됨
 
 ** 오라클 변수의 종류와 선언 형식
 (1) SCLAR 변수
    . 일반적인 변수로 하나의 값만 저장하는 변수
    . 선언은 위의 사용형식에 따라 선언
        (ex) L_AMT NUMBER(5) :=0;
 (2) REFERENCE 변수
    . 해당 테이블의 행이나 컬럼타입을 참조하는 변수
    . (사용형식)
식별자 [CONSTANT] 테이블명.컬럼명%TYPE [:=초기값] --COLUMN 참조
식별자 [CONSTANT] 테이블명%ROWTYPE [:=초기값] -- ROW(행) 참조

ex) L_MILEAGE MEMBER.MEM_MILEAGE%TYPE 
--L_MILEAGE변수의 타입이 MEMBER테이블의 MEM_MILEAGE컬럼의 타입과 크기가 같게 선언

L_CART_REC CART%ROWTYPE
-- L_CART_REC 변수는 CART테이블 한 행과 같은 타입으로 선언됨. 따라서 L_CART_REC로 참조할 수 있는 값의 형태는 CART_MEMBER에 저장된 자료는 L_CART_REC.CART_MEMBER로 CART_NO는  L_CART_REC.CART_NO로 CART_PROD는 L_CART_REC.CART_NO로 각각 참조 가능함

(3) BIND 변수
 .프로시저와 함수에서 사용하여 매개변수의 전달을 담당하는 변수
 (ex) CREATE OF REPLACE FUNCTION fn_create_cart_no (
            P_DATE IN DATE,
            P_MEM_ID IN MEMBER.MEM_ID%TYPE)
                ::
            END;
            
        CREATE OF REPLACE PROCEDURE proc_sales_report (
            P_PERIOD IN VARCHAR2,
            P_RESULT OUT VARCHAR2)
                ::
            END;
            
2) 분기문
    - IF문이 제공됨
(사용형식)
IF 조건 THEN
	명령문1;
[ELSE
	명령문2;]
END IF;

(사용형식)
IF 조건 THEN
	명령문1;
ELSIF 조건 THEN
	명령문2;
END IF;

(사용형식)
IF 조건 THEN
    IF 조건 THEN
        명령문1;
    ELSE
        명령문2;
    END IF;
[ELSE
    명령문3;]
END IF;

사용예시)
회원들의 마일리지를 조회하여 평균값보다 큰 마일리지를 보유한 회원은
'우수회원 입니다'라는 메세지를, 평균보다 적으면 '분발하세요'라는
메세지를 출력하시오
출력은 
                                         평균마일리지 :
-------------------------------------------------------------
회원번호    회원명     보유마일리지      비고
-------------------------------------------------------------

-------------------------------------------------------------
  처리인원 : 명
  
DECLARE
    L_AMILE NUMBER:=0; -- 평균마일리지    
    L_MID MEMBER.MEM_ID%TYPE; -- 회원번호
    L_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
    L_MILE NUMBER:=0; -- 보유마일리지
    L_REMARKS VARCHAR2(100); -- 비고
    
    CURSOR cur_member01 IS
        SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
            FROM MEMBER;
BEGIN
    OPEN cur_member01;
    SELECT ROUND(AVG(MEM_MILEAGE)) INTO L_AMILE
        FROM MEMBER;
          DBMS_OUTPUT.PUT_LINE(LPAD('평균마일리지 : ' || L_AMILE,60,' '));
          DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('       회원번호        회원명        마일리지        비고');
          DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    LOOP
        FETCH cur_member01 INTO L_MID, L_MNAME, L_MILE;
        EXIT WHEN cur_member01%NOTFOUND;
        IF L_MILE > L_AMILE THEN
            L_REMARKS := '우수회원 입니다';
        ELSE
            L_REMARKS := '분발하세요';
        END IF;
        DBMS_OUTPUT.PUT(LPAD(L_MID,7,' '));
        DBMS_OUTPUT.PUT('        ');
        DBMS_OUTPUT.PUT(RPAD(L_MNAME,8,' '));
        DBMS_OUTPUT.PUT(TO_CHAR(L_MILE,'999,999'));
        DBMS_OUTPUT.PUT('        ');
        DBMS_OUTPUT.PUT(L_REMARKS);
                DBMS_OUTPUT.PUT_LINE('  ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('처리인원 : ' || cur_member01.ROWCOUNT || '명');
    CLOSE cur_member01;
END;



DECLARE
    L_AMILE NUMBER:=0; -- 평균마일리지    
    L_MID MEMBER.MEM_ID%TYPE; -- 회원번호
    L_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
    L_MILE NUMBER:=0; -- 보유마일리지
    L_REMARKS VARCHAR2(100); -- 비고
    
    CURSOR cur_member01 IS
        SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
            FROM MEMBER;
BEGIN
    OPEN cur_member01;
    SELECT ROUND(AVG(MEM_MILEAGE)) INTO L_AMILE
        FROM MEMBER;
          
    DBMS_OUTPUT.PUT_LINE(LPAD('평균마일리지 : ' || L_AMILE, 60, ' ')); -- 수정된 부분
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('       회원번호        회원명        마일리지        비고');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
    
    LOOP
        FETCH cur_member01 INTO L_MID, L_MNAME, L_MILE;
        EXIT WHEN cur_member01%NOTFOUND;
        IF L_MILE > L_AMILE THEN
            L_REMARKS := '우수회원 입니다';
        ELSE
            L_REMARKS := '분발하세요';
        END IF;
        DBMS_OUTPUT.PUT(LPAD(L_MID, 10, ' ')); -- 수정된 부분
        DBMS_OUTPUT.PUT(LPAD(L_MNAME, 15, ' ')); -- 수정된 부분
        DBMS_OUTPUT.PUT(LPAD(TO_CHAR(L_MILE, '999,999'), 15, ' ')); -- 수정된 부분
        DBMS_OUTPUT.PUT_LINE(LPAD(L_REMARKS,20,' ')); -- 수정된 부분
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('처리인원 : ' || cur_member01%ROWCOUNT || '명'); -- 수정된 부분
    CLOSE cur_member01;
END;

사용 예시)
오늘이 2020년 7월 28일이라고 가정하고 CART_NO를 생성하는 함수를 작성하시오.
    CREATE OR REPLACE FUNCTION fn_create_cartno(
        P_DATE IN DATE)
        RETURN VARCHAR2 
    IS
        L_FLAG NUMBER(2):=0;
        L_TMP_CARTNO VARCHAR2(20);
    BEGIN
        SELECT COUNT(*) INTO L_FLAG
          FROM CART
         WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD');  -- L_FLAG 값 설정
        IF L_FLAG=0 THEN
           L_TMP_CARTNO:=TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('00001');
        ELSE
            SELECT TO_CHAR(TO_NUMBER(A.CART_NO)+1) INTO L_TMP_CARTNO
              FROM (SELECT CART_NO
                      FROM CART
                     WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD')
                     ORDER BY 1 DESC)A
             WHERE ROWNUM=1;
        END IF;
        RETURN L_TMP_CARTNO;
    END;    
    
    (실행)
    INSERT INTO CART
    VALUES('m001', fn_create_cartno(SYSDATE),'P302000005',5);
    
3) 반복문
- 주로 커서 처리를 위한 목적으로 사용
- LOOP, WHILE, FOR문이 제공됨

(1) LOOP문
 . 반복문의 기본 구조를 제공
 . 무한루프 제공
 (사용 형식)
 LOOP
    반복 수행 명령문
            :
    [EXIT WHEN 조건;]
END LOOP;
. 'EXIT WHEN 조건' : 조건이 참이면 반복을 벗어남(END LOOP 다음 명령 수행)

** 커서
    - 커서는 오라클 SQL명령으로 영향 받은 결과 집합(넓은 의미의 커서)
    - 협의의 커서는 SELECT문의 결과 집합
    - 개발자가 결과 집합내부의 자료를 접근할 수 있는 방법을 제공
    - 커서 속성
    -------------------------------------------------------------------------------------------------------
            커서 속성                           내용
    -------------------------------------------------------------------------------------------------------
        SQL%ISOPEN              커서가 OPEN된 상태이면 TRUE 반환
        SQL%NOTFOUND      결과 집합에 자료가 없으면 TRUE
        SQL%FOUND              결과 집합에 자료가 있으면 TRUE
        SQL%ROWCOUNT      커서 내의 행의 갯수
     -------------------------------------------------------------------------------------------------------   
    가 ) 묵시적커서
        . 일반적인 SELECT문의 결과로 이름을 부여하지 않은 커서
        . 결과가 출력될 때 OPEN되었다가 출력이 종료되면 즉시 CLOSE 됨
        . 개발자가 커서 내부에 접근할 수 없음 (SQL%ISOPEN 값이 늘 FALSE)
    나) 명시적 커서
        . 이름을 부여한 커서
        . 개발자가 커서 내부에 접근할 수 있음
    (사용형식)
    CURSOR 커서명 [(변수list)] IS
    SELECT 문;
     . '변수list' : 커서 OPEN문에서 전달되는 값을 보관하는 바인딩 변수로 크기를 선언하지 않음
     . 커서의 사용 절차
        커서 선언(선언부) -> 커서OPEN -> 커서 FETCH -> 커서 종료(CLOSE)
     . 커서OPNE
        - 사용할 커서를 OPEN
        - (기술 형식)
         OPEN 커서명 [(변수list)]
     . 커서 FETCH
        - 커서 집합의 자료를 행단위로 읽어올 때 사용
        - (기술 형식)
        FETCH 커서명 INTO 변수list;
            . 커서문의 SELECT 정의 컬럼 값을 INTO 다음 변수에 저장
            . 보통 반복문 안에 기술
      . 커서 CLOSE
        - OPEN된 커서를 닫음
        - CLOSE 되지 않은 커서는 재 OPEN 될 수 없다
        - (기술형식)
        CLOSE 커서명;
사용 예시)
키보드로 10-110사이의 부서번호를 입력받아 해당 부서에 근무하는 사원
정보를 출력하시오. (커서 사용), 사원번호, 사원명, 입사일, 급여

ACCEPT P_DEPT PROMPT '부서번호 입력 (10~110) : '     -- P_DEPT를 호출하면 입력창을 띄움 입력값은 P_DEPT값
DECLARE
    L_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;    --사원번호
    L_ENAME VARCHAR2(200);      -- 사원명
    L_HDATE DATE;   -- 입사일
    L_SAL NUMBER :=0;   -- 급여
    
    CURSOR cur_emp_dept(DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS   --커서(변수명)
        SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, SALARY
            FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID=DID;    -- 변수 조건
BEGIN
    OPEN cur_emp_dept(TO_NUMBER('&P_DEPT'));    -- &P_DEPT > 입력창

    LOOP
        FETCH cur_emp_dept INTO L_EID, L_ENAME, L_HDATE, L_SAL; -- 행단위 읽음
        EXIT WHEN cur_emp_dept%NOTFOUND;    --자료가 없으면 TRUE / EXIT WHEN 조건이 TRUE이면 LOOP종료
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('       사원 번호 : '|| L_EID);
        DBMS_OUTPUT.PUT_LINE('       사원명 : '|| L_ENAME);
        DBMS_OUTPUT.PUT_LINE('       입사일 : '|| L_HDATE);
        DBMS_OUTPUT.PUT_LINE('       급여 : '|| L_SAL);
    END LOOP;
         DBMS_OUTPUT.PUT_LINE('=====================================');
         DBMS_OUTPUT.PUT_LINE('       사원수 : '|| cur_emp_dept%ROWCOUNT||'명');
    CLOSE cur_emp_dept;
END;

(2) WHILE 문
    .  JAVA의 WHILE 과 비슷한 구조 및 기능 제공
    (사용 형식)
    WHILE 조건 LOOP
        반복 수행 명령문
            :
    END LOOP;
        - '조건'이 참이면 반복수행하고 '조건'이 거짓이면  END LOOP 이후의 명령 수행
        
 사용 예시)
 상품테이블에서 분류코드 'P201'에 속한 상품 중 판매가가 
 가장 비싼 상품과 가장 저렴한 상품을 조회하시오
 상품번호, 상품명, 판매가
 SELECT B.PROD_ID,
                B.PROD_NAME,
                B.PROD_PRICE
FROM(SELECT MAX(PROD_PRICE) AS M1, MIN(PROD_PRICE) AS M2
                FROM PROD
             WHERE PROD_LGU='P201') A, PROD B
WHERE B.PROD_PRICE IN(A.M1,A.M2)
AND B.PROD_LGU='P201'
 
 DECLARE
    L_PID PROD.PROD_ID%TYPE;
    L_PNAME PROD.PROD_NAME%TYPE;
    L_PRICE PROD.PROD_PRICE%TYPE;
    
    CURSOR cur_lgu_price IS
     SELECT B.PROD_ID,
                B.PROD_NAME,
                B.PROD_PRICE
FROM(SELECT MAX(PROD_PRICE) AS M1, MIN(PROD_PRICE) AS M2
                FROM PROD
             WHERE PROD_LGU='P201') A, PROD B
WHERE B.PROD_PRICE IN(A.M1,A.M2)
AND B.PROD_LGU='P201';
 BEGIN
    OPEN cur_lgu_price;
    FETCH cur_lgu_price INTO L_PID, L_PNAME, L_PRICE;
    WHILE cur_lgu_price%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(L_PID||' '||L_PNAME||' '||L_PRICE);
    FETCH cur_lgu_price INTO L_PID, L_PNAME, L_PRICE;
    END LOOP;
    CLOSE cur_lgu_price;
END;
 
 사용 예시)
 거주지가 '충남'인 회원들을 출력하시오
 회원번호, 회원명, 주소
 DECLARE
     L_MID MEMBER.MEM_ID%TYPE;
    L_MNAME MEMBER.MEM_NAME%TYPE;
    L_ADDR VARCHAR2(300);
 
    CURSOR cur_member IS
    SELECT MEM_ID, MEM_NAME, MEM_ADD1||' '||MEM_ADD2
    FROM MEMBER
    WHERE MEM_ADD1 LIKE '충남%';
 BEGIN
     OPEN cur_member;
     FETCH cur_member INTO L_MID, L_MNAME, L_ADDR;
     WHILE cur_member%FOUND LOOP   -- WHILE에 FOUND속성을 사용하기 위해 FETCH를 위에 꺼냄
     DBMS_OUTPUT.PUT_LINE(L_MID||' '||L_MNAME||' '||L_ADDR);    -- 1번째 사람은 위에서 찾기 때문에 출력 후 FETCH
     FETCH cur_member INTO L_MID, L_MNAME, L_ADDR;
     END LOOP;
     CLOSE cur_member;
 END;
 
 (3) FOR 문
 . JAVA의 FOR과 비슷한 기능 제공
 (사용형식)
 FOR 제어변수 IN[REVERSE] 초기값...최종값 LOOP
    반복처리문;
END LOOP;

(커서처리용 FOR문)
FOR 레코드명 IN 커서명 | 커서용 SELECT문 LOOP
    반복처리문;
END LOOP;
** FOR문으로 커서를 사용하는 경우 OPEN/FETCH/CLOSE문이 생략됨
선언부에서 선언된 커서를 사용하거나(커서명) 또는 커서 구성에
사용되는 SELECT문을 직접 기술할 수 있다.

** FOR문을 사용할 경우 커서 내의 컬럼 참조는 레코드명.컬럼명으로 참조함

사용 예시)
거주지가 '충남'인 회원들을 출력하시오
회원번호, 회원명, 주소
DECLARE
 /*   CURSOR cur_for_cursor IS
        SELECT MEM_ID, MEM_NAME, MEM_ADD1||' '||MEM_ADD2 AS ADDR
            FROM MEMBER
        WHERE MEM_ADD1 LIKE '충남%'; */
BEGIN
--   FOR MEM_REC IN cur_for_cursor LOOP
     FOR MEM_REC IN (SELECT MEM_ID, MEM_NAME, MEM_ADD1||' '||MEM_ADD2 AS ADDR
                                          FROM MEMBER
                                       WHERE MEM_ADD1 LIKE '충남%') LOOP
     DBMS_OUTPUT.PUT_LINE(MEM_REC.MEM_ID||' '||MEM_REC.MEM_NAME||' '||MEM_REC.ADDR);
    END LOOP;
END;