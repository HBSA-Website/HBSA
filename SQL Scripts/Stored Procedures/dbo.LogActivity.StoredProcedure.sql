USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LogActivity')
	drop procedure LogActivity
GO

create procedure LogActivity
	(@Activity varchar(3000)
	,@KeyID int
	,@byWhom varchar(3000)
	)
as

set nocount on

insert Activitylog
	select dbo.UKdateTime(getUTCdate()),@Activity,@KeyID,@byWhom
GO
