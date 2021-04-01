USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='HalfwayThroughSeason')
	drop procedure HalfwayThroughSeason

GO
create procedure HalfwayThroughSeason

as

set nocount on


select case when dbo.UKdateTime(getUTCdate()) < (select max(Fixturedate) from FixtureDates where weekNo = SectionSize-1) 
			then 0 
			else 1 
		end

GO

exec HalfwayThroughSeason
