USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateCompetitionEntryID')
	drop procedure UpdateCompetitionEntryID
GO
create procedure UpdateCompetitionEntryID
	(@CompetitionID int
	,@DrawID int
	,@EntryID int
	)

as

set nocount on
	
update Competitions_Entries
		set EntryID=@EntryID
	where CompetitionID=@CompetitionID
	  and DrawID=@DrawID

GO
