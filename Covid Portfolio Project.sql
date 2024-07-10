select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2


-- looking at Total Cases vs Total Deaths

select location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like 'Philippines'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid
select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like 'Philippines'
order by 1,2




--- looking at countries with highers infection rate comapared to Population

select location,population,MAX(total_cases)as HighestInfectionCount,population,Max((total_cases/population))*100 as InfectedPercentPopulation
from PortfolioProject..CovidDeaths
--Where location like 'Philippines'
group by location,population
order by InfectedPercentPopulation desc


--- Showing Contries with the Highest Death Count per Population

select location,MAX(cast (total_deaths as int))as TotalDeathCount 
from PortfolioProject..CovidDeaths
--Where location like 'Philippines'
where continent is null
group by location
order by TotalDeathCount desc

--By continent

-- Showing the continents with highest death count per population

select continent,MAX(cast (total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like 'Philippines'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

select date,SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

-- world total deaths and percentage

select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2


-- looking at total population vs vaccinated 

Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	order by 2,3

--Using cte

	With PopVSVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	
	)

	Select *, (RollingPeopleVaccinated/population)*100
	From PopVSVac


	--Temp table

	Drop table if exists #PercentPopulationVaccinated 
	Create Table #PercentPopulationVaccinated 
	(
	Continent varchar(55),
	Location nvarchar(55),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)
	Insert into #PercentPopulationVaccinated 
	Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null

	Select *, (RollingPeopleVaccinated/population)*100
	From #PercentPopulationVaccinated 

	--Creating view for data visualization

	Create view PercentPopulationVaccinated as
	Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null

	Create view PercentofPopulationVaccinated as
	Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null

	Select *
	from PercentPopulationVaccinated