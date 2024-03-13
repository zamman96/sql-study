2024-0308-03)자료 검색 명령
 - SELECT 문으로 검색 기능 수행
 
 (사용형식)
    SELECT *|[DISTINCT][컬럼명 [AS 별칭],
            컬럼명 [AS 별칭],
                :
            컬럼명 [AS 별칭]
        FROM 테이블명
      [WHERE 조건]
      [GROUP BY 컬럼명[,컬럼명,...]]
    [HAVING 조건]
     [ORDER BY 컬럼명|컬럼인덱스 [ASC|DESC][,컬럼명|컬럼인덱스 [ASC|DESC],...]]
    
    - SELECT 문은 SELECT절, FROM절, WHERE절,GROUP BY절, HAVING절, ORDER BY절로 구성
    - 필수 절은 SELECT, FROM 절
    - 수행순서 : FROM -> WHERE -> SELECT 
    - SELECT 절 : 추출할 컬럼 정의 담당
        . '*' : 모든 컬럼 조회
        . DISTINCT : 중복행 제거
        . 컬럼명 [AS 별칭] : 해당 컬럼에 별칭을 부여
          - 별칭에 특수문자(공백 등)나 예약어(명령어 등)를 사용할 때는 반드시 ""로 묶어야함
          - AS는 생략 가능
          - 한 컬럼의 끝은 반드시 ','를 사용해야하며 마지막 컬럼 정의에는 ',' 생략
    - FROM 절 : 사용할 테이블(또는 뷰) 기술
        . QUERY 실행에 테이블이 불필요한 경우 'DUAL'(가상 테이블명)을 사용
    - ORDER BY 절
        . 출력 데이터의 정렬 지정
        . 기술된 '컬럼명'이나 '컬럼의 인덱스(SELECT 절에 기술된 컬럼의 순번)'를 기준으로
          오름차순(ASC)이나 내림차순(DESC)으로 정렬
        . 두 번째 기술되는 컬럼명은 첫 번째 컬럼명으로 정렬을 할 수 없을 때(같은 값)
          적용된다.
        
 사용 예시) 회원테이블 (MEMBER)에서 회원번호 (MEM_ID), 회원명(MEM_NAME), 직업(MEM_JOB),
          보유 마일리지(MEM_MILEAGE)를 조회하시오.
          -- 조건 x -> WHERE
 SELECT MEM_ID AS 회원번호,
        MEM_NAME AS 회원명,
        MEM_JOB AS 직업,
        MEM_MILEAGE AS "보유 마일리지"
        FROM MEMBER;
 
 사용 예시) 상품 분류 테이블(LPROD)의 모든 자료를 조회하시오.
 SELECT * 
    FROM LPROD;
 
 
 <숙제>
 
 사용 예시) 상품테이블(PROD)에서 상품번호(PROD_ID), 상품명(PROD_NAME), 
           매입단가(PROD_COST), 매출단가(PROD_PRICE), 할인판매단가(PROD_SALE)를 조회하시오.

 SELECT PROD_ID AS 상품번호,
        PROD_NAME AS 상품명,
        PROD_COST AS 매입단가,
        PROD_PRICE AS 매출단가,
        PROD_SALE AS 할인판매단가
    FROM PROD;
           
           
 사용 예시) 사원테이블(HR.EMPLOYEES)에서 사용하고 있는 부서번호(DEPARTMENT_ID)를 모두 조회하되 
         중복하지 않게 조회하며 순서대로 출력하시오 (작은값 -> 큰값)
         
 SELECT DISTINCT DEPARTMENT_ID AS 부서번호
    FROM HR.EMPLOYEES
    ORDER BY DEPARTMENT_ID DESC;    
         
         
 사용 예시) HR계정의 부서테이블(HR.DEPARTMENTS)의 모든 자료를 조회하시오.
 SELECT *
    FROM HR.DEPARTMENTS;
    
    
사용 예시) 회원테이블에서 회원번호, 회원명, 마일리지를 조회하되 마일리지가 많은 회원부터 출력하시오.
 SELECT MEM_ID AS 회원번호,
        MEM_NAME AS 회원명,
        MEM_MILEAGE AS 마일리지
     FROM MEMBER
     ORDER BY MEM_MILEAGE DESC;


사용 예시) 사원테이블(HR.EMPLOYEES)에서 사원번호(EMPLOYEE_ID), 사원명(EMP_NAME), 부서코드(DEPARTMENT_ID), 급여(SALARY)를
              조회하시오. 단, 급여가 가장 많은 사원부터 출력하시오  
 SELECT EMPLOYEE_ID AS 사원번호,
        EMP_NAME AS 사원명,
        DEPARTMENT_ID AS 부서코드,
        SALARY AS 급여
    FROM HR.EMPLOYEES
   ORDER BY SALARY DESC;


사용 예시) 위 문제에서 부서코드 순서별로(작은부서->큰부서코드),   같은 부서에서는 급여가 많은 사원순으로 출력하시오.
 SELECT EMPLOYEE_ID AS 사원번호,
        EMP_NAME AS 사원명,
        DEPARTMENT_ID AS 부서코드,
        SALARY AS 급여
    FROM HR.EMPLOYEES
    ORDER BY DEPARTMENT_ID ASC, 
             SALARY DESC;
          

          
        