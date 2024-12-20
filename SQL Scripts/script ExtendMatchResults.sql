USE HBSA
GO

CREATE TABLE MatchResultsNew(
	ID int IDENTITY(1,1) NOT NULL,
	MatchDate date NOT NULL,
	HomeTeamID int NOT NULL,
	AwayTeamID int NOT NULL,
	HomePlayer1ID int NULL,
	HomePlayer1Score int NULL,
	HomeHandicap1 int null,
	AwayPlayer1ID int NULL,
	AwayPlayer1Score int NULL,
	AwayHandicap1 int null,
	HomePlayer2ID int NULL,
	HomePlayer2Score int NULL,
	HomeHandicap2 int null,
	AwayPlayer2ID int NULL,
	AwayPlayer2Score int NULL,
	AwayHandicap2 int null,
	HomePlayer3ID int NULL,
	HomePlayer3Score int NULL,
	HomeHandicap3 int null,
	AwayPlayer3ID int NULL,
	AwayPlayer3Score int NULL,
	AwayHandicap3 int null,
	HomePlayer4ID int NULL,
	HomePlayer4Score int NULL,
	HomeHandicap4 int null,
	AwayPlayer4ID int NULL,
	AwayPlayer4Score int NULL,
	AwayHandicap4 int null,
	DateTimeLodged datetime NULL,
	UserID varchar(255) NULL
) 
GO
set identity_insert MatchResultsNew on
insert MatchResultsNew
(ID,MatchDate,HomeTeamID,AwayTeamID,HomePlayer1ID,HomePlayer1Score,HomeHandicap1,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1,HomePlayer2ID,HomePlayer2Score,HomeHandicap2,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2,HomePlayer3ID,HomePlayer3Score,HomeHandicap3,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3,HomePlayer4ID,HomePlayer4Score,HomeHandicap4,AwayPlayer4ID,AwayPlayer4Score,AwayHandicap4,DateTimeLodged,UserID)

select   ID,MatchDate,HomeTeamID,AwayTeamID
		,HomePlayer1ID,HomePlayer1Score,HomeHandicap1
		,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1
		,HomePlayer2ID,HomePlayer2Score,HomeHandicap2
		,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2
		,HomePlayer3ID,HomePlayer3Score,HomeHandicap3
		,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3
		,HomePlayer4ID,HomePlayer4Score,HomeHandicap4
		,AwayPlayer4ID,AwayPlayer4Score,AwayHandicap4
		,DateTimeLodged,UserID
	from MatchResults
	cross apply (select HomeHandicap1=Handicap from Players where ID=HomePlayer1ID) h1
	cross apply (select HomeHandicap2=Handicap from Players where ID=HomePlayer2ID) h2
	cross apply (select HomeHandicap3=Handicap from Players where ID=HomePlayer3ID) h3
	cross apply (select HomeHandicap4=Handicap from Players where ID=HomePlayer4ID) h4
	cross apply (select AwayHandicap1=Handicap from Players where ID=AwayPlayer1ID) a1
	cross apply (select AwayHandicap2=Handicap from Players where ID=AwayPlayer2ID) a2
	cross apply (select AwayHandicap3=Handicap from Players where ID=AwayPlayer3ID) a3
	cross apply (select AwayHandicap4=Handicap from Players where ID=AwayPlayer4ID) a4
set identity_insert MatchResultsNew off
GO

CREATE TABLE MatchResults_DeletedNew(
	ID int NOT NULL,
	MatchDate date NOT NULL,
	HomeTeamID int NOT NULL,
	AwayTeamID int NOT NULL,
	HomePlayer1ID int NULL,
	HomePlayer1Score int NULL,
	HomeHandicap1 int null,
	AwayPlayer1ID int NULL,
	AwayPlayer1Score int NULL,
	AwayHandicap1 int null,
	HomePlayer2ID int NULL,
	HomePlayer2Score int NULL,
	HomeHandicap2 int null,
	AwayPlayer2ID int NULL,
	AwayPlayer2Score int NULL,
	AwayHandicap2 int null,
	HomePlayer3ID int NULL,
	HomePlayer3Score int NULL,
	HomeHandicap3 int null,
	AwayPlayer3ID int NULL,
	AwayPlayer3Score int NULL,
	AwayHandicap3 int null,
	HomePlayer4ID int NULL,
	HomePlayer4Score int NULL,
	HomeHandicap4 int null,
	AwayPlayer4ID int NULL,
	AwayPlayer4Score int NULL,
	AwayHandicap4 int null,
	DateTimeLodged datetime NULL,
	UserID varchar(255) NULL
) 
GO
insert MatchResults_DeletedNew
(ID,MatchDate,HomeTeamID,AwayTeamID,HomePlayer1ID,HomePlayer1Score,HomeHandicap1,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1,HomePlayer2ID,HomePlayer2Score,HomeHandicap2,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2,HomePlayer3ID,HomePlayer3Score,HomeHandicap3,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3,HomePlayer4ID,HomePlayer4Score,HomeHandicap4,AwayPlayer4ID,AwayPlayer4Score,AwayHandicap4,DateTimeLodged,UserID)

select   ID,MatchDate,HomeTeamID,AwayTeamID
		,HomePlayer1ID,HomePlayer1Score,HomeHandicap1
		,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1
		,HomePlayer2ID,HomePlayer2Score,HomeHandicap2
		,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2
		,HomePlayer3ID,HomePlayer3Score,HomeHandicap3
		,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3
		,HomePlayer4ID,HomePlayer4Score,HomeHandicap4
		,AwayPlayer4ID,AwayPlayer4Score,AwayHandicap4
		,DateTimeLodged,UserID
	from MatchResults_Deleted
	cross apply (select HomeHandicap1=Handicap from Players where ID=HomePlayer1ID) h1
	cross apply (select HomeHandicap2=Handicap from Players where ID=HomePlayer2ID) h2
	cross apply (select HomeHandicap3=Handicap from Players where ID=HomePlayer3ID) h3
	cross apply (select HomeHandicap4=Handicap from Players where ID=HomePlayer4ID) h4
	cross apply (select AwayHandicap1=Handicap from Players where ID=AwayPlayer1ID) a1
	cross apply (select AwayHandicap2=Handicap from Players where ID=AwayPlayer2ID) a2
	cross apply (select AwayHandicap3=Handicap from Players where ID=AwayPlayer3ID) a3
	cross apply (select AwayHandicap4=Handicap from Players where ID=AwayPlayer4ID) a4

GO	
exec sp_rename 'MatchResults', 'MatchResults_Save'
exec sp_rename 'MatchResults_Deleted', 'MatchResults_Deleted_Save'
GO
exec sp_rename 'MatchResultsNew', 'MatchResults'
exec sp_rename 'MatchResults_DeletedNew', 'MatchResults_Deleted'
GO

alter view [dbo].[MatchResultsDetails]

as

SELECT *
	from MatchResults 
	outer apply (select HomePlayer1=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=Forename + case when Initials<>'' then Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer4ID) a4
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scriptNormalisePlayerNames]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[scriptNormalisePlayerNames]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scriptNormalisePlayerNames2]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[scriptNormalisePlayerNames2]
GO
GO

ALTER procedure [dbo].[insertMatchResult]
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

insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert match result',@MatchResultID,convert(varchar,@Userid))

commit tran

select @MatchResultID
GO

