USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='SessionIDexists')
	DROP procedure SessionIDexists
GO

create procedure SessionIDexists
	(@SessionID varchar(24)
	)
AS 

If exists (select SessionID 
				from SessionLog
				where SessionID = @SessionID)
	select convert(bit,1)
else
	select convert(bit,0)

GO

exec SessionIDexists 'zfwhdtzoj0rxxun30abs0te'

