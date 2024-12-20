USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[ListAdjustedPoints]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ListAdjustedPoints')
	drop procedure dbo.ListAdjustedPoints
GO

create procedure [dbo].[ListAdjustedPoints]

as

set nocount on

select SectionID
      ,TeamID
	  ,Section=[League Name]+' '+[Section Name] 
	  ,Team=[Club Name]+' '+Team
      ,Points
      ,Comment
	  ,CreatedDate
	  ,CreatedBy
	  ,LeaguePointsAdjustment.ID

	from LeaguePointsAdjustment 
	join Teams on Teams.ID=TeamID
	join Clubs on Clubs.ID=ClubID
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	
order by SectionID, Team

GO
