USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetFixtureGrid')
	drop procedure GetFixtureGrid
GO

create procedure GetFixtureGrid
	(@SectionID int
	)
as

set nocount on

--if the number of fixture dates differs from the fixture grid we must rebuild the grid
if (select count(*) from Fixturedates where sectionid=@SectionID) <> (select count(*) from FixtureGrids  where sectionid=@SectionID)
	exec assignFixtureGrid  @SectionID

select *
	from FixtureGrids
	where SectionID=@SectionID
	order by WeekNo

GO
