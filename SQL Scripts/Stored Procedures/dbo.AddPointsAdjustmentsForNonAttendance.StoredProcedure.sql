USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[AddPointsAdjustmentsForNonAttendance]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[AddPointsAdjustmentsForNonAttendance]
	@Clubname varchar (50)

as

insert LeaguePointsAdjustment

select Teams.ID  
      ,pts=case when LeagueID=3 then -3 else -4 end 
      ,'non attendance at meetings'
      ,dbo.UKdateTime(getUTCdate()), 'admin'
      from Teams
         join Sections on Sections.ID=SectionID
         where LeagueID <> 2
           and ClubID in (select ID from Clubs where [Club Name] = @Clubname) 


GO
