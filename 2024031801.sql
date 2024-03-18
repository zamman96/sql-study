2024-0318-01) 변환 함수

1. CAST(expr AS type명)
    - 'expr'(컬럼이나 수식)을 'type'으로 형변환
    - 'type'은 오라클의 모든 타입 사용 가능
    - 형식을 지정하지 못해 사용빈도는 낮음
    
사용 예시)
SELECT CAST (PROD_COST AS CHAR(20)) AS "COL1",
              CAST (SUBSTR(PROD_ID,2) AS NUMBER(30)) AS "COL2"
    FROM PROD
    WHERE PROD_LGU='P201';

2. TO_CHAR(data [,fmt]) 
    - 주어진 자료(숫자, 날짜, 문자열)를 'fmt' 형식의 문자열 자료로 변환
    - date가 문자열인 경우 CHAR, CLOB 타입의 데이터만 혀용
    - 'fmt'날짜형과 숫자형이 있으며 생략되면 단순 문자열로 형 변환
1) 날짜형 형식지정 문자열
 ------------------------------------------------------------------------------------------------------------
         형식문자열                 의미                                               사용 예
 ------------------------------------------------------------------------------------------------------------
            AD, BC         기원 전(BC) 
                                기원 후(AD)            SELECT TO_CHAR(SYSDATE,'BC'),
                                                                            TO_CHAR(SYSDATE,'AD')
                                                                   FROM DUAL;
      YYYY,YYY,YY,Y         년도                SELECT TO_CHAR(SYSDATE,'YYYY'),
                                                                             TO_CHAR(SYSDATE,'YYY'),
                                                                             TO_CHAR(SYSDATE,'YY'),    
                                                                             TO_CHAR(SYSDATE,'Y'),  
                                                                             TO_CHAR(SYSDATE,'YYYY Q')
                                                                    FROM DUAL;
      Q                         분기                                                                
      MM, RM               월(로마자 월)           SELECT TO_CHAR(SYSDATE,'YYYY MM'),
                                                                             TO_CHAR(SYSDATE,'YYYY RM')
                                                                   FROM DUAL;
      MONTH, MON     '월'글자 추가출력         SELECT TO_CHAR(SYSDATE,'YYYY MONTH'),
                                                                                TO_CHAR(SYSDATE,'YYYY MON')
                                                                    FROM DUAL;
      W, WW, IW        주차                           SELECT TO_CHAR(SYSDATE,'YYYY MM W'),
                                                                                TO_CHAR(SYSDATE,'YYYY MM WW')
                                                                     FROM DUAL;
      DD, DDD, J         일                               SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'),
                                                                                 TO_CHAR(SYSDATE,'YYYY-MM-DDD'),
                                                                                 TO_CHAR(SYSDATE,'YYYY-MM-J')
                                                                      FROM DUAL;
      D, DAY, DY         요일                            SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY'),
                                                                                 TO_CHAR(SYSDATE,'YYYY-MM-DD DY'),
                                                                                 TO_CHAR(SYSDATE,'YYYY-MM-DD D')
                                                                       FROM DUAL;
      AM, A.M.             오전                           SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SS'),
                                                                                TO_CHAR(SYSDATE,'YYYY-MM-DD PM HH24:MI:SS')
                                                                        FROM DUAL;
      PM, P.M.             오후
      HH,HH12,HH24     시간
      MI                        분
      SS,SSSSS           초                              SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SS'),
                                                                                TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SSSSS')
                                                                        FROM DUAL;
      
      SELECT TO_CHAR(SYSDATE, 'SSSSS')
    FROM DUAL;
      
3. TO_DATE(), (날짜타입으로 변환)
4. TO_NUMBER() (숫자타입으로 변환)