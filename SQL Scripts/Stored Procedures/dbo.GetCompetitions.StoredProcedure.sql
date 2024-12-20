USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitions')
	drop procedure GetCompetitions
GO

CREATE procedure GetCompetitions
	(@Drawn bit = 0
	)

as

set nocount on

select ID=Competitions.ID
	 , Name
	 , League=[League Name]
	 , CompetitionType=case when CompType=1 then 'Open'
	                        when CompType=2 then 'Handicaps'
	                        when CompType=3 then 'Pairs'
	                        when CompType=4 then 'Teams'
	                   end
	 , NoRounds    
	 , Comment                   
	 , EntryForm
	 , EntryFee

	From Competitions
	join Leagues on Leagues.ID=LeagueID
	
	where @Drawn=0
	   or NoRounds is not null

GO
