
/* AN�LISIS DE LA COMERIALIZACI�N BANCARIA */


SELECT * 
FROM SQL_BOOTPROYECTO..bank$

-- Responderemos las siguientes preguntas

-- 1. �Qu� profesiones son las m�s populares entre los clientes mayores de 45 a�os?

SELECT job, COUNT(job) as NumeroTrabajos
FROM SQL_BOOTPROYECTO..bank$
WHERE age > 45
GROUP BY job
ORDER BY job

-- 2. �Para cu�ntas personas con pr�stamos tuvo �xito la campa�a de marketing?

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

-- 3. �Profesiones con mayores �xito seg�n el pr�stamo?

SELECT job, loan, COUNT(job) 
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'success'
GROUP BY job, loan

-- 4. �De qu� edad son aquellos que tienen m�s/menos �xito las campa�as de marketing?

SELECT age, poutcome, COUNT(poutcome) as SuccessAge
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'success'
GROUP BY age, poutcome
ORDER BY SuccessAge DESC

-- 5. �De qu� edad fallan m�s las campa�as?

SELECT age, poutcome, COUNT(poutcome) as SuccessAge
FROM SQL_BOOTPROYECTO..bank$
WHERE poutcome = 'failure'
GROUP BY age, poutcome
ORDER BY SuccessAge DESC

-- 6. Duraci�n promedio de acuerdo a marital

SELECT marital, AVG(duration) as AvgDuration 
FROM SQL_BOOTPROYECTO..bank$
GROUP BY marital















