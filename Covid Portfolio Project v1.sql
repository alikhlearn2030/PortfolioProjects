
Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations

--order by 3,4

--select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
--where location like '%saudi%'
order by 1,2


--looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
order by 1,2

-- Total Cases vs Population
-- show what percentage of population got Covid
Select location, date,population , total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
order by 1,2

--Looking at Countries with Highset Infection Rate compared to population

Select location, population , max(total_cases)as HighsetInfection,  max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
group by location, population
order by PercentPopulationInfected desc

--showing Countries with Hightset Death Count per Population

Select location, max(CAST(total_deaths as int))as TotalDeathCount,  max((total_deaths/population))*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by location
order by TotalDeathCount desc

--LET'S BREAK DOWN BY CONTINENT
--Showing continents with the highest death count per population

Select continent, max(CAST(total_deaths as int))as TotalDeathCount
--,  max((total_deaths/population))*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS


Select  SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
--group by date
order by 1



Select  date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by date
order by 1

 
--Looking at population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


---USE CTE
WITH PopvsVac ( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
) 

select * , (RollingPeopleVaccinated/population)*100 AS RollinPeopleVac
from PopvsVac

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255) ,
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * , (RollingPeopleVaccinated/population)*100 AS RollinPeopleVac
from #PercentPopulationVaccinated

--Creating View to store data for later visuliztions

create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3