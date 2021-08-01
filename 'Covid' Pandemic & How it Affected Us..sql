
Select *
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Order By 3,4

Select *
From [Portfolio Project]..CovidVaccinations
Where Continent is not null
Order By 3,4

----Accumulation of Data For Evaluation And Analytics Purposes 


Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Order By 1,2

----Looking at Total Cases vs. Total Deaths

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Deaths/Total_Cases)* 100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Order By 1,2


Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Deaths/Total_Cases)* 100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where Location like '%states%'
Where Continent is not null
Order By 1,2

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Deaths/Total_Cases)* 100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where Continent is not null
--Where Location like '%India%'
Order By 1,2


----Looking At Total Cases vs. Population

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Cases/Population)* 100 as PercentPopulationGotInfected
From [Portfolio Project]..CovidDeaths
--Where Location like '%India%'
Order By 1,2

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Cases/Population)* 100 as PercentPopulationGotInfected
From [Portfolio Project]..CovidDeaths
----Where Location like '%India%'
----Where Location like '%states%'
Order By 1,2

---- Looking At Total Deaths vs. Population

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Deaths/Population)* 100 as ActualCasualities
From [Portfolio Project]..CovidDeaths
Where Location like '%States%'
Order By 1,2 


Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population, (Total_Deaths/Population)* 100 as ActualCasualities
From [Portfolio Project]..CovidDeaths
Where Location like '%India%'
Order By 1,2 

----Looking at Countries With Highest Infection Rate Compared to Population, Total_Cases, Total_Deaths


Select Location, MAX(Total_Cases) as HighestInfectedCount, Population, MAX((Total_Cases/Population))* 100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
Group By Location, Population
Order By PercentPopulationInfected desc


----Showing Countries with Highest Death Count per Population

Select Location, MAX(Cast(Total_Deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Group By Location
Order By TotalDeathCount desc


---- Diffrentiating On The Basis Of Continent

Select Continent, MAX(Cast(Total_Deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Group By Continent
Order By TotalDeathCount desc

---More Accurate

Select Location, MAX(Cast(Total_Deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where Continent is null
Group By Location 
Order By TotalDeathCount desc

----Global Numbers

Select Date, SUM(New_Cases) as Total_Cases, SUM(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as GlobalDeathPercentage
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Group By Date
Order By 1,2 

-----

Select SUM(New_Cases) as Total_Cases, SUM(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as GlobalDeathPercentage
From [Portfolio Project]..CovidDeaths
Where Continent is not null
Order By 1,2 


---- Retracting And Joining The Other Table

Select *
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
Order By 1,2


----Looking at Total Population vs. Vaccinations

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
Order By 1,2,3


----Looking at Total Population vs. Vaccinations - 2

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location, Dea.Date) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
Order By 1,2,3

---- Variation 1

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
Order By 2,3

---- ( Cast & CONVERT are same Aggregrate Functions.)

----- Variation 2

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
Order By 2,3

--- Using CTE


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER 
(Partition By Dea.Location, Dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
--Order By 1,2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac

----- Variation 1

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER 
(Partition By Dea.Location Order By Dea.Location) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
--Order By 1,2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac


----- Variations 2

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER 
(Partition By Dea.Location Order By Dea.Location, Dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
--Order By 1,2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac



---- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location, Dea.Date) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
--Where Dea.Continent is not null
--Order By 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


---- Variation

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
--Where Dea.Continent is not null
--Order By 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

---- Variation 2


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
 --Where Dea.Continent is not null
--Order By 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

----Creating View for later Visualization

Create View PercentPopulationVaccinated as
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location, Dea.Date) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
--Order By 1,2,3
-------------------

Create View PercentPopulationVaccinated as
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) as RollingPeoplevaccinated
From [Portfolio Project]..CovidDeaths Dea
Join [Portfolio Project]..CovidVaccinations Vac
On Dea.Location = Vac.Location
and Dea.Date = Vac.Date 
Where Dea.Continent is not null
--Order By 1,2,3


Select *
From PercentPopulationVaccinated







-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


--USE [Portfolio Project] 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


--'Excel 12.0; Database=C:\Users\singh\OneDrive\Documents\SQL Server Management Studio\Covid-deaths.csv',);
--GO