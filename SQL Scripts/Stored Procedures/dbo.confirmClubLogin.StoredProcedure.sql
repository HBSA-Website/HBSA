USE [HBSA]
GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='confirmClubLogin')
	drop procedure confirmClubLogin
GO

CREATE procedure confirmClubLogin
	(@eMailAddress varchar(255)
	,@Password varchar(255)
	,@ConfirmCode varchar(10)
	)
as

set noCount on	

update ClubUsers
	set Confirmed = 'Confirmed'
where eMailAddress=@eMailAddress
  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS
  and Confirmed = @ConfirmCode collate SQL_Latin1_General_CP1_CS_AS

if @@ROWCOUNT > 0
	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'ConfirmClubUser',null,@eMailAddress+'|'+@Password+'|'+@ConfirmCode)  
else
	raiserror('Confirmation failed',15,1)

GO
