2024-0326-01) 서브쿼리

사용 예시)
HR계정의 사원테이블에서 부서의 위치가 미국에 위치한 부서에 속한 사원의 
평균 급여보다 더 많은 급여를 받는 미국 이외의 부서에 근무하는 사원정보를
조회하시오
Alias는 사원번호, 사원명, 부서명, 급여
(WHERE)
SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.SALARY AS 급여
FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
AND B.LOCATION_ID=C.LOCATION_ID
AND C.COUNTRY_ID!='US'
AND A.SALARY > (SELECT AVG(A.SALARY) AS BAVG
                                FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
                             WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
                                  AND B.LOCATION_ID=C.LOCATION_ID
                                  AND C.COUNTRY_ID='US');
               
(FROM)                   
SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              ROUND(BAVG) AS 평균급여,
              A.SALARY AS 급여
FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C,
            (SELECT AVG(A.SALARY) AS BAVG
               FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
            WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
                  AND B.LOCATION_ID=C.LOCATION_ID
                  AND C.COUNTRY_ID='US') D
WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
AND B.LOCATION_ID=C.LOCATION_ID
AND C.COUNTRY_ID!='US'
AND A.SALARY>D.BAVG
ORDER BY A.DEPARTMENT_ID, A.SALARY;
                                  

사용 예시)
회원테이블에서 마일리지가 많은 5명의 회원이 2020년 4월 구매한 정보를 조회하시오
Alias는 회원번호, 회원명, 구매금액합계
SELECT A.MEM_ID AS 회원번호,
              A.MEM_NAME AS 회원명,
              SUM(B.CART_QTY*C.PROD_PRICE) AS 구매금액합계
FROM MEMBER A, CART B, PROD C
WHERE A.MEM_ID=B.CART_MEMBER
AND B.CART_PROD = C.PROD_ID
AND SUBSTR(CART_NO,1,6)='202004'
AND A.MEM_ID IN(SELECT DID
                                 FROM (SELECT MEM_ID AS DID, MEM_MILEAGE
                                                FROM MEMBER
                                               WHERE MEM_MILEAGE IS NOT NULL
                                               ORDER BY MEM_MILEAGE DESC)
                                   WHERE ROWNUM<=5) 
GROUP BY A.MEM_ID, A.MEM_NAME, A.MEM_MILEAGE
ORDER BY 3 DESC;




사용 예시)
부서테이블에서 부서관리사원의 사원번호가 100인 부서에 속한 사원정보를 조회하시오
SELECT B.DEPARTMENT_NAME AS 부서이름,
              A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원이름
FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, 
        ( SELECT DEPARTMENT_ID AS BDID
              FROM HR.DEPARTMENTS
           WHERE MANAGER_ID=100 ) C
WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
AND B.DEPARTMENT_ID=C.BDID;

SELECT DEPARTMENT_ID AS 부서번호,
              EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원이름
FROM HR.EMPLOYEES A
WHERE EXISTS ( SELECT 1
              FROM HR.DEPARTMENTS B
            WHERE MANAGER_ID=100    -- 늘 참이므로 전체 107명 출력
                AND A.DEPARTMENT_ID=B.DEPARTMENT_ID);

사용 예시)
사원테이블에서 각 부서별 평균급여보다 더 많은 급여를 받는 사원정보를 조회하시오
Alias는 사원번호, 사원명, 부서번호, 부서평균급여, 급여
SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서번호,
              B.BAVG AS 부서평균급여,
              A.SALARY AS 급여
FROM HR.EMPLOYEES A, (SELECT  DEPARTMENT_ID AS BID,
                                                          ROUND(AVG(SALARY)) AS BAVG
                                              FROM HR.EMPLOYEES
                                            GROUP BY DEPARTMENT_ID) B
WHERE A.DEPARTMENT_ID=B.BID
AND A.SALARY>B.BAVG
ORDER BY 3, 5 DESC;


SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서번호,
              (SELECT  ROUND(AVG(SALARY)) AS BAVG
                                              FROM HR.EMPLOYEES B
                                              WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID) AS 부서평균급여,
              A.SALARY AS 급여
FROM HR.EMPLOYEES A
WHERE A.SALARY>(SELECT  ROUND(AVG(SALARY)) AS BAVG
                                              FROM HR.EMPLOYEES B
                                              WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID)
 ORDER BY 3, 5 DESC;        
 
(EXISTS 연산자 사용)

SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서번호,
              (SELECT  ROUND(AVG(SALARY)) AS BAVG
                                              FROM HR.EMPLOYEES B
                                              WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID) AS 부서평균급여,
              A.SALARY AS 급여
FROM HR.EMPLOYEES A
WHERE EXISTS( SELECT  1
                             FROM HR.EMPLOYEES B
                        WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
                        AND A.SALARY>(SELECT  ROUND(AVG(SALARY)) AS BAVG
                                              FROM HR.EMPLOYEES B
                                              WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID))
 ORDER BY 3, 5 DESC;     
 
 
