USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CloseSession')
	DROP procedure CloseSession
GO

create procedure CloseSession
	(@SessionID varchar(24)
	)
AS 

update SessionLog
	set dtStop=dbo.UKdateTime(getUTCdate())
	where SessionID=@SessionID

GO

