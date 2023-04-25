
/* PROYECTO DE EXPLORACIÓN DE DATOS */


-- Vistazo general de los datos
SELECT *
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM SQL_BOOTPROYECTO..CovidVaccinations1$
WHERE continent is not null
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
ORDER BY 1,2

-- Total de casos vs Total de muertes
------ Cálculo de Tasa de muertes vs Casos en EUA
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE location like '%states%'
AND continent is not null
ORDER BY 1,2

------- Casos totales VS Población
SELECT location, date, population, total_cases, (total_cases/population)*100 as Casespercent
FROM SQL_BOOTPROYECTO..CovidDeaths1$
ORDER BY 1,2

------- Países con mayor tasa de infección
SELECT location, population, MAX(total_cases) as HighestINfectionCount, MAX((total_cases/population)*100) as MaxCasesPercentage
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
GROUP BY location, population
ORDER BY MaxCasesPercentage DESC

------- Países con mayores muertes 
SELECT location, MAX(CAST(total_deaths as int)) as HighestDeaths
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
GROUP BY location
ORDER BY HighestDeaths DESC
---------Nota: como total_deaths la interpreta como un varchar, entonces la 
---------convertiremos a entero por medio de cast

------- Ahora por continente
SELECT continent, MAX(CAST(total_deaths as int)) as HighestDeaths
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeaths DESC
---------- Verá que las cifras de North América solo contiene a EUA falta Canada
SELECT location, MAX(CAST(total_deaths as int)) as HighestDeaths
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is null
GROUP BY location
ORDER BY HighestDeaths DESC

------- Muertes globales Nuevas (Nuevas muertes/Nuevos casos)
---------Diarías
SELECT date,SUM(new_cases) as NewCases, SUM(CAST(new_deaths as int)) as NewDeaths, (SUM(CAST(new_deaths as int)) / SUM(new_cases))*100 as GlobalDeaths
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2
---------Totales
SELECT SUM(new_cases) as NewCases, SUM(CAST(new_deaths as int)) as NewDeaths, (SUM(CAST(new_deaths as int)) / SUM(new_cases))*100 as GlobalDeaths
FROM SQL_BOOTPROYECTO..CovidDeaths1$
WHERE continent is not null
ORDER BY 1,2

-- Unión de base de datos
SELECT *
FROM SQL_BOOTPROYECTO..CovidDeaths1$ dea
JOIN SQL_BOOTPROYECTO..CovidVaccinations1$ vac
    ON dea.location = vac.location

-- Vacunas VS Población
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location) AS SumNewVac
FROM SQL_BOOTPROYECTO..CovidDeaths1$ AS dea
JOIN SQL_BOOTPROYECTO..CovidVaccinations1$ AS vac
    ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3
------Para convertir con CAST tambien puede ponerlo con CONVERT así:
------Note que OVER partition y order by lo que hacen esto junto es 
------sumar por cada location para cada fecha, es decir lo acumulan 
------a diario, si quita el order by entonces la suma solo será para
------cada location en el periodo total.
-- Vacunas VS Población
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as SumNewVac
, (SumNewVac/population)*100
FROM SQL_BOOTPROYECTO..CovidDeaths1$ dea
JOIN SQL_BOOTPROYECTO..CovidVaccinations1$ vac
    ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3
-- Usando un CTE para arreglar el error en SumNewVac
-- es decir una tabla temporal

WITH PopvsVac (Continent, location, date, population, new_vaccinations, SumNewVac)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as SumNewVac
--, (SumNewVac/population)*100
FROM SQL_BOOTPROYECTO..CovidDeaths1$ dea
JOIN SQL_BOOTPROYECTO..CovidVaccinations1$ vac
    ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (SumNewVac/population)*100
FROM PopvsVac



-- Creamos de nuevo la tabla desde cero (introduciendo un DROP)
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
SumVacNew numeric
)

INSERT INTO  #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
   dea.date) AS SumNewVac
FROM SQL_BOOTPROYECTO..CovidDeaths$ AS dea
JOIN SQL_BOOTPROYECTO..CovidVaccinations$ AS vac
    ON  dea.location = vac.location
	AND dea.date = vac.date

SELECT *, (SumVacNew/population)*100 AS PercentVaccinated
FROM #PercentPopulationVaccinated











