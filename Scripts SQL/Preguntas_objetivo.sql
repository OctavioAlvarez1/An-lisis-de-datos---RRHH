-- PREGUNTAS

-- 1. ¿Cómo es la distribución de generos de los empleados en la compañía?

SELECT race, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY race
ORDER BY count(*) DESC;
-- 2. ¿Cómo es la distribución étnica/de raza de los empleados en la compañía? 

SELECT race, COUNT(*) AS count 
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY gender;

-- 3. ¿Cómo es la distribución de la edad de los empleados en la compañía?
SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '';

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group,
    COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group, gender,
    COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4 ¿Cuántos empleados trabajan en la oficina y cuántos de forma remota?
SELECT location, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY location; 

-- 5 ¿Cuánto tiempo trabajaron (en años) en promedio los empleados que ya no están en la empresa?
SELECT 
	ROUND(AVG(datediff(termdate,hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate <> '' AND age>=18 ;


-- 6 ¿Cómo varía la distribución del genero según los departamentos y las funciones de los empleados?
SELECT department, gender, COUNT(*) AS count 
FROM hr 
WHERE age >= 18 AND termdate = ''
GROUP BY department, gender
ORDER BY department;

-- 7 ¿Cómo es la distribución de los cargos en la empresa?
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8 ¿Cuál es el departamento con más tasa de rotación?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    COUNT(*) AS total_count,
	SUM(CASE WHEN termdate <> '' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
	) AS subquery
ORDER BY termination_rate DESC;

-- 9 ¿Cómo es la distribución de los empleados por ciudad y estado?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY location_state
ORDER BY count DESC;

-- 10 ¿Cómo fue variando la cantidad de empleados a lo largo del tiempo?
SELECT 
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100,2) AS net_change_percent
FROM (
	SELECT 
		YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <> '' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
	FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11 ¿Cómo es la distribución por cada departamento?
SELECT department, round(AVG(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate <> '' AND age >= 18
GROUP BY department;