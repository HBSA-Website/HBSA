USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ClearCompetition')
	drop procedure ClearCompetition
GO

create procedure ClearCompetition
	(@CompetitionID int
	,@FromRound int = NULL
	)
as

set nocount on
set xact_abort on

begin tran

	if @FromRound is null
		begin
		delete Competitions_Entries
			where CompetitionID=@CompetitionID
	
		delete Competitions_Rounds 
			where CompetitionID=@CompetitionID

		update competitions 
			set NoRounds=0
			where ID=@CompetitionID
		end

	else
		delete Competitions_Entries
			where CompetitionID=@CompetitionID
			  and RoundNo >= @FromRound

commit tran
GO

select * from Competitions_entries where competitionID=12