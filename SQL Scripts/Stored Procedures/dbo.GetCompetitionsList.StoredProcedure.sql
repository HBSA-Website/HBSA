USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionsList')
	drop procedure GetCompetitionsList
GO

CREATE procedure GetCompetitionsList

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

GO

GetCompetitionsList
