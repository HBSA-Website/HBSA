USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateCompetition')
	drop procedure UpdateCompetition
GO
create procedure UpdateCompetition
	(@CompetitionID int
	,@Name varchar(50)
	,@LeagueID int
	,@CompType int = 1
	,@Comment varchar(256) = ''
	,@EntryForm bit
	,@EntryFee decimal(5,2)
	)
as		

set nocount on

	    update Competitions
			set Name = @Name
			   ,LeagueID=@LeagueID
			   ,CompType=@CompType
			   ,Comment=@Comment
			   ,EntryForm=@EntryForm 
			   ,EntryFee=@EntryFee

			where ID = @CompetitionID



GO
