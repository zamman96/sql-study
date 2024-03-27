2024-0327-01) 
3. SUBQUERY 를 사용한 DELETE
(사용 형식)
    DELETE FROM 테이블명
    WHERE 조건
- '조건'에 서브쿼리가 사용된 경우

사용 예시)
사원테이블에 퇴직처리를 위하여 RETIRE 테이블을 생성하시오
테이블명 : RETIRE
 ----------------------------------------------------------------------------------
         컬럼명                    타입                기본값                  PK/FK
-----------------------------------------------------------------------------------
 EMPLOYEE_ID        NUMBER(6)                                     PK&FK
 DEPARTMENT_ID    NUMBER(4)                                     FK
 JOB_ID                    VARCHAR2(10)                               FK
 RETIRE_DATE         DATE                   SYSDATE
 -----------------------------------------------------------------------------------
 
 CREATE OR REPLACE TRIGGER TG_EMP_DELETE
    BEFORE DELETE ON EMPLOYEES
    FOR EACH ROW
BEGIN
    INSERT INTO RETIRE
        VALUES (:OLD.EMPLOYEE_ID, :OLD.DEPARTMENT_ID, :OLD.JOB_ID, SYSDATE) ;
END;
 
사용 예시)
사원테이블에서 입사일이 2017년 7월 이전인 사원들을 일괄 퇴직 처리하시오.

SELECT A.EMPLOYEE_ID
FROM (SELECT EMPLOYEES_ID, DEPARTMENT_ID
               FROM EMPLOYEES
            WHERE HIRE_DATE<=TO_DATE('20170630') ) A,
-----------------------------------------------------------------------------------
DELETE FROM EMPLOYEES
WHERE HIRE_DATE<=TO_DATE('20170630');

COMMIT;




    
