select*
From Project..CovidDeaths


--get the total_cases, new_cases, Total_deaths 

Select location,date,total_cases,new_cases,total_deaths,population
From Project..CovidDeaths
order by 1,2


--get the percentage of deaths of pepople in inda


Select location,date,total_cases,total_deaths,round(((total_deaths/total_cases)*100),2) As Deaths_Percentage
From Project..CovidDeaths
where location like '%india%'
order by 1,2


--get the percentage of covid affected people in india


Select location,date,total_cases,population,round(((total_cases/population)*100),4) As affected_Percentage
From Project..CovidDeaths
where location like '%india%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc



--Heighest Infecton count in india compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
where location like '%india'
Group by Location, Population

-- Countries with Highest Death Count per Population


Select Location, Population, MAX(cast(total_deaths as int)) as DeathCount
From Project..CovidDeaths
where continent is not null
Group by Location, Population
order by DeathCount desc


--Contintents with Highest Death Count per Population

Select continent,population, MAX(cast(total_deaths as int)) as DeathCount
From Project..CovidDeaths
where continent is not null
Group by continent,population
order by DeathCount desc



--golbal numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From Project..CovidDeaths
where continent is not null
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project..CovidDeaths dea
Join Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
