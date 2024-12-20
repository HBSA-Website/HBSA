USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GridMatrixSize')
	drop function dbo.GridMatrixSize
GO

CREATE FUNCTION dbo.GridMatrixSize 
	(@SectionID int
	)

RETURNS integer

AS

BEGIN


return (select COUNT(*) from FixtureGrids where SectionID=@SectionID)

END


GO

select dbo.GridMatrixSize(10)
