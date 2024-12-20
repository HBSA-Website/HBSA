USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeletedMatchResult')
	drop procedure dbo.DeletedMatchResult
GO

CREATE procedure dbo.DeletedMatchResult
	(@HomeTeamID int
	,@AwayTeamID int
	)
as

set nocount on
if exists (select ID from MatchResults_Deleted 
					where HomeTeamID=@HomeTeamID and awayteamid=@AwayTeamID)

	select 1
else 
	select 0

GO

exec DeletedMatchResult 27, 212
