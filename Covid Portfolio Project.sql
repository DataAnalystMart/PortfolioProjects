Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Order by 1,2


-- Total Cases vs Total Deaths

Select location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Philippines'
Order by 1,2

-- Percentage of population got covid
Select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Philippines'
Order by 1,2



--- Countries with highers infection rate comapared to Population

Select location,population,MAX(total_cases)as HighestInfectionCount,population,Max((total_cases/population))*100 as InfectedPercentPopulation
From PortfolioProject..CovidDeaths
--Where location like 'Philippines'
Group by location,population
Order by InfectedPercentPopulation desc


--- Showing Contries with the Highest Death Count per Population

Select location,MAX(cast (total_deaths as int))as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where location like 'Philippines'
Where continent is null
Group by location
Order by TotalDeathCount desc

--By continent

-- Showing the continents with highest death count per population

Select continent,MAX(cast (total_deaths as int))as TotalDeathCount
From PortfolioProject..CovidDeaths
	
--Where location like ex: 'Philippines'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- Global Numbers

Select date,SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

-- world total deaths and percentage

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Order by 1,2


-- Total population vs vaccinated 

Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	Order by 2,3

--Using CTE

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
