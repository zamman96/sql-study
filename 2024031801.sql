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
      AM, A.M.             오전/오후                   SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SS'),
                                                                                TO_CHAR(SYSDATE,'YYYY-MM-DD PM HH24:MI:SS')
                                                                        FROM DUAL;
      PM, P.M.           
      HH,HH12,HH24     시간
      MI                        분
      SS,SSSSS           초                                  SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SS'),
                                                                                     TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH24:MI:SSSSS')
                                                                         FROM DUAL;
2) 숫자형 형식지정 문자열
 ----------------------------------------------------------------------------------------------
         형식문자열                 의미/사용예                                                                            
 ----------------------------------------------------------------------------------------------     
             9                대응되는 자료가 유효 숫자이면 해당되는 자료 출력,
                               0이면 공백 출력(단, 소숫점이하 경우에는 '0'출력)
                               SELECT TO_CHAR(234, '9,999'),
                                            TO_CHAR(234.267, '9,999.99'),
                                            TO_CHAR(234, '999.99')
                                FROM DUAL;
             0               대응되는 자료가 유효숫자이면 해단되는 자료 출력,
                              0이면 0 출력 소숫점 이하인 경우에도 '0' 출력)
                              SELECT TO_CHAR(234, '0,000'),
                                            TO_CHAR(234.267, '0,000.00'),
                                            TO_CHAR(234, '000.99')
                                FROM DUAL;
            PR              주어진 숫자가 음수인 경우 '<>' 안에 출력
                               SELECT TO_CHAR(234, '9,999PR'),
                                            TO_CHAR(-234.267, '9,999.99PR'),
                                            TO_CHAR(-234, '999.99PR')
                                FROM DUAL;
             L($)           데이터 왼쪽에 화폐기호 출력(L은 지역화폐)
                                SELECT TO_CHAR(6782, 'L999,999'),
                                            TO_CHAR(234.267, '$9,999.99'),
                                            TO_CHAR(234000, 'L999999.99')
                                FROM DUAL;
         , (COMMA)      데이터 3자리마다 ',' (자리점) 출력
          . (DOT)           소숫점 표현
                
3. TO_DATE(data [,fmt])
    - 날짜 형식의 문자열 date와 숫자 data를 기본 날짜형으로 변환
    - fmt는 date가 기본 날짜형으로 자동 변환될 수 없는 편집된 자료인 경우
      해당 data가 출력(편집)에 사용된 형식 문자열을 기술
    - 날짜 타입 형식 문자열은 TO_CHAR과 동일 

사용 예시)
    SELECT TO_DATE('20200201'),
     --           TO_DATE('20200201 오후 13:23:35'),
    --            TO_DATE('2020년03월19일'),   
                  TO_DATE('2020/02/01'),
                  TO_DATE('2020-02-01'),
                  TO_DATE('2020 02 01')
        FROM DUAL;

    SELECT TO_DATE('20200201 오후 3:11:11', 'YYYYMMDD PM HH:MI:SS'),
                  TO_DATE('2020년03월19일','YYYY"년"MM"월"DD"일"')
        FROM DUAL;

4. TO_NUMBER(data [,fmt])
    - 숫자 형식의 문자열 데이터를 기본 숫자형으로 변환
    - fmt는 date가 기본 숫자형으로 자동 변환될 수 없는 편집된 자료인 경우
      해당 data가 출력(편집)에 사용된 형식 문자열을 기술
    - 숫자 타입 형식 문자열은 TO_CHAR과 동일 

사용 예시)
SELECT TO_NUMBER('230.89'),
               TO_NUMBER('-1234')
     FROM DUAL;
     
SELECT TO_NUMBER('<12,567>','99,999PR'),
              TO_NUMBER('123,567.00', '999,999.99'),
              TO_NUMBER('￦2,300','L9,999')   
     FROM DUAL;
