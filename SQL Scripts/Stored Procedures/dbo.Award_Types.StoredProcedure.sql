use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Award_Types')
	drop procedure dbo.Award_Types
GO

create procedure dbo.Award_Types

as

select * from Awards_Types order by AwardType

GO

exec Award_Types
