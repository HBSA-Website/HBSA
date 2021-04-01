use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ActivityLogActions')
	drop procedure dbo.ActivityLogActions
GO

create procedure dbo.ActivityLogActions

as

select distinct [Value]=[Action], [Action] 
	from ActivityLogMetadata
	order by [Action]

GO

exec ActivityLogActions