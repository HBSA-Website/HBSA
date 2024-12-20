USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteCompetitionEntry')
	drop procedure DeleteCompetitionEntry
GO
create procedure DeleteCompetitionEntry
	(@CompetitionID int
	,@EntryID int
	)

as

set nocount on
set xact_abort on
	
begin tran

if (select isnull(NoRounds,0) from Competitions  where ID=@CompetitionID) > 0
	begin --the draw has been made so change entrant to a bye, in the latest round
	update Competitions_Entries
		set EntrantID=NULL, Entrant2ID=NULL
		where CompetitionID=@CompetitionID
		  and EntryID=@EntryID
		  and RoundNo = (select max(RoundNo) 
		                     from Competitions_Entries 
							 where CompetitionID=@CompetitionID
							   and EntryID=@EntryID)
	end
else
	begin
	delete Competitions_Entries
		where CompetitionID=@CompetitionID
		  and EntryID=@EntryID
	--can only delete from baseline
	exec MakeCompetition1stRound @CompetitionID
	end

commit tran

GO

exec DeleteCompetitionEntry 2,0