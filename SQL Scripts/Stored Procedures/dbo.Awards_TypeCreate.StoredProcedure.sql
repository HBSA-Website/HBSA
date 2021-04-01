use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypeCreate')
	drop procedure dbo.Awards_TypeCreate
GO

create procedure dbo.Awards_TypeCreate
	(@Name varchar(255)
	,@description varchar(63)
	,@StoredProcedureName varchar(255)
	)
as

set nocount on


insert Awards_Types
	select 
	 	 @Name
		,@description
		,@StoredProcedureName

GO