use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EndOfSeason')
	drop procedure EndOfSeason
GO


create procedure [dbo].[EndOfSeason]

as

set nocount on
set xact_abort on

--This routine is used between seasons nto perform various housekeeping tasks
--to finish off a season, and prepare for the next season

declare @Season int
set @Season = datepart(year,dbo.UKdateTime(getUTCdate()))

begin tran

--step 1:  create Historic Player Records for the season just past
create table #temp
	(HCapEffectice date
	,Section varchar(101)
	,Team varchar(52)
	,Player varchar(106)
	,Handicap int
	,tag varchar(15)
	,Over70 varchar(5)
	,Played int
	,Won int
	,Lost int
	,PlayerID int)

insert #temp
	exec [PlayingRecords]

delete PlayerRecords where Season=@Season	
insert PlayerRecords
	select 
       LeagueID=case when section like '%Open%' then 1
                     when section like '%Vet%' then 2
                     when section like '%bill%' then 3
                     else 0
                end
      ,[Player]
      ,[Season]=@Season
      ,[Hcap]=Handicap
      ,[P]=Played
      ,[W]=Won
      ,[L]=Lost
      ,[Team]=Team
      ,[Tag] = tag
	  ,PlayerID
	  ,Forename
	  ,Initials
	  ,Surname

	from #temp 
	outer apply (select Surname, Initials, Forename from Players where ID=PlayerID) p
	where Team is not null
	order by LeagueID,Player

drop table #temp	

--Step 2: create historic breaks table with last seasons recorded breaks
--        first time through will create table
IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('Breaks_Historic') AND type in (N'U'))
	CREATE TABLE Breaks_Historic
		(ID int IDENTITY(1,1)
		,Season int
		,Section varchar(101)
		,Player varchar(104)
		,[Break] int
		,LeagueID int
		,SectionID int
		,PlayerID int
        ) 
delete Breaks_Historic
	where Season=@Season
insert Breaks_Historic
	select @Season
	      ,[League Name] + ' ' + [Section Name]
	      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
	      ,[Break]
	      ,P.LeagueID
	      ,P.SectionID
	      ,B.PlayerID
	from Breaks B
	join Players P on P.ID=B.PlayerID
	join Sections S on S.ID=P.SectionID
	join Leagues L on L.ID=P.LeagueID 
	order by P.LeagueID,P.SectionID,Player

--Step 3: create table of last season's ending handicaps with playing record
--        and calculated new handicaps
exec GenerateHandicapsReport

--Step 4: Set up Entry Forms
exec EntryForm_CreateTables

--Set config as in close season
update Configuration	
	set value=1
	where [key] = 'CloseSeason'	

--Set config as League entry forms not allowed
update Configuration	
	set value=0
	where [key]='AllowLeaguesEntryForms'

commit tran

GO
--select * from Configuration