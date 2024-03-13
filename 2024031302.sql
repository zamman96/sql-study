2024-0313-02) 함수(FUNCTION)
문자열 함수
숫자 함수
날짜 함수
변환 함수
Null처리 함수
집계 함수
순위 함수


1. 문자열 함수

CONCAT (문자열 결합)
LOWER(), UPPER(), INITCAP() (소문자, 대문자, 첫 글자만 변환)
LPAD() (주어진 문자열의 크기만큼 지정된 문자를 채워넣기)
LTRIM(), RTRIM() (왼쪽, 오른쪽의 공백을 제거)
TRIM() (양 옆에 존재하는 무효의 공백을 제거)
SUBSTR() (문자열을 지정된 만큼 자름)
REPLACE() (지정된 문자열을 치환)
INSTR() (지정된 문자가 처음 나온 INDEX값을 반환)

2. 숫자함수

ABS(), SIGN(), POWER(), SQRT() (수학적 함수)
GREATEST(), LEAST() (주어진 데이터의 최대. 최소값을 반환)
ROUND(), TRUNC() (반올림, 올림)
FLOOR(), CEIL() (내림함수, 올림함수 FLOOR은 바닥이니까 7.6 을 7로 CEIL은 천장이니까 8로)
MOD() (나머지 함수)
WIDTH_BUCKET() (주어진 값을 구간으로 나누고 그 구간의 순번을 반환)

3. 날짜함수

SYSDATE, ADD_MONTHS() (시스템시간 반환, 주어진 날짜에 ADD한 만큼 반환)
NEXT_DAT, LAST_DAY (주어진 날짜 이후 가장 빠른 요일을 반환, 가장 마지막날을 반환)
MONTHS_BETWEEN() (두 날짜자료 사이의 달수를 반환)
EXTRACT() (주어진 날짜에서 원하는 부분만 출력)

4. 변환함수

CAST() (일시적으로 타입을 변경)
TO_CHAR() (문자타입으로 변환)
TO_DATE(), (날짜타입으로 변환)
TO_NUMBER() (숫자타입으로 변환)

5. NULL처리 함수

IS NULL, IN NOT NULL (NULL인지 여부 판단)
NVL() (NULL이면 VAL을 반환하고 아니면 자신의 값을 반환)
NVL2() (NULL이면 VAL2을 아니면 VAL1을 반환)
NULLIF() (둘을 비교하여 같으면 NULL 아니면 첫 번째 값 반환)

6. 집계함수

SUM() (변수를 더함)
AVG() (컬럼의 평균을 구함)
COUNT() (행 수를 반환)
MAX, MIN (각각 최대값, 최소값을 반환)
ROLLUP() (다양한 집계를 반환 보통 : 각 그룹의 총액을 계산시 사용)
CUBE() (주어진 컬럼의 조합 경우의 수 반환 특수한 경우가 아니라면 2^n 개 이상 나온다.)

7. 순위 함수
- RANK() 중복 값은 순위가 오르지 않고 개수만 증가
- DENSE_RANK() 중복 값은 순위가 중복되고 다음 값은 정상적으로 증가한다.
- ROW_NUMBER() 중복 값의 상관없이 정상적/순차적인 순위를 반환한다.