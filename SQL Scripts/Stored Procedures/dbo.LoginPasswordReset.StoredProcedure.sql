USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='LoginPasswordReset')
	drop procedure LoginPasswordReset
GO

CREATE procedure LoginPasswordReset
	(@UserID           int
	,@Password     varchar(255)
	)
as

set noCount on	

update Resultsusers 
	set Password=@Password
	where ID=@UserID

GO
