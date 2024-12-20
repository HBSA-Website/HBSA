USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForLeague]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForLeague]    Script Date: 15/12/2014 13:46:01 ******/
DROP PROCEDURE [dbo].[GetFixtureDatesForLeague]
GO

create procedure [dbo].[GetFixtureDatesForLeague]
	(@LeagueID int
	)
as

If @LeagueID > 100
	set @LeagueID = @LeagueID % 100
else
	select @LeagueID = LeagueID from Sections where ID=@LeagueID 

select top 1 StartDate=convert(varchar(11),FixtureDate,113)
           , CurfewStart=convert(varchar(11),StartDate,113)
           , CurfewEnd=convert(varchar(11),Enddate,113)
	from FixtureDates
	left join FixtureDatesCurfew on FixtureDates.SectionID=FixtureDatesCurfew.SectionID
	where FixtureDates.SectionID in (Select ID from sections where LeagueID=@LeagueID)
	order by WeekNo
	
select distinct
	   WeekNo
     , FixtureDate=convert(varchar(11),FixtureDate,113)
	from FixtureDates
	where SectionID in (Select ID from sections where LeagueID=@LeagueID)
	order by WeekNo


GO
exec GetFixtureDatesForLeague 101