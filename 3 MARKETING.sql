
/* ANÁLISIS DE LA COMERIALIZACIÓN BANCARIA */


SELECT * 
FROM SQL_BOOTPROYECTO..bank$

-- Responderemos las siguientes preguntas

-- 1. ¿Qué profesiones son las más populares entre los clientes mayores de 45 años?

SELECT job, COUNT(job) as NumeroTrabajos
FROM SQL_BOOTPROYECTO..bank$
WHERE age > 45
GROUP BY job
ORDER BY job

-- 2. ¿Para cuántas personas con préstamos tuvo éxito la campaña de marketing?

SELECT loan
FROM SQL_BOOTPROYECTO..bank$
GROUP BY loan

SELECT poutcome
FROM SQL_BOOTPROYECTO..bank$
GROUP BY poutcome


SELECT poutcome, COUNT(poutcome) as NumberSuccess
FROM SQL_BOOTPROYECTO..bank$
WHERE loan = 'yes' AND poutcome = 'success'
GROUP BY poutcome

SELECT poutcome, loan, COUNT(poutcome) as NumberSuccess
FROM SQL_BOOTPROYECTO..bank$
GROUP BY poutcome, loan

-- 3. ¿Profesiones con mayores éxito según el préstamo?

SELECT job, loan, COUNT(job) 
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'success'
GROUP BY job, loan

-- 4. ¿De qué edad son aquellos que tienen más/menos éxito las campañas de marketing?

SELECT age, poutcome, COUNT(poutcome) as SuccessAge
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'success'
GROUP BY age, poutcome
ORDER BY SuccessAge DESC

-- 5. ¿De qué edad fallan más las campañas?

SELECT age, poutcome, COUNT(poutcome) as SuccessAge
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'failure'
GROUP BY age, poutcome
ORDER BY SuccessAge DESC

-- 6. Duración promedio de acuerdo a marital

SELECT marital, AVG(duration) as AvgDuration 
FROM SQL_BOOTPROYECTO..bank$
GROUP BY marital















