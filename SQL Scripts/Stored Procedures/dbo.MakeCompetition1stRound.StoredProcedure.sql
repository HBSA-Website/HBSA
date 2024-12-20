USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MakeCompetition1stRound')
	drop procedure MakeCompetition1stRound
GO
create procedure MakeCompetition1stRound
	(@CompetitionID int
	)

as

set nocount on
	
set xact_abort on

begin tran

delete Competitions_Entries 
	where CompetitionID=@CompetitionID
	  and (EntrantID is null or RoundNo > 0)

update Competitions set NoRounds=NULL where ID = @CompetitionID

exec ResequenceCompetitionEntryIDs @CompetitionID

commit tran

GO

exec MakeCompetition1stRound 3