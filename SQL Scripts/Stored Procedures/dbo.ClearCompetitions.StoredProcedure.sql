USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ClearCompetitions')
	drop procedure ClearCompetitions
GO

create procedure ClearCompetitions

as

set nocount on
set xact_abort on

begin tran

declare @year int
select @year=year(dbo.UKdateTime(getUTCdate()))

exec createArchive 'Competitions_Rounds',@year 
exec createArchive 'Competitions_Entries',@year 

truncate table Competitions_Rounds
truncate table Competitions_Entries
truncate table JuniorLeagues
truncate table JuniorResults

update competitions set NoRounds=0

commit tran
GO
