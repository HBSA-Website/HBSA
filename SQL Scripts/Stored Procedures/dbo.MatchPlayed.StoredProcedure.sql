USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MatchPlayed')
	drop procedure dbo.MatchPlayed
GO

CREATE procedure [dbo].[MatchPlayed]
	(@HomeTeamID int
	,@MatchPlayedDate date
	)
as

set nocount on

select M.ID, [Match] = H.Team + ' v ' + A.Team 
	from MatchResults M --Details4
	join TeamDetail H on H.ID = HomeTeamID
	join TeamDetail A on A.ID = AwayTeamID
	where HomeTeamID=@HomeTeamID 
	  and MatchDate = @MatchPlayedDate

Go

exec MatchPlayed 69, '14 Oct 2021'