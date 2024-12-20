USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetBreaksCategories')
	drop procedure GetBreaksCategories
GO

create procedure dbo.GetBreaksCategories

as	

set nocount on

select * 
	from BreaksCategories 
	cross apply (select [League Name] from Leagues where ID=LeagueID) L

GO
exec GetBreaksCategories