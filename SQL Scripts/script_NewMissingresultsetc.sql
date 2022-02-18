USE [HBSA]
GO

/****** Object:  Table [dbo].[MatchResultsFixtureDates]    Script Date: 16/02/2022 19:35:56 ******/
if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MatchResultsFixtureDates') 
	DROP TABLE [dbo].[MatchResultsFixtureDates]
GO

CREATE TABLE [dbo].[MatchResultsFixtureDates](
	[MatchResultID] [int] NOT NULL,
	[FixtureDate] [date] NOT NULL,
 CONSTRAINT [PK_MatchResultsFixtureDates] PRIMARY KEY CLUSTERED 
(
	[MatchResultID], 
	[FixtureDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

insert MatchResultsFixtureDates
     select ID, FixtureDate from MatchResultsDetails2


USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[FixtureDatesBySection]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FixtureDatesBySection')
	drop procedure [dbo].[FixtureDatesBySection] 
GO

CREATE procedure [dbo].[FixtureDatesBySection] 
	(@SectionID int 
	)
as

set nocount on	

declare @SectionSize int
select @SectionSize=count(*) from Teams where SectionID=@SectionID

declare @Fixtures table (FixtureDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare FixturesCursor cursor for
	select M.SectionID,M.SectionSize,D.WeekNo,
	   h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8, 
	   FixtureDate
		from FixtureDates D
		left join FixtureGrids M
		  on M.SectionID=D.SectionID --@SectionID
		 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then @MatrixSize else D.WeekNo % @MatrixSize end
	 where D.SectionID=@SectionID or @SectionID=0
	 order by D.WeekNo
 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @FixtureDate date
open FixturesCursor
fetch FixturesCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @FixtureDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @Fixtures values (@FixtureDate, @h1, @a1, @sid)
	if not @h2 is null insert @Fixtures values (@FixtureDate, @h2, @a2, @sid)
	if not @h3 is null insert @Fixtures values (@FixtureDate, @h3, @a3, @sid)
	if not @h4 is null insert @Fixtures values (@FixtureDate, @h4, @a4, @sid)
	if not @h5 is null insert @Fixtures values (@FixtureDate, @h5, @a5, @sid)
	if not @h6 is null insert @Fixtures values (@FixtureDate, @h6, @a6, @sid)
	if not @h7 is null insert @Fixtures values (@FixtureDate, @h7, @a7, @sid)
	if not @h8 is null insert @Fixtures values (@FixtureDate, @h8, @a8, @sid)
	fetch FixturesCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @FixtureDate
	end
close FixturesCursor
deallocate FixturesCursor

select F.* , HomeTeamID=H.ID, AwayteamID=A.ID
	from @Fixtures F
	cross apply (Select ID from Teams where SectionID=F.SectionID and F.HomeFixtureNo=FixtureNo) H 
	cross apply (Select ID from Teams where SectionID=F.SectionID and F.AwayFixtureNo=FixtureNo) A
	order by SectionID, FixtureDate
GO

USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SetUpFixtureLinks]    Script Date: 15/02/2022 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SetUpFixtureLinks')
	drop procedure [dbo].SetUpFixtureLinks
GO

CREATE procedure [dbo].SetUpFixtureLinks

as

set nocount on

if exists(select table_name from INFORMATION_SCHEMA.TABLES where TABLE_NAME='FixtureLinks')
	truncate table dbo.FixtureLinks
else
	create table FixtureLinks
		(FixtureDate date
		,HomeFixtureNo int
		,AwayFixtureNo int
		,SectionID int
		,HomeTeamID int
		,AwayTeamID int)

declare @sectionID int
declare SectionIDs cursor for
	select ID from Sections
open SectionIDs
fetch SectionIDs into @sectionID
while @@FETCH_STATUS=0
	begin
	insert FixtureLinks
		exec FixtureDatesBySection @SectionID
	fetch SectionIDs into @sectionID
	end
close SectionIDs
deallocate SectionIDs

GO

exec SetUpFixtureLinks

USE [HBSA]
GO
/****** Object:  View [dbo].[MatchResultsDetails5]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails5')
	drop view dbo.MatchResultsDetails5
GO

CREATE view dbo.MatchResultsDetails5

as

select * from MatchResults
         outer apply (Select FixtureDate from MatchResultsFixtureDates where ID=MatchResultID)FD
GO

USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MissingResults]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MissingResults')
	drop procedure [dbo].[MissingResults]
GO

CREATE procedure [dbo].[MissingResults]

as

set nocount on

 select [Fixture Date] = convert(varchar(11),F.FixtureDate,113)
	  ,Section=[League Name] + ' ' +[Section Name]
	  ,[Home Team] = rtrim(HC.[Club Name] + ' ' + HT.Team)
	  ,[Away Team] = rtrim(AC.[Club Name] + ' ' + AT.Team)
	from FixtureLinks F
	outer apply (select ID 
					from MatchResultsDetails5 M
					 where  F.HomeTeamID = M.HomeTeamID
				      and F.AwayTeamID = M.AwayTeamID
					  and F.FixtureDate = M.FixtureDate ) MID
	cross apply (select ClubID, Team from Teams where ID=F.HomeTeamID) HT 
	cross apply (select ClubID, Team from Teams where ID=F.AwayTeamID) AT 
	cross apply (select [Section Name], LeagueID from Sections where ID = F.SectionID) S
	cross apply (select [League Name] from Leagues where ID = S.LeagueID) L
	cross apply (select [Club Name] from Clubs where ID = HT.ClubID) HC
	cross apply (select [Club Name] from Clubs where ID = AT.ClubID) AC
	where F.FixtureDate < CONVERT(date,dbo.UKdateTime(GETUTCDATE()))
	  and MID.ID is null
	  and HT.ClubID <> 8
	  and AT.ClubID <> 8
	  order by F.FixtureDate,SectionID,[Home Team]

GO
USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[StartOfSeason]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'StartOfSeason')
	drop procedure StartOfSeason
GO

create procedure [dbo].[StartOfSeason]

as

set nocount on
set xact_abort on

begin tran

--restart hit counters
declare @Year varchar(250) = '_' + convert(char(4),datepart(year,dbo.UKdateTime(getUTCdate())))
declare @SQL varchar(max) = '
If not exists (select table_name from INFORMATION_SCHEMA.tables where table_name=''HomePages' + @Year + ''')
	select * into HomePages' + @Year + ' from HomePages'
exec (@SQL)
truncate table HomePages

--Trim activity log
delete ActivityLog
	where dtlodged < dateadd(year,-1,dbo.UKdateTime(getUTCdate()))
delete HomeContent 
	where dtlodged < dateadd(year,-1,dbo.UKdateTime(getUTCdate()))
truncate table Breaks
truncate table Breaks_deleted
truncate table eMailLog
truncate table LeaguePointsAdjustment

delete PlayersHandicapChanges 
	where dateChanged < dateadd(month,-1,dbo.UKdateTime(getUTCdate()))

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MatchResults_Historic')
	drop table MatchResults_Historic

select * into MatchResults_Historic
	from MatchResults
truncate table MatchResults
truncate table MatchResults_Deleted

--set all players as not yet played
update Players
	set Played=0

--Set Players into their correct sections (after promotions/demotions)
update Players
		set SectionID = T.sectionID
		 from Players P
		 join Teams T on T.ClubID = P.ClubID and T.Team=P.Team and T.SectionID in (select ID from Sections where LeagueID=P.LeagueID)  
	where P.SectionID <> 0 
	  and P.SectionID<>T.SectionID

--Set config as in open season
update Configuration	
	set [value]=0
	where [key] = 'CloseSeason'	

--Set config as League entry forms not allowed
update Configuration	
	set value=0
	where [key]='AllowLeaguesEntryForms'

--Set End of close season date
update Configuration	
	set value=convert (varchar(11),dbo.UKdateTime(getUTCdate()),113)
	where [key]='CloseSeasonEndDate'
	   
--remove any orphaned team logins, and any outstanding unconfirmed logins
delete resultsusers
	from resultsusers
	left join teams on teamID=teams.id
	where teams.id is null
	   or Confirmed <> 'Confirmed'

--Set up the fixture links table 
exec SetUpFixtureLinks

commit tran


GO

USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[StartOfSeason]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'StartOfSeason')
	drop procedure StartOfSeason
GO

create procedure [dbo].[StartOfSeason]

as

set nocount on
set xact_abort on

begin tran

--restart hit counters
declare @Year varchar(250) = '_' + convert(char(4),datepart(year,dbo.UKdateTime(getUTCdate())))
declare @SQL varchar(max) = '
If not exists (select table_name from INFORMATION_SCHEMA.tables where table_name=''HomePages' + @Year + ''')
	select * into HomePages' + @Year + ' from HomePages'
exec (@SQL)
truncate table HomePages

--Trim activity log
delete ActivityLog
	where dtlodged < dateadd(year,-1,dbo.UKdateTime(getUTCdate()))
delete HomeContent 
	where dtlodged < dateadd(year,-1,dbo.UKdateTime(getUTCdate()))
truncate table Breaks
truncate table Breaks_deleted
truncate table eMailLog
truncate table LeaguePointsAdjustment

delete PlayersHandicapChanges 
	where dateChanged < dateadd(month,-1,dbo.UKdateTime(getUTCdate()))

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MatchResults_Historic')
	drop table MatchResults_Historic

select * into MatchResults_Historic
	from MatchResults
truncate table MatchResults
truncate table MatchResults_Deleted

--set all players as not yet played
update Players
	set Played=0

--Set Players into their correct sections (after promotions/demotions)
update Players
		set SectionID = T.sectionID
		 from Players P
		 join Teams T on T.ClubID = P.ClubID and T.Team=P.Team and T.SectionID in (select ID from Sections where LeagueID=P.LeagueID)  
	where P.SectionID <> 0 
	  and P.SectionID<>T.SectionID

--Set config as in open season
update Configuration	
	set [value]=0
	where [key] = 'CloseSeason'	

--Set config as League entry forms not allowed
update Configuration	
	set value=0
	where [key]='AllowLeaguesEntryForms'

--Set End of close season date
update Configuration	
	set value=convert (varchar(11),dbo.UKdateTime(getUTCdate()),113)
	where [key]='CloseSeasonEndDate'
	   
--remove any orphaned team logins, and any outstanding unconfirmed logins
delete resultsusers
	from resultsusers
	left join teams on teamID=teams.id
	where teams.id is null
	   or Confirmed <> 'Confirmed'

--Set up the fixture links table 
exec SetUpFixtureLinks

commit tran


GO
USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[insertMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='insertMatchResult')
	drop procedure dbo.insertMatchResult
GO

create procedure dbo.insertMatchResult
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
	,@FixtureDate date
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

declare @MatchResultID int
select @MatchResultID= ID from MatchResultsDetails2 where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID and FixtureDate = @FixtureDate
if @MatchResultID is not null
	exec deleteMatchResult @MatchResultID, @UserID

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

-- update MatchResultsFixtureLink
insert MatchResultsFixtureDates
	(MatchResultID, FixtureDate)
	values(@MatchResultID, @FixtureDate)
--convert userID to the resultuser login if it's numereic
if isnumeric(@userID) = 1 
	select @UserID=eMailAddress from resultsusers where id=@UserID

insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert match result',@MatchResultID,convert(varchar,@Userid))

commit tran

select @MatchResultID

GO

USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[deleteMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[deleteMatchResult]
	(@MatchResultID int
	,@UserID varchar(255)
	)
as

set nocount on
set xact_abort on

if @MatchResultID is not null
	begin
	
	begin tran
	
	if exists (select MatchResultID from Breaks where MatchResultID=@MatchResultID)
		begin
		insert into Breaks_Deleted select * from Breaks where MatchResultID=@MatchResultID
		delete from Breaks where MatchResultID=@MatchResultID
		end
	
	
	insert MatchResults_Deleted select * from MatchResults where ID = @MatchResultID
	delete matchResults where ID = @MatchResultID
	
	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate())
		,'delete match result: MatchresultID='+convert(varchar,@MatchresultID)
		,@MatchResultID
		,@Userid)
	
	commit tran
	
	end


GO
