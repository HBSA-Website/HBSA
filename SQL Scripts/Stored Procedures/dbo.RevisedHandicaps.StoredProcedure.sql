USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[RevisedHandicaps]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[RevisedHandicaps]
	(@LeagueID int = 0
	,@SectionID int = 0
	)

as

set nocount on
set xact_abort on

select Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+Teams.Team
      ,PlayerID
      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
      ,T.Tagged
      ,T.Over70
      ,T.Played
      ,T.Won
      ,T.Lost
      ,T.Delta
      ,[Last Season's Handicap]=T.Handicap
      --,T.Effective
      ,[Current Handicap]=Players.Handicap
	from HandicapsReportTable T
	join Players on Players.ID=PlayerID
	join Sections on Sections.ID=T.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=Players.ClubID
	join Teams on teams.SectionID=T.SectionID and  Teams.ClubID=Players.ClubID and Teams.Team=Players.team

	where T.Effective=(select max(effective) from HandicapsReportTable where PlayerID=T.PlayerID)
	  and (@LeagueID = 0 or Sections.LeagueID=@LeagueID)
	  and (@SectionID = 0 or T.SectionID=@SectionID)
	  and [New Handicap] <> T.Handicap 
	
	order by T.SectionID, [Club Name], Player



GO
