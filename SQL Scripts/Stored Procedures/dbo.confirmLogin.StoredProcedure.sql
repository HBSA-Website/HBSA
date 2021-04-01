USE [HBSA]
GO
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='confirmLogin')
	drop procedure confirmLogin
GO

CREATE procedure confirmLogin
	(@eMailAddress varchar(255)
	,@Password varchar(255)
	,@ConfirmCode varchar(10)
	)
as

set noCount on	

update Resultsusers
	set Confirmed = 'Confirmed'
where eMailAddress=@eMailAddress
  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS
  and Confirmed = @ConfirmCode

insert ActivityLog values
	(dbo.UKdateTime(getUTCdate()),'ConfirmUser',null,@eMailAddress+'|'+@Password+'|'+@ConfirmCode)  


GO
