use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertNewConfigurationKey')
	drop procedure InsertNewConfigurationKey
GO

create procedure InsertNewConfigurationKey
	(@Key as varchar(150)
	,@Value varchar(1000) = ''
	)
	as

set nocount on

if exists (Select [key] from configuration where [key]=@key)
	raiserror ('This key already exists',17,1)
else	 
	insert Configuration 
		select @Key,@Value

GO

