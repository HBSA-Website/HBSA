USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteConfig')
	drop procedure DeleteConfig
GO

create procedure DeleteConfig
	@key varchar(150)

as

set nocount on

DELETE Configuration	
	where [key]=@key
GO