USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[TeamResults]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[TeamResults]
	@TeamID int
as

set nocount on
	
select 
		 [Date]=MatchDate,[Club Name],[ ]=Case when HomeTeamID=@TeamID then 'H' else 'A' end
		,HomePlayer1,HomeHandicap1,HomePlayer1Score,AwayPlayer1,AwayHandicap1,AwayPlayer1Score,HomePlayer2,HomeHandicap2,HomePlayer2Score,AwayPlayer2,AwayHandicap2,AwayPlayer2Score,HomePlayer3,HomeHandicap3,HomePlayer3Score,AwayPlayer3,AwayHandicap3,AwayPlayer3Score,HomePlayer4,HomeHandicap4,HomePlayer4Score,AwayPlayer4,AwayHandicap4,AwayPlayer4Score
	from MatchResultsDetails 
	join Teams 
	  on Teams.ID = case when HomeTeamID=@TeamID then AwayTeamID else HomeTeamID end
	join Clubs on Clubs.ID=ClubID   
	where HomeTeamID=@TeamID or awayteamid=@TeamID order by [Date]


GO
