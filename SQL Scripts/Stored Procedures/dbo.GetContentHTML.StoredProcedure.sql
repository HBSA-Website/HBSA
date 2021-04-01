USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetContentHTML')
	drop procedure GetContentHTML
GO

CREATE procedure GetContentHTML
	(@Contentname varchar(128)
	)
as

set nocount on

Select ContentHTML, dtLodged
	from ContentData
	where ContentName=@Contentname 

GO

exec GetContentHTML 'Home'

