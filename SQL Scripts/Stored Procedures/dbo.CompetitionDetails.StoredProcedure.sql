USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionDetails')
	drop procedure CompetitionDetails
GO

create procedure CompetitionDetails
	(@ID as integer
	)
as

set nocount on

select * From Competitions where ID = @ID

GO