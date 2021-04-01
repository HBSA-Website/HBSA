USE HBSA
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='SessionLog')
	DROP table SessionLog
GO

Create table SessionLog
	(SessionID varchar(24)
	,dtStart datetime
	,dtStop  datetime
	,Client varchar(1000)
	,OSinfo varchar(1000)
	,device varchar(1000)
	,brand varchar(1000)
	,model varchar(1000)
	)
GO
	    