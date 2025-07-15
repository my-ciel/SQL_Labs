-- 데이터베이스의 현재 날짜와 시간을 DATE 또는 TIMESTAMP WITH TIME ZONE 데이터 유형으로 반환합니다.

SELECT sysdate, systimestamp 
FROM dual;

--사용자 세션의 날짜와 시간을 DATE, TIMESTAMP WITH TIME ZONE, TIMESTAMP 유형으로 각각 반환합니다.

SELECT CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP   
FROM DUAL;

--다음 예제는 세션의 시간대를 이동해가며 DBTIMEZONE과 SESSIONTIMEZONE의 값을 비교합니다.
--세션의 시간대를 이동해도 데이터베이스 시간대인 DBTIMEZONE SYSTIMESTAMP값은 변경되지 않습니다.

ALTER SESSION SET time_zone = '-7:00';
SELECT dbtimezone, sessiontimezone FROM dual;
SELECT systimestamp, current_timestamp FROM dual;

ALTER SESSION SET time_zone = '+9:00';
SELECT dbtimezone, sessiontimezone FROM dual;
SELECT systimestamp, current_timestamp FROM dual;

--DATETIME 데이터유형 관련 SQL 함수 
--다음은  여러 지역에 대한 시간대 오프셋을 표시합니다.
SELECT TZ_OFFSET('US/Eastern'), TZ_OFFSET('Canada/Yukon'), TZ_OFFSET('Europe/London')
FROM DUAL;

--EMPLOYEES 테이블을 복사하여 EMP60 테이블을 생성한 후 hire_date열의 데이터타입을 TIMESTAMP 타입으로 변경합니다. 

CREATE TABLE emp60
AS
SELECT * FROM employees;

ALTER TABLE emp60
MODIFY hire_date TIMESTAMP(0);

SELECT * FROM emp60;

--다음은  TIMESTAMP 타입인 EMP60 테이블의 HIRE_DATE열을 TIMESTAMP WITH TIME ZONE 타입으로 출력합니다.

SELECT employee_id, last_name, job_id,
       FROM_TZ(hire_date, '+09:00') AS hire_date
FROM emp60; 

--문자열을 TIMESTAMP 값으로 사용하여 지정된 날짜를 검색할 수 있습니다.

SELECT *
FROM emp60
WHERE hire_date >= TO_TIMESTAMP('2010/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS');

--EMP60 테이블에서 각 사원의 입사일로부터 10년 6개월 후의 날짜를 출력합니다.

SELECT employee_id, last_name, hire_date,
       hire_date+TO_YMINTERVAL('10-6')
FROM emp60;

--현재 시각으로부터 3일 12시간 30분 후의 날짜와 시간을 출력합니다. 

SELECT TO_CHAR(sysdate, 'yyyy/mm/dd hh24:mi:ss'),
       TO_CHAR(sysdate+TO_DSINTERVAL('3 12:30:00'), 'yyyy/mm/dd hh24:mi:ss')
FROM dual;




