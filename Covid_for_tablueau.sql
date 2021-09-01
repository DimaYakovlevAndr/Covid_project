
-- Смертность в мире
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as mortality
From PortfolioCovid.dbo.Deaths
where continent is not null 
order by 1,2

--Континенты по кол-ву смертей + сортировка

Select location, SUM(cast(new_deaths as int)) as TotalDeath
From PortfolioCovid.dbo.Deaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- Процент от общего заражены

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioCovid.dbo.Deaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Процент от общего заражены по дате


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioCovid.dbo.Deaths
Group by Location, Population, date
order by PercentPopulationInfected desc
