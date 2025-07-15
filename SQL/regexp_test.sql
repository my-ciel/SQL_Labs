--다음 예제는 'Steven' 또는 'Stephen' 의 문자열을 검색 합니다.

SELECT first_name, last_name 
FROM employees
WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$') ;

--다음 예제는 형식이 XX.XXXX.XXXXXX의 패턴으로 저장된 전화번호를 검색합니다.

SELECT first_name, phone_number
FROM employees
WHERE REGEXP_LIKE (phone_number, '..\.....\.......') ;

--다음과 같이 각각의 자리마다 숫자가 반복 되는 회수를 지정할 수 있으며 원하는 문자열이 포함 된 것을 찾을 수 있습니다.
SELECT first_name, phone_number
FROM employees
WHERE REGEXP_LIKE (phone_number, '[0-9]{2}\.[0-9]{4}\.[0-9]{6}'); 
SELECT first_name, phone_number
FROM employees 
WHERE REGEXP_LIKE (phone_number, '\d{2}\.\d{4}\.\d{6}'); 

--다음 예제는 3 자리로 표현 되는 전화 번호를 검색하여  3개의 그룹 문자를 표현하며 1번 그룹은 ( ) 로 감싸고 구분자는 "-" 사용하는 예제입니다.
SELECT first_name, phone_number, 
       REGEXP_REPLACE (phone_number, '(\d{2})\.(\d{4})\.(\d{6})','(\1)-\2-\3')   
       AS new_phone 
FROM employees ; 

--지정된 Class 가 알파벳이므로  주소에서 첫 번째 알파벳 문자의 위치를 검색 합니다.

SELECT location_id, city,
       street_address, REGEXP_INSTR (street_address, '[[:alpha:]]' ) addr , 
       postal_code, REGEXP_INSTR (postal_code, '[[:alpha:]]') pos 
FROM locations ;

--다음 예제는 정규식을 사용하여 주소에서 두 번째 문자열인 (Road)을 추출합니다.
SELECT location_id, street_address, 
       REGEXP_SUBSTR (street_address, ' [^ ]+ ') road 
FROM locations;

--다음 예제는 지역번호를 뺀 국번만 추출합니다. 양쪽 끝의 '.' 문자를 없애기 위해 REPLACE 함수를 함께 사용합니다.

SELECT first_name, phone_number, 
       REPLACE(REGEXP_SUBSTR(phone_number,'\.(\d{3})\.'),'.') code 
FROM employees ; 

--다음 예제는 이름에서 ＇a＇ 가 발견 된 횟수를 검색 합니다.

SELECT employee_id, first_name,
       REGEXP_COUNT(first_name,'a') cnt 
FROM employees ; 

--다음은 특정 DNA 시퀀싱에서 'gtc'가 나오는 나오는 횟수를 반환합니다. 
SELECT 
   REGEXP_COUNT('ccacctttccctccactcctcacgttctcacctgtaaagcgtccctc
   cctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagc
   tccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcc
   tgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttca
   ccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagag
   gctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggc
   atgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggc
   taccccagagcacttagagccag', 
	'gtc') "Count"
FROM dual;

-- REGEXP_SUBSTR은 서브표현식 문자열의 해당 되는 부분을 추출할 수 있습니다. 다음을 실행하여 각 하위식을 식별할 수 있습니다.
SELECT REGEXP_SUBSTR ('0123456789', 
		'(123)(4(56)(78))', 1, 1, 'i', 1 ) "Exp1" , 
	 REGEXP_SUBSTR ('0123456789', 
		'(123)(4(56)(78))', 1, 1, 'i', 2 ) "Exp2" , 
	 REGEXP_SUBSTR ('0123456789', 
		'(123)(4(56)(78))', 1, 1, 'i', 3 ) "Exp3" , 
	 REGEXP_SUBSTR ('0123456789', 
		'(123)(4(56)(78))', 1, 1, 'i', 4 ) "Exp4"
FROM dual;

--예제는 12345678 의 문자 패턴을 비교하면서 두 번째 하위식을 검색하며 45678 의 문자열이 시작되는 위치를 반환합니다.
SELECT REGEXP_INSTR ('0123456789','(123)(4(56)(78))', 1, 1, 0, 'i', 2 )          
       AS "Position" 
FROM dual; 

--DNA에서 특정 하위 패턴을 찾으려고 합니다. 예제에서는 첫번째 하위식 (gtc)의 위치가 반환됩니다.
SELECT 
   REGEXP_INSTR('ccacctttccctccactcctcacgttctcacctgtaaagcgtccctc
   cctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagc
   tccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcc
   tgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttca
   ccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagag
   gctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggc
   atgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggc
   taccccagagcacttagagccag', 
	'(gtc(tcac)(aaag))', 
	1, 1, 0, 'i', 
	1) "Position"
FROM dual;











