USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageDeleteALL')
	drop procedure HomePageDeleteALL
GO

create procedure dbo.HomePageDeleteALL

as	

set nocount on

truncate table HomeContent

GO
