use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypeData')
	drop procedure dbo.Awards_TypeData
GO

create procedure dbo.Awards_TypeData
	(@AwardType int
	)
as

set nocount on

select * from  Awards_Types
		where @AwardType = AwardType

GO
exec Awards_TypeData 3
