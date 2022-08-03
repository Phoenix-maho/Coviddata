select *
from coviddata..CovidDeaths
order by 3,4
--select *
--from coviddata..CovidVaccinations
--order by 3,4

--select data to be used

select location, date, total_cases, new_cases, total_deaths, population
from coviddata..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths in Nigeria
--Shows chance of dying from Covid in Nigeria

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from coviddata..CovidDeaths
where location like 'Nigeria'
order by 1,2

--Looking at Total Cases vs Population

select location, date, total_cases, population, (total_cases/population)*100 AS Incidence
from coviddata..CovidDeaths
--where location like 'Nigeria'
order by 1,2

--Countries with Highest Incidence
select location, population, MAX(total_cases) AS max_cases, MAX((total_cases/population))*100 AS MaxIncidence
from coviddata..CovidDeaths
--where location like 'Nigeria'
group by location, population
order by 4 DESC

--Showing Countries with Highest DeathCount 
select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
from coviddata..CovidDeaths
--where location like 'Nigeria'
where continent is not null
group by location
order by TotalDeathCount DESC


--Showing DeathCount in a broader sense
select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
from coviddata..CovidDeaths
--where location like 'Nigeria'
where continent is null
group by location
order by TotalDeathCount DESC

--*****

select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
from coviddata..CovidDeaths
--where location like 'Nigeria'
where continent is not null
group by continent
order by TotalDeathCount DESC

--GLOBAL NUMBERS
select SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercent
from coviddata..CovidDeaths
where continent is not null
--group by date
--order by date;


--Looking at Total Population vs Vaccination
--Create CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccd)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations 
, sum(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as rollingVaccd
from coviddata..CovidDeaths AS d
join coviddata..CovidVaccinations AS v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
--and v.new_vaccinations is not null
--order by 2,3
)
select *, (RollingVaccd/Population)*100 AS VaccdPercent
from PopvsVac
order by 2,3


--Creating Views for Visualization
create view PopvsVacd as
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccd)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations 
, sum(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as rollingVaccd
from coviddata..CovidDeaths AS d
join coviddata..CovidVaccinations AS v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
--and v.new_vaccinations is not null
--order by 2,3
)
select *, (RollingVaccd/Population)*100 AS VaccdPercent
from PopvsVac
--order by 2,3

select *
from PopvsVacd