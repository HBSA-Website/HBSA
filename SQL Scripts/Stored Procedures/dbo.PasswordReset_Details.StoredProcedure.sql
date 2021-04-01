USE [HBSA]
GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='PasswordReset_Details')
	drop procedure PasswordReset_Details
GO
CREATE procedure PasswordReset_Details(
	@eMailAddress varchar(155),
	@TeamID int
) as

set nocount on
set xact_abort on

begin tran

--expire old resets requests
declare @expiry int
select @expiry = [value] from [Configuration] where [key] = 'PasswordResetExpiry'
delete PasswordResets
	where dateRequested < dateadd(hour,-@expiry, dbo.UKdateTime(getUTCdate()))

select *
	from PasswordResets
	where @eMailAddress = eMailAddress
	  and @TeamID       = TeamID

commit tran
GO
