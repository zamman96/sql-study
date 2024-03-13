2024-0313-01)
 7. 문자열 결합연산자 : ' | | '
    - 자바의 String class의 '+'와 같은 기능
    - 두 문자열을 결합하여 하나의 새로운 문자열 반환
    - 문자열 결합함수 CONCAT( )이 제공
    
 8. 표현식
    - 애플리케이션 언어의 IF 또는 SWITCH 문의 기능을 제공
    -  CASE WHEN ~ THEN ~ END와 DECODE 표현식이 제공됨
    - SELECT절에만 사용
 1) DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 결과n )
    . '컬럼'을 평가하여 그 값이 '조건1'과 같으면 '결과1'을 반환하고,
                                           '조건2'와 같으면 '결과2'를 반환.
                                           모든 '조건'과 일치하지 않으면 '결과n'을 반환(else~)
    . 자바 if 문으로 표현하면
    if (컬럼 == 조건1) 결과1;
    else if(컬럼 == 조건2) 결과2;
    else 결과n;
    
사용 예시)
회원테이블에서 회원번호, 회원명, 주민등록번호, 성별을 조회하시오.
    SELECT MEM_ID AS 회원번호,
                  MEM_NAME AS 회원명,
                  MEM_REGNO1 || '-' || MEM_REGNO2 AS 주민등록번호,
                  DECODE(SUBSTR(MEM_REGNO2,1,1),'1','남성','2','여성','3','남성','4','여성','데이터 오류') AS 성별
        FROM MEMBER
        
 2) CASE WHEN 조건1 THEN 반환값1
                WHEN 조건2 THEN 반환값2
                                   :
                WHEN 조건n THEN 반환값n
                ELSE 반환값m
    END       
    
사용 예시)
회원테이블에서 회원번호, 회원명, 주민등록번호, 성별을 조회하시오.
    SELECT MEM_ID AS 회원번호,
                  MEM_NAME AS 회원명,
                  MEM_REGNO1 || '-' || MEM_REGNO2 AS 주민등록번호,
                  CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' THEN '남성'
                            WHEN SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성' 
                            WHEN SUBSTR(MEM_REGNO2,1,1)='2' THEN '여성'
                            WHEN SUBSTR(MEM_REGNO2,1,1)='4' THEN '여성'
                            ELSE '데이터 오류'
                  END AS 성별
        FROM MEMBER
        
 3) CASE 컬럼 WHEN 값1 THEN 반환값1
                       WHEN 값2 THEN 반환값2
                                        :
                      WHEN 값n THEN 반환값n
            ELSE 반환값m
    END AS 별칭
    
사용 예시)
회원테이블에서 회원번호, 회원명, 주민등록번호, 성별을 조회하시오.
    SELECT MEM_ID AS 회원번호,
                  MEM_NAME AS 회원명,
                  MEM_REGNO1 || '-' || MEM_REGNO2 AS 주민등록번호,
                  CASE SUBSTR(MEM_REGNO2,1,1) WHEN '1' THEN '남성'
                                                                        WHEN '3' THEN '남성'
                                                                        WHEN '2' THEN '여성'
                                                                        WHEN '4' THEN '여성'
                                                                        ELSE '데이터 오류'
                  END AS 성별
        FROM MEMBER
    