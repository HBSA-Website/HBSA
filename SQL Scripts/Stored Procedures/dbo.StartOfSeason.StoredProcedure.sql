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

commit tran


GO
