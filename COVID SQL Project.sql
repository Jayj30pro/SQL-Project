-- Covid deaths by continent and country

SELECT * FROM 
PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4;

-- Covid vaccinations by continent and country

SELECT * FROM 
PortfolioProject.dbo.CovidVaccinations
WHERE continent is not null
ORDER BY 3,4;



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2;


-- Looking at total cases vs total deaths
-- Chances of death from COVID by country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2;

-- Total cases vs total deaths for the United States
-- Chances of death from COVID in the United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%states%'
WHERE continent is not null
ORDER BY 1,2;


--Total cases vs population
--The percentage of the World population that got COVID

SELECT location, date, population, total_cases, (total_cases/ population) * 100 as InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2;

--Total cases vs population
--The percentage of the U.S. population that got COVID

SELECT location, date, population, total_cases, (total_cases/ population) * 100 as InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%states%'
WHERE continent is not null
ORDER BY 2;



--Countries with High Infection rates compared to population

SELECT location, population, MAX(total_cases) as MaxInfection, (MAX(total_cases)/ population) * 100 as InfectionPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectionPercentage DESC;


--Countries with highest death count per population.

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Large groups by continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC;



-- Showing continents with highest death rates 

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;



-- Global numbers

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))* 100 / SUM(new_cases) as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;


-- All cases in the world

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))* 100 / SUM(new_cases) as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2;


-- All data

SELECT * FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidDeaths vac
	ON dea.location = vac.location
	and dea.date = vac.date

-- Total population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;


SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;


--TEMP TABLE

DROP TABLE IF EXISTS #VaxStats
CREATE TABLE #VaxStats

(Country nvarchar(255),
date datetime,
population numeric,
Deaths numeric
)

Insert into #VaxStats
SELECT location ,date,population, new_deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null;
SELECT * FROM #VaxStats


-- Saving data for later in a view

CREATE VIEW USDeathRsates AS 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathRate
FROM PortfolioProject.dbo.CovidDeaths dea
WHERE dea.location Like '%states%'

SELECT * FROM USDeathRsates





