2024-0321-01) 순위함수
    - 오라클에서 성적, 급여, 매출 등의 자료에 대한 순위를 구할 때 사용
    - 순위를 부여하는 방법에 따라 RANK, DENSE_RANK, ROW_NUMBER로 구분
    - SELECT 절에서 사용
 (사용형식)
  RANK() | DENSE_RANK() | ROW_NUMBER() OVER(ORDER BY 컬럼명 [DESC | ASC] [,
         컬럼명 [DESC | ASC] ,...] ) AS 컬럼 별칭
 . 'RANK() ' : 일반적 순위 부여 방식(같은 값이면 같은 등수부여하고 다음 등수는 '현재등수+동점자수'이다)
 EX) 90,80,80,80,70,60
         1,  2,  2, 2,  5,  6
 . 'DENSE_RANK()' : 같은 값이면 같은 등수 부여하고 다음 등수는 '현재등수' 다음 등수이다.
 EX) 90,80,80,80,70,60
         1,  2,  2, 2,  3,  4
 . 'ROW_NUMBER()' : 같은 값이라도 다음 등수 부여(단, 값은 정렬되어있음)
 EX) 90,80,80,80,70,60
         1,  2,  3, 4,  5,  6
         
사용 예시)
사원테이블에서 사원들의 급여에 따라 등수를 부여하시오
등수는 많은 급여부터 차례대로 등수 부여
Alias는 사원번호, 사원명, 부서번호, 직무코드,급여,순위
SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서번호,
              JOB_ID AS 직무코드,
              SALARY AS 급여,
              RANK() OVER(ORDER BY SALARY DESC) AS "순위(RANK)",
              DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위(DENSE_RANK)",
              ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS "순위(ROW_NUMBER)"
FROM HR.EMPLOYEES;

사용 예시)
사원테이블에서 사원들의 급여에 따라 등수를 부여하시오
단, 등수는 많은 급여부터 차례대로 등수를 부여하되
같은 급여인 경우 입사일이 빠른 사원부터 등수를 부여하시오
SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              JOB_ID AS 직무코드,
              SALARY AS 급여,
              RANK() OVER(ORDER BY SALARY DESC, HIRE_DATE) AS 순위
FROM HR.EMPLOYEES;

** 그룹별 순위 구하기
    그룹별로 순위가 필요한 경우 사용
(사용형식)
 RANK () | DENSE_RANK() | ROW_NUMBER() OVER(PARTITION BY  컬럼명 [, 컬럼명, ...]
 ORDER BY 컬럼명 [DESC | ASC] [,컬럼명 [DESC | ASC] , ...] ) AS 컬럼명
 
 사용 예시)
 사원테이블에서 각 부서별 급여에 따른 순위를 부여
 SELECT DEPARTMENT_ID AS 부서번호,
               EMP_NAME AS 사원명,
               SALARY AS 급여,
               RANK() OVER(PARTITION BY DEPARTMENT_ID 
                            ORDER BY SALARY DESC ) AS 순위
 FROM HR.EMPLOYEES;
 
 사용 예시)
 2020년 4월 회원별 구매금액합계를 구하고 금액이 많은 회원부터 순위를 각 성별로 부여하시오
 SELECT CASE WHEN SUBSTR(D.MEM_REGNO2,1,1) IN ('1','3') THEN '남성' 
                          ELSE '여성' END AS 성별,
                D.MEM_NAME AS 회원명,
                TA.CSUM AS 구매금액합계,
                RANK() OVER(PARTITION BY CASE WHEN SUBSTR(D.MEM_REGNO2,1,1) IN ('1','3') THEN '남성' 
                                                                ELSE '여성' END ORDER BY TA.CSUM DESC) AS 순위
  FROM MEMBER D,
                                 (SELECT CART_MEMBER,
                                                SUM(B.CART_QTY*C.PROD_PRICE) AS CSUM
                                      FROM CART B, PROD C
                                    WHERE B.CART_PROD=C.PROD_ID
                                         AND SUBSTR(B.CART_NO,1,6)='202004'
                                     GROUP BY CART_MEMBER ) TA 
  WHERE TA.CART_MEMBER=D.MEM_ID;


