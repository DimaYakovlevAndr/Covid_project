--select * from PortfolioCovid.dbo.Deaths
--order by 3,4

--select * from PortfolioCovid.dbo.Vaccinations
--order by 3,4

-- ��������� ����������
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as mortality
from PortfolioCovid.dbo.Deaths
order by 1,2

-- ��������� ���������� 
Select Location, date, Population, total_cases,  (total_cases/population)*100 as contagiousness
From PortfolioCovid.dbo.Deaths
order by 1,2


-- ��������� ������ � ���������� ���-��� ��������� 
select location, population, MAX (total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as contagiousness
from PortfolioCovid.dbo.Deaths 
Group by Location, Population
order by contagiousness desc

-- ��������� ������ � ����� ������� �����������
select location, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioCovid.dbo.Deaths 
Where continent is not null 
Group by Location
order by TotalDeaths desc

-- ��������� ���������� � ����� ������� �����������
select location, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioCovid.dbo.Deaths 
Where continent is null 
Group by location
order by TotalDeaths desc

-- ����� �����
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioCovid.dbo.Deaths 
where continent is not null 
order by 1,2

-- ������� ���������, ���������� ���� �� ���� ���� ������� 
-- ������� ������� RollingPeopleVaccinated, � ������� ����������� ���-�� ���������������
select death.continent, death.location,  death.date, death.population, vacs.new_vaccinations
, SUM(CONVERT(int,vacs.new_vaccinations)) OVER (Partition by death.Location order by death.Date) as RollingPeopleVaccinated
from PortfolioCovid.dbo.Deaths death
Join PortfolioCovid.dbo.Vaccinations vacs
	on death.location = vacs.location
	and death.date = vacs.date
where death.continent is not null
order by 1,2

--��������� �������
With VaccinatedPercentage (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select death.continent, death.location,  death.date, death.population, vacs.new_vaccinations
, SUM(CONVERT(int,vacs.new_vaccinations)) OVER (Partition by death.Location order by death.Date) as RollingPeopleVaccinated
from PortfolioCovid.dbo.Deaths death
Join PortfolioCovid.dbo.Vaccinations vacs
	on death.location = vacs.location
	and death.date = vacs.date
where death.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From VaccinatedPercentage

-- ������� ������� �� ���������������

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select death.continent, death.location,  death.date, death.population, vacs.new_vaccinations
, SUM(CONVERT(float,vacs.new_vaccinations)) OVER (Partition by death.Location order by death.Date) as RollingPeopleVaccinated
from PortfolioCovid.dbo.Deaths death
Join PortfolioCovid.dbo.Vaccinations vacs
	on death.location = vacs.location
	and death.date = vacs.date

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- ������� view ��� ����������� ������������
DROP VIEW if exists PercentPopulationVaccinated ;
GO

CREATE VIEW PercentPopulationVaccinated  
as
select death.continent, death.location,  death.date, death.population, vacs.new_vaccinations
, SUM(CONVERT(int,vacs.new_vaccinations)) OVER (Partition by death.Location order by death.Date) as RollingPeopleVaccinated
from PortfolioCovid.dbo.Deaths death
Join PortfolioCovid.dbo.Vaccinations vacs
	on death.location = vacs.location
	and death.date = vacs.date
where death.continent is not null 