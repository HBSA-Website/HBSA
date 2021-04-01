USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateConfig')
	drop procedure UpdateConfig
GO

create procedure UpdateConfig
	(@key varchar(150)
	,@value varchar(1000)
	)

as

set nocount on

update Configuration	
	set value=@value
	where [key]=@key

GO