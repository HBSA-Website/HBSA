USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='NewSession')
	DROP procedure NewSession
GO

create procedure NewSession
	(@sessionID varchar(24)
	,@Client varchar(1000)
	,@OSinfo varchar(1000)
	,@device varchar(1000)
	,@brand varchar(1000)
	,@model varchar(1000)
	)
AS 

set nocount on
set xact_abort on

begin tran

delete SessionLog 
	where dtStart < dateadd(week,-1,dbo.UKdateTime(getUTCdate()))

insert SessionLog
	select   @sessionID
		    ,dbo.UKdateTime(getUTCdate())
			,NULL
			,@Client
			,@OSinfo
			,@device
			,@brand
			,@model

commit tran

GO
