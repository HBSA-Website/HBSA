USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MinimumInteger')
	drop function MinimumInteger
GO

CREATE FUNCTION dbo.MinimumInteger 
	()
 RETURNS bigint
AS
BEGIN

return -2147483647  

END

GO

select dbo.MinimumInteger()