USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionsEntryForm_GetCompetitions')
	drop procedure CompetitionsEntryForm_GetCompetitions
GO

CREATE procedure CompetitionsEntryForm_GetCompetitions

as

set nocount on

select ID=Competitions.ID
	 , League=[League Name]
	 , Name
	 , [Type]=case when CompType=1 then 'Open'
	               when CompType=2 then 'Handicaps'
	               when CompType=3 then 'Pairs'
	               when CompType=4 then 'Teams'
	          end

	From Competitions
	join Leagues on Leagues.ID=LeagueID
	
	where EntryForm=1
	order by LeagueID, CompType
GO

CompetitionsEntryForm_GetCompetitions
