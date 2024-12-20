USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteCompetition')
	drop procedure DeleteCompetition
GO
create procedure [dbo].[DeleteCompetition]
	(@CompetitionID int
	)
as		

set nocount on
set xact_abort on

	begin tran
	
	delete Competitions_Entries
		where CompetitionID=@CompetitionID
	delete Competitions_Rounds 
		where CompetitionID=@CompetitionID
	delete Competitions
		where ID=@CompetitionID
	
	commit tran

GO
