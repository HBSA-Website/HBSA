USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LastFixtureDateInMatrix')
	drop function dbo.LastFixtureDateInMatrix
GO

CREATE FUNCTION dbo.LastFixtureDateInMatrix 
	(@SectionID int
	)

RETURNS date

AS

BEGIN


return (select FixtureDate 
			from FixtureDates 
			where WeekNo = (select COUNT(*) 
								from FixtureGrids 
								where SectionID=@SectionID)
			  and SectionID=@SectionID)

END


GO

select dbo.LastFixtureDateInMatrix(10)
