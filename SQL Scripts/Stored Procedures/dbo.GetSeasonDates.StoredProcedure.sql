USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetSeasonDates]    Script Date: 12/12/2014 17:46:00 ******/
If exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetSeasonDates')
	drop procedure dbo.GetSeasonDates
GO

CREATE procedure [dbo].[GetSeasonDates] 
	 
as

set nocount on

select	 StartOfSeason=min (FixtureDate)
	    ,EndOfSeason=max(Fixturedate) 
	from FixtureDates

GO
