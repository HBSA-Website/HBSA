USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForSection]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForSection]    Script Date: 15/12/2014 13:46:01 ******/
DROP PROCEDURE [dbo].[GetFixtureDatesForSection]
GO

create procedure [dbo].[GetFixtureDatesForSection]
	(@SectionID int
	)
as

select top 1 StartDate=convert(varchar(11),FixtureDate,113)
           , CurfewStart=convert(varchar(11),StartDate,113)
           , CurfewEnd=convert(varchar(11),Enddate,113)
	from FixtureDates
	left join FixtureDatesCurfew on FixtureDates.SectionID=FixtureDatesCurfew.SectionID
	where FixtureDates.SectionID=@SectionID
	order by WeekNo
	
select SectionID
     , SectionSize
     , WeekNo
     , FixtureDate=convert(varchar(11),FixtureDate,113)
	from FixtureDates
	where SectionID=@SectionID
	order by WeekNo


GO
