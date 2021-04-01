USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ClubLoginPasswordReset')
	drop procedure ClubLoginPasswordReset
GO

create procedure dbo.ClubLoginPasswordReset
	(@ClubID           int
	,@Password     varchar(255)
	)
as

set noCount on	

update ClubUsers 
	set Password=@Password
	where ClubID=@ClubID

GO
