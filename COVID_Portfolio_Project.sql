SELECT *
FROM PortfolioProject..CovidDeaths
order by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
WHERE continent is not null
order by 3,4


---Selelct Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2


---Looking at totak Cases vs total Deaths
---Shows liklihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2


---Looking at total Cases vs Population 
---Show what percentage of population got Covid
SELECT Location, date, total_cases, population, (total_cases/population)*100 as percentPopulationInfected
FROM PortfolioProject..CovidDeaths
---WHERE location like '%states%'
order by 1,2



---Looking at Countries with Highest Inferction Rate compare to Population
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as 
 percentPopulationInfected
FROM PortfolioProject..CovidDeaths
---WHERE location like '%states%'
GROUP BY Location, population
order by percentPopulationInfected desc


--- Showing Countries with the heighest death count per population


---Looking at Countries with Highest Inferction Rate compare to Population
SELECT Location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
 From PortfolioProject..CovidDeaths
---WHERE location like '%states%'
WHERE continent is not null
GROUP BY Location
order by TotalDeathCount desc



--- Lets BREAK THINGS DOWN BY CONTINENT


---Looking at Countries with Highest Inferction Rate compare to Population
SELECT continent, MAX(cast(Total_deaths as int)) AS TotalDeathCount
 From PortfolioProject..CovidDeaths
---WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
order by TotalDeathCount desc



----Global Number

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage ---(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
---WHERE location like '%states%'
where continent is not null
--Group by date
order by 1,2


---Looking at total population vs vaccation

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated,
--(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
ORDER BY 2,3


----USE CTE

With PopvsVac(Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
---ORDER BY 2,3
)
SELECT*,(RollingPeopleVaccinated/population)*100
FROM PopvsVac 


---TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
---where dea.continent is not null
---ORDER BY 2,3


SELECT*,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


---Creating View to store data for later visualization

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2,3

select* 
FROM PercentPopulationVaccinated











