USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'RecoverMatchResult')
	drop procedure dbo.RecoverMatchResult
GO

CREATE procedure dbo.RecoverMatchResult
	(@HomeTeamID int
	,@AwayTeamID int
	)
as

set nocount on
set xact_abort on

declare @MatchID int

begin tran
select @MatchID= (select top 1 ID 
						from MatchResults_Deleted 
						where HomeTeamID=@HomeTeamID and awayteamid=@AwayTeamID 
						order by DateTimeLodged desc)

set identity_insert MatchResults on
insert MatchResults
	(ID, MatchDate, HomeTeamID, AwayTeamID, 
		HomePlayer1ID, HomePlayer1Score, HomeHandicap1, AwayPlayer1ID, AwayPlayer1Score, AwayHandicap1, 
		HomePlayer2ID, HomePlayer2Score, HomeHandicap2, AwayPlayer2ID, AwayPlayer2Score, AwayHandicap2, 
		HomePlayer3ID, HomePlayer3Score, HomeHandicap3, AwayPlayer3ID, AwayPlayer3Score, AwayHandicap3,
		HomePlayer4ID, HomePlayer4Score, HomeHandicap4, AwayPlayer4ID, AwayPlayer4Score, AwayHandicap4,
		DateTimeLodged, UserID)
	select * from MatchResults_Deleted 
		where ID=@MatchID 
		order by DateTimeLodged desc
set identity_insert MatchResults off

set identity_insert Breaks on
insert Breaks
	(ID, MatchResultID, PlayerID, [Break])
    select * from Breaks_Deleted 
		where MatchResultID=@MatchID
set identity_insert MatchResults off

delete MatchResults_Deleted where ID=@MatchID
delete Breaks_Deleted where ID=@MatchID

commit tran

GO

--exec RecoverMatchResult 27, 212
