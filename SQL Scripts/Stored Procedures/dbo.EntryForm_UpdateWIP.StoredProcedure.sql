use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_UpdateWIP')
	drop procedure EntryForm_UpdateWIP
GO

create procedure [dbo].[EntryForm_UpdateWIP]
	(@ClubID int
	,@WIP int = 1  -- 0 = Untouched - from Clubs table
	               -- 1 = In progress - i.e. being prepared by user
				   -- 2 = Submitted - i.e. prepared & submitted by a user
				   -- 3 = Fixed - i.e. accepted by HBSA and not changeable
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

update EntryForm_Clubs
	set WIP = @WIP
	where ClubID=@ClubID

insert ActivityLog
	select dbo.UKdateTime(getUTCdate()),'EntryForm WIP Change to ' + convert(varchar,@WIP),@ClubID,@user

commit tran

