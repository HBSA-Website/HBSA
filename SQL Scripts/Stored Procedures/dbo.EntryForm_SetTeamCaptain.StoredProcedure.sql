USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_SetTeamCaptain')
	drop procedure dbo.EntryForm_SetTeamCaptain
GO

create procedure dbo.EntryForm_SetTeamCaptain 
	(@PlayerID int
	,@Captain bit
	)

as

set nocount on

update EntryForm_Teams
	set Captain = case when @Captain = 1 then @PlayerID else 0 end
	from EntryForm_Teams T
	join (select ClubID, LeagueID, Team from EntryForm_Players where PlayerID=@PlayerID) P
	  on T.ClubID   = P.ClubID
     and T.LeagueID = P.LeagueID
	 and T.Team     = P.team

GO

select * from EntryForm_Teams where TeamID=1340
