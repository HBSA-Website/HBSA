USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetFixtures')
	drop procedure GetFixtures
GO
create procedure GetFixtures
	@SectionID int

as
	
exec FixtureMatrix @SectionID
exec SectionList @SectionID,null,1

GO

exec GetFixtures 10