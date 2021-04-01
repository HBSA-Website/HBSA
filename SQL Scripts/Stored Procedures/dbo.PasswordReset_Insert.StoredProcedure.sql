USE [HBSA]
GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='PasswordReset_Insert')
	drop procedure PasswordReset_Insert
GO
CREATE procedure PasswordReset_Insert(
	@eMailAddress varchar(155),
	@TeamID int
) as

set nocount on
set xact_abort on

begin tran

--if this reset already exists update the requested date time
if exists (
	select teamID from PasswordResets
		where @eMailAddress = eMailAddress
		  and @TeamID       = TeamID
)
	update PasswordResets
		set dateRequested = dbo.UKdateTime(getUTCdate())
			where @eMailAddress = eMailAddress
			  and @TeamID       = TeamID
else
	insert PasswordResets
		select @eMailAddress,
			   @TeamID,
			   dbo.UKdateTime(getUTCdate())

--expire old resets requests
declare @expiry int
select @expiry = [value] from [Configuration] where [key] = 'PasswordResetExpiry'
delete PasswordResets
	where dateRequested < dateadd(hour,-@expiry, dbo.UKdateTime(getUTCdate()))

commit tran
GO
