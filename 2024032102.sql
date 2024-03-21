2024-0321-02) 조인 (JOIN)
 - 필요한 자료가 복수개의 테이블에 분산되어 저장되어 있으며
   공통의 컬럼으로 관계를 형성하고 있을 때 이 관계를 이용하여 자료를 추출하는
   연산이 JOIN이다.
 - 구분
    내부조인(INNER JOIN) / 외부조인(OUTER JOIN)
    일반조인 / ANSI JOIN
     그 밖에 CARTESIAN JOIN (CROSS JOIN), NATURAL JOIN
1. 내부조인
 - 조인조건에 일치하는 자료만으로 결과를 도출
 - 조인조건을 만족하지 않는 자료는 무시함
 - 동등조인(EQUI-JOIN), 비동등조인(NONE EQUI-JOIN), INNER JOIN(ANSI JOIN)
 (일반 조인 사용형식)
    SELECT [테이블별칭.] 컬럼명 [AS 별칭] [,]
                                    :
                  [테이블 별칭.] 컬럼명 [AS 별칭]
        FROM 테이블명 [별칭], 테이블명 [별칭] [, 테이블명 [별칭] ... ]
     WHERE 조인조건
      [AND 일반조건]
                  :
     - 테이블명 [별칭] : 사용되는 모든 테이블의 컬럼명이 모두 다른 경우 '별칭'은 생략 가능
     - '테이블 별칭'은 SELECT 절이나 WHERE 절 등에서 이름이 동일한 컬럼명들을
       참조할때는 반드시 사용해야 함
    - 조인조건 : 사용되는 테이블 사이의 공통 컬럼을 동등연산자('=')으로 사용한 조건식이나
       (EQUI-JOIN), 동등연산자('=') 이외의 연산자를 사용한 조건식(NONE EQUI-JOIN)을 기술
    - 조인조건과 일반조건은 AND 연산자로 연결함
   
    (ANSI조인 사용형식)
    SELECT [테이블별칭.] 컬럼명 [AS 별칭] [,]
                                    :
                  [테이블 별칭.] 컬럼명 [AS 별칭]
        FROM 테이블명 [별칭]
        INNER JOIN 테이블명 [별칭]  ON ( 조인조건 [ AND 일반조건] )
        INNER JOIN 테이블명 [별칭]  ON ( 조인조건 [ AND 일반조건] )  
                                                :
    [ WHERE 일반조건]
    
 1) CARTESIAN JOIN (CROSS JOIN)
  - 조인조건이 생략되었거나 잘못된 조인조건이 부여된 경우
  - 결과는 두 테이블의 행은 곱한 갯수와 열은 더한 결과를 반환
  - 반드시 필요한 경우가 아니면 수행 자제
(ANSI FORMAT)
    SELECT column_list
        FROM table_name
    CROSS JOIN table_name [ON join_condition] ;
    
사용 예시)
SELECT COUNT(*)
    FROM BUYPROD, PROD, CART;
    
SELECT COUNT(*)
    FROM BUYPROD
    CROSS JOIN PROD
    CROSS JOIN CART;
    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
                  :