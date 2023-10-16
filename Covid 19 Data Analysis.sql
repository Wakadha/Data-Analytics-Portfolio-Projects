Select *
From PortfolioProject ..CovidDeaths
where continent is not null
order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject ..CovidDeaths
where continent is not null
order by 1,2


--Looking  the total cases vs total deaths 
--Shows the likelyhood of dieing if you contract covid in your country

Select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100  as DeathPercentage
From PortfolioProject ..CovidDeaths
where continent is not null
order by 1,2


--Looking at total cases vs the Population
--Shows the percentage of population got covid

Select location, date,population, total_cases,  (cast(total_cases as int) / population)*100 as ContractualPercentage
From PortfolioProject ..CovidDeaths
where continent is not null
order by 1,2


--Looking at the Countries with highest infection rate compared to the population

Select location, population,Max(cast(total_cases as int)) as HighestInfectionCount,(Max(cast(total_cases as int)) / population)*100 as  HighestInfectionRateVSPopulation
From PortfolioProject ..CovidDeaths
where continent is not null
group by location ,population
order by HighestInfectionRateVSPopulation desc

--Showing the Country with the hihgest death count by population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
where continent is not null
group by location ,population
order by TotalDeathCount desc

--Showing the Continent with the hihgest death count by population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



--GLOBAL NUMBERS

Select sum(new_cases) as Total_cases,sum(cast(new_deaths as int)) as Total_deaths ,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
From PortfolioProject ..CovidDeaths
where continent is not null
order by 1,2


--Looking at total population vs vaccination

Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USE CTE

with PopvsVac (Continent, Location,Date,Population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

Select*, (RollingPeopleVaccinated/population)*100
From PopvsVac 

--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population int,
New_vaccinations int,
RollingPeopleVaccinated int
)
 
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location= vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

Select*, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated
