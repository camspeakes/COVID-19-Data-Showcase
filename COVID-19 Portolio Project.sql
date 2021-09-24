/* COVID-19 Data Showcase */

/* SQL Queries Used for Tableau Visualizations*/
/* OWID COVID Database Included in Repository */


SELECT *
FROM [OWID COVID-19]..COVID
ORDER BY 3,4

--Total Cases vs Total Deaths and the Rate of Death in the US

SELECT location, date, new_cases, icu_patients, new_deaths, (total_deaths/total_cases)*100 as death_rate
FROM [OWID COVID-19]..COVID
WHERE location like '%states%'


--Total Cases as a percentage of Population in the US

SELECT location, date, total_cases, population, (total_cases/population)*100 as pop_infection_rate
FROM [OWID COVID-19]..COVID
WHERE location like '%states%'
ORDER BY 1, 2


--Ranking Countries by Population Infection Rate

SELECT location, MAX(total_cases) as latest_case, population, MAX((total_cases/population))*100 as pop_infection_rate
FROM [OWID COVID-19]..COVID
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY pop_infection_rate DESC


--Ranking Countries by Death Count

SELECT location, MAX(CAST(total_deaths AS INT)) AS latest_death
FROM [OWID COVID-19]..COVID
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY latest_death DESC


--Ranking Continents by Death Count

SELECT location, MAX(CAST(total_deaths AS INT)) AS latest_death
FROM [OWID COVID-19]..COVID
WHERE continent IS NULL
GROUP BY location
ORDER BY latest_death DESC


-- World Timeline For Infections

SELECT date, SUM(CAST(new_deaths AS INT)) AS world_deaths, 
	SUM(new_cases) AS world_cases, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 
	AS world_rate
FROM [OWID COVID-19]..COVID
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY world_cases


--Latest Population Vaccination Rates by Country

SELECT location, MAX(population) AS pop, MAX(CAST(people_vaccinated AS INT)) AS first_shot, MAX(CAST(people_fully_vaccinated AS INT)) fully_vax,
	MAX(CAST(people_vaccinated AS INT))/population*100 AS first_shot_rate,
	MAX(CAST(people_fully_vaccinated AS INT))/population*100 AS fully_vax_rate
FROM [OWID COVID-19]..COVID
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY location


--Rolling Count of Vaccinations by Country Using CTE and truncated dataset for size constraints


ALTER TABLE [COVID-SHORT]..COVID  ALTER COLUMN date  nvarchar(150);


WITH pop2vac (location, date, population, people_fully_vaccinated, rolling_vax)
AS
(
	SELECT location, date, population, people_fully_vaccinated,
	FROM [OWID COVID-19]..COVID
	WHERE continent IS NOT NULL
)

SELECT *, ROUND((people_fully_vaccinated/population)*100, 2) AS rolling_rate
FROM pop2vac

