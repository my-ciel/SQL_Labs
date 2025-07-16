1. EMPLOYEES 테이블에서 전체사원의 수와 수당(COMMISSION)을 받는 사원의 수를 출력하시오.
SELECT COUNT(*), COUNT(commission_pct)
FROM employees;

2. 사원의 전체이름과 입사일, 입사한 개월 수, 입사 3개월 후의 날짜, 입사 후 첫 금요일, 입사한 달의 말일을 출력하시오. 전체이름은 이름과 성 사이에 구분을 위해 공백을 추가하고, 입사한 개월 수는 반올림을 적용하여 정수로 출력하시오.
SELECT first_name||' '||last_name AS 사원이름, ROUND(MONTHS_BETWEEN(sysdate, hire_date)) 근무기간,
       ADD_MONTHS(hire_date, 3), NEXT_DAY(hire_date, '금요일'), LAST_DAY(hire_date)
FROM employees;

3. 사원테이블에서 부서번호가 NULL이 아닌 사원들을 대상으로 부서번호 별 최대급여를 출력하시오.
SELECT department_id, MAX(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;

4. 1800번 위치에 근무하는 사원의 부서 이름, 위치, 이름, 업무 및 급여를 표시하시오.
SELECT d.department_name, d.location_id, e.last_name, e.job_id, e.salary
FROM   employees e  JOIN departments d
ON   (e.department_id = d.department_id)
AND     d.location_id = 1800;

5. Administration 및 Executive 부서에는 어떤 업무(JOB_ID)가 있으며 해당 업무를 맡고 있는 사원 수는 몇 명입니까? 인원이 가장 많은 업무부터 표시하시오.
SELECT e.job_id, count(e.job_id) FREQUENCY
FROM	   employees e JOIN departments d
USING (department_id)
WHERE    d.department_name IN ('Administration', 'Executive')
GROUP BY e.job_id
ORDER BY FREQUENCY DESC;

6. 평균 급여가 가장 높은 부서의 부서 번호 및 해당 부서의 최저 급여를 표시하시오.
SELECT department_id, MIN(salary)
FROM   employees
GROUP BY department_id
HAVING AVG(salary) = (SELECT MAX(AVG(salary))
                      FROM   employees
                      GROUP BY department_id);

7. 영업 사원(JOB_ID가 SA_REP)이 없는 부서의 부서 번호, 이름 및 위치를 표시하시오.
     SELECT *
     FROM   departments
     WHERE  department_id NOT IN (SELECT department_id
                                    FROM employees
                                     WHERE job_id = 'SA_REP'
                                     AND department_id IS NOT NULL);
8. 다음과 같은 부서의 부서 번호, 부서 이름 및 사원 수를 표시하시오.
(1) 사원이 3명 미만인 부서
     SELECT d.department_id, d.department_name, COUNT(*)
     FROM   departments d JOIN employees e
     ON  (d.department_id = e.department_id)
     GROUP BY d.department_id, d.department_name
     HAVING COUNT(*) < 3;
(2) 사원 수가 가장 많은 부서
      SELECT d.department_id, d.department_name, COUNT(*)
      FROM   departments d JOIN employees e
      ON (d.department_id = e.department_id)
      GROUP BY d.department_id, d.department_name
      HAVING COUNT(*) = (SELECT MAX(COUNT(*))
	                  FROM   employees
	                  GROUP BY department_id);

9. 모든 사원의 사원 번호, 이름, 급여, 부서 번호 및 소속 부서의 평균 급여를 표시하시오.
SELECT e.employee_id, e.last_name, e.department_id, AVG(s.salary)
FROM   employees e JOIN employees s
ON e.department_id = s.department_id
GROUP BY e.employee_id, e.last_name, e.department_id;

10. 다음과 같은 그룹화에 대하여 각 그룹의 최고 및 최저 급여를 표시하는 질의를 작성하시오. 
	부서 ID, 업무 ID
	업무 ID, 관리자 ID
      SELECT department_id, job_id, manager_id,max(salary),min(salary)
      FROM   employees
      GROUP BY GROUPING SETS
      ((department_id,job_id), (job_id,manager_id));

11. EMPLOYEES 테이블에서 가장 많은 급여를 받는 세 명의 사원에 대해 이름과 급여를 표시하는 질의를 작성하시오.
SELECT last_name, salary
FROM   employees e
WHERE  3  > (SELECT COUNT(*)
               FROM   employees
              WHERE  e.salary < salary);

12. California 주에서 근무하는 사원의 사원 ID와 이름을 표시하는 질의를 작성하시오. 
SELECT employee_id, last_name
FROM employees e
WHERE ((SELECT location_id
        FROM departments d
        WHERE e.department_id = d.department_id ) IN   (SELECT location_id
FROM locations l
                                                        WHERE STATE_province = 'California'));

13. 해당 업무의 최고 급여가 회사 전체의 업무별 최고 급여 중에서 상위 50% 안에 드는 업무ID를 표시하는 질의를 작성하시오. WITH 절을 사용하여 작성하고 쿼리블록 이름은 MAX_SAL_CALC로 지정하시오.
       WITH 
       MAX_SAL_CALC AS (
       SELECT job_title, MAX(salary) AS job_total
       FROM employees JOIN jobs
       ON (employees.job_id = jobs.job_id)
       GROUP BY job_title)
       SELECT job_title, job_total
       FROM MAX_SAL_CALC
       WHERE job_total > (SELECT MAX(job_total) * 1/2
                          FROM MAX_SAL_CALC)
       ORDER BY job_total DESC; 
