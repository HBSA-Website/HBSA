USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='breaksForMatch')
	drop procedure [dbo].[breaksForMatch]
GO

create Procedure [dbo].[breaksForMatch]
	(@HomeTeamID int
	,@AwayTeamID int
	)
as

set nocount on


declare @MatchResultID int
Select @MatchResultID=ID from MatchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID 

select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = HomePlayer1ID
	    or PlayerID = HomePlayer2ID
	    or PlayerID = HomePlayer3ID
	    or PlayerID = HomePlayer4ID
		or PlayerID = AwayPlayer1ID
	    or PlayerID = AwayPlayer2ID
	    or PlayerID = AwayPlayer3ID
	    or PlayerID = AwayPlayer4ID) 

GO
exec breaksForMatch 28,85
