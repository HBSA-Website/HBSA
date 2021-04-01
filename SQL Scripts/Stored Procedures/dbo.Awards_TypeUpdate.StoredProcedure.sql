use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypeUpdate')
	drop procedure dbo.Awards_TypeUpdate
GO

create procedure dbo.Awards_TypeUpdate
	(@AwardType int
	,@Name varchar(255)
	,@description varchar(63)
	,@StoredProcedureName varchar(255)
	)
as

set nocount on

update Awards_Types
	set Name				= @Name
	   ,[Description]		= @description
	   ,StoredProcedureName	= @StoredProcedureName
	where @AwardType = AwardType

GO

exec Awards_TypeUpdate 4,'Highest Break in [League]', 'Highest Break in a league', 'Awards_HighestBreaksByLeague'

select * from Awards_Types