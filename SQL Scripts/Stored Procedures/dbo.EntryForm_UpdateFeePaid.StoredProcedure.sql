use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_UpdateFeePaid')
	drop procedure EntryForm_UpdateFeePaid
GO

create procedure EntryForm_UpdateFeePaid
	(@ClubID int
	,@Amount decimal
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

update EntryForm_Clubs
	set FeePaid = case when FeePaid = 1 then 0 else 1 end
	where ClubID=@ClubID

insert ActivityLog
	select dbo.UKdateTime(getUTCdate()),'EntryForm Feepaid Changed',@ClubID,@user

commit tran
GO
exec EntryForm_UpdateFeePaid 43,12.9, 'Pete'
