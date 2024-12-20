USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'RemoveCompetitionEntry')
	drop procedure RemoveCompetitionEntry
GO
create procedure RemoveCompetitionEntry
	(@CompetitionID int
	,@EntryID int
	,@RoundNo int
	)

as

set nocount on
	
if @RoundNo > 0
	delete Competitions_Entries
		where CompetitionID=@CompetitionID
		  and RoundNo=@RoundNo
		  and EntryID=@EntryID

else
	update Competitions_Entries
		set EntrantID=NULL, Entrant2ID=NULL 
		where CompetitionID=@CompetitionID
		  and RoundNo=@RoundNo
		  and EntryID=@EntryID

GO
