USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MaximumInteger')
	drop function MaximumInteger
GO

CREATE FUNCTION dbo.MaximumInteger 
	()
 RETURNS int
AS
BEGIN

return 2147483647

END

GO

select dbo.MaximumInteger()