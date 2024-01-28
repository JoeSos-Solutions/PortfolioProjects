--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	total_deaths float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	total_cases float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	total_cases_per_million float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	total_deaths_per_million float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	reproduction_rate float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	icu_patients int;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	icu_patients_per_million float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	hosp_patients int;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	hosp_patients_per_million float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	weekly_icu_admissions int;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	weekly_icu_admissions_per_million float;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	weekly_hosp_admissions int;

--ALTER TABLE covidDeaths$
--ALTER COLUMN 
--	weekly_hosp_admissions_per_million float;


SELECT TOP(5) * FROM covidDeaths$;

SELECT TOP(5) * FROM covidVaccinations$;


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covidDeaths$
ORDER BY 1,2;

--Looking at Total Cases vs Total Deaths
--Infection-Death ration

SELECT Location, date,  total_cases, total_deaths, CAST((total_deaths/total_cases)*100 AS DECIMAL(4,2)) AS "Infection/Death ratio"
FROM covidDeaths$
WHERE (total_deaths IS NOT NULL OR total_cases IS NOT NULL) AND location LIKE 'venezuela'
ORDER BY 1,2

--Cases per Population
SELECT Location, date, population, total_cases, CAST((total_cases/population)*100 AS DECIMAL(4,2)) AS "Infection/Population ratio"
FROM covidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2

--Countries with highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) as 'highest infection count', MAX((total_cases/population))*100 AS 'infected population ratio'
FROM covidDeaths$
GROUP BY population, location
ORDER BY 4 DESC

--Showing  Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS 'Death Count'
FROM covidDeaths$
--WHERE location NOT IN('World', 'High Income','Upper middle income','Lower middle income', 'European Union', 'Europe', 'North America', 'Asia', 'South America')
WHERE continent IS NOT NULL --This is much more efficient and user friendly than the above snippet.
GROUP BY location
ORDER BY 'Death Count' DESC

--LET'S BREAK THINGS DOWN BY CONTINENT

--Deaths by region
SELECT location, MAX(total_deaths) AS 'Death Count'
FROM covidDeaths$
WHERE continent IS NULL AND location not like '%income'
GROUP BY location
ORDER BY 'Death Count'  DESC


-- LOOKING AT GLOBAL NUMBERS

SELECT /*date,*/ SUM(new_cases) AS Glb_newCases, SUM(new_deaths) AS Glb_newDeaths, (SUM(new_deaths)/SUM(new_cases))*100 AS 'Global Death ratio'
FROM covidDeaths$
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--         WORKING WITH THE VACCINATIONS DATA

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_tests] int;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[total_tests_per_thousand] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_tests_per_thousand] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_tests_smoothed] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_tests_smoothed_per_thousand] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[positive_rate] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[tests_per_case] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[total_vaccinations] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[people_vaccinated] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[people_fully_vaccinated] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[total_boosters] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_vaccinations] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_vaccinations_smoothed] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[total_vaccinations_per_hundred] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[people_vaccinated_per_hundred] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[people_fully_vaccinated_per_hundred] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[total_boosters_per_hundred] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_vaccinations_smoothed_per_million] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_people_vaccinated_smoothed] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[new_people_vaccinated_smoothed_per_hundred] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[extreme_poverty] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[excess_mortality_cumulative_absolute] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[male_smokers] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 
--	[female_smokers] float;
	

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 	
--	[excess_mortality_cumulative] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 	
--	[excess_mortality] float;

--ALTER TABLE PortfolioProject..covidVaccinations$
--ALTER COLUMN 	
--	[excess_mortality_cumulative_per_million] float;

-- JOINING THE TWO DATASETS

--Looking at total population vaccinations
SELECT cD.continent, cD.location, cD.date, cD. population, cV.new_vaccinations
FROM covidDeaths$ cD
JOIN covidVaccinations$ cV
	ON cD.date = cV.date AND cD.location = cV.location
WHERE cD.continent is not null
ORDER BY 1, 2, 3

--rolling count of new vaccinations
SELECT cD.continent, cD.location, cD.date, cD. population, cV.new_vaccinations, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS Rolling_Vaccinations
FROM covidDeaths$ cD
JOIN covidVaccinations$ cV
	ON cD.date = cV.date 
	AND cD.location = cV.location
WHERE cD.continent is not null
ORDER BY 1, 2, 3


--Using a CTE to calculate a rolling percentage of population vaccination

With PopVsVac (continent, location, date, population, new_vaccinations, Rolling_Vaccinations)
AS (
	SELECT cD.continent, cD.location, cD.date, cD. population, cV.new_vaccinations, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS Rolling_Vaccinations
	FROM covidDeaths$ cD
	JOIN covidVaccinations$ cV
		ON cD.date = cV.date 
		AND cD.location = cV.location
	WHERE cD.continent is not null
	--ORDER BY 2, 3
	)
	SELECT *, CAST((Rolling_Vaccinations/population)*100 AS decimal(5,2)) AS 'Vaccinated_Pop_%'
	FROM PopVsVac
	ORDER BY 1,2,3



-- TEMP TABLE
DROP TABLE IF EXISTS #VaccinatedPopulation
CREATE TABLE #VaccinatedPopulation
	(
		Continent nvarchar(255),
		Location nvarchar(255),
		Date datetime,
		Population numeric,
		New_vaccinations numeric,
		RollingVaccinatedPopulation numeric
	)

INSERT INTO #VaccinatedPopulation
SELECT cD.continent, cD.location, cD.date, cD. population, cV.new_vaccinations, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS RollingVaccinatedPopulation 
	FROM covidDeaths$ cD
	JOIN covidVaccinations$ cV
		ON cD.date = cV.date 
		AND cD.location = cV.location
	WHERE cD.continent is not null
	--ORDER BY 2, 3

	SELECT *, CAST((RollingVaccinatedPopulation /population)*100 AS decimal(5,2)) AS 'Vaccinated_Pop_%'
	FROM #VaccinatedPopulation
	ORDER BY 1,2,3

--CREATING A VIEW FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated AS
SELECT cD.continent, cD.location, cD.date, cD. population, cV.new_vaccinations, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS Rolling_Vaccinations
	FROM covidDeaths$ cD
	JOIN covidVaccinations$ cV
		ON cD.date = cV.date 
		AND cD.location = cV.location
	WHERE cD.continent is not null
	--ORDER BY 2, 3
