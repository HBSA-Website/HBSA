USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[insertMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[insertMatchResult]
	(@MatchDate date
	,@HomeTeamID int
	,@AwayTeamID int

	,@HomePlayer1 varchar(55)
	,@HomeHandicap1 int
	,@HomeScore1 int
	,@AwayPlayer1 varchar(55)
	,@AwayHandicap1 int
	,@AwayScore1 int
	,@HomePlayer2 varchar(55)
	,@HomeHandicap2 int
	,@HomeScore2 int
	,@AwayPlayer2 varchar(55)
	,@AwayHandicap2 int
	,@AwayScore2 int
	,@HomePlayer3 varchar(55)
	,@HomeHandicap3 int
	,@HomeScore3 int
	,@AwayPlayer3 varchar(55)
	,@AwayHandicap3 int
	,@AwayScore3 int
	,@HomePlayer4 varchar(55)
	,@HomeHandicap4 int
	,@HomeScore4 int
	,@AwayPlayer4 varchar(55)
	,@AwayHandicap4 int
	,@AwayScore4 int

	,@UserID varchar(255)
	)
as

set nocount on
set xact_abort on

begin tran

--indicate players have played to fix them to their team
declare @Team char(1)

select @Team=Team from Teams where ID=@HomeTeamID
update Players set Played=1, Team=@Team where ID=@HomePlayer1 
update Players set Played=1, Team=@Team where ID=@HomePlayer2 
update Players set Played=1, Team=@Team where ID=@HomePlayer3
update Players set Played=1, Team=@Team where ID=@HomePlayer4

select @Team=Team from Teams where ID=@AwayTeamID
update Players set Played=1, Team=@Team where ID=@AwayPlayer1 
update Players set Played=1, Team=@Team where ID=@AwayPlayer2 
update Players set Played=1, Team=@Team where ID=@AwayPlayer3
update Players set Played=1, Team=@Team where ID=@AwayPlayer4


if (select count(*) from matchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID) > 0 
	exec deleteMatchResult @HomeTeamID,@AwayTeamID,@UserID 

declare @MatchResultID int
	
insert matchResults values 
	(@MatchDate 
	,@HomeTeamID
	,@AwayTeamID
	,@HomePlayer1
	,@HomeScore1
	,@HomeHandicap1
	,@AwayPlayer1
	,@AwayScore1
	,@AwayHandicap1
	,@HomePlayer2
	,@HomeScore2
	,@HomeHandicap2
	,@AwayPlayer2
	,@AwayScore2
	,@AwayHandicap2
	,@HomePlayer3
	,@HomeScore3
	,@HomeHandicap3
	,@AwayPlayer3
	,@AwayScore3
	,@AwayHandicap3
	,@HomePlayer4
	,@HomeScore4
	,@HomeHandicap4
	,@AwayPlayer4
	,@AwayScore4
	,@AwayHandicap4
	,dbo.UKdateTime(getUTCdate())
	,@UserID
	)

select @MatchResultID=scope_identity()

--convert userID to the resultuser login if it's numereic
if isnumeric(@userID) = 1 
	select @UserID=eMailAddress from resultsusers where id=@UserID

insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert match result',@MatchResultID,convert(varchar,@Userid))

commit tran

select @MatchResultID

GO
