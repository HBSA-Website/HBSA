USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetContentNames')
	drop procedure GetContentNames
GO

CREATE procedure GetContentNames
	
as

set nocount on

select ContentName 
	from ContentData
	order by ContentName

GO

exec GetContentNames

