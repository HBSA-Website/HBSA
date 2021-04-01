use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_UpdateFee')
	drop procedure EntryForm_UpdateFee
GO

create procedure EntryForm_UpdateFee
	(@Entity varchar(16)
	,@LeagueID int
	,@Fee money
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

update EntryForm_Fees
	Set Fee = @Fee
	where Entity = @Entity
	  and isnull(LeagueID,0) = isnull(@LeagueID,0)

insert ActivityLog
	select dbo.UKdateTime(getUTCdate())
	     ,'EntryForm Fee Updated ' + @Entity + ' ' + convert(varchar,@Fee)
		 ,@LeagueID,@user

commit tran
GO
exec EntryForm_UpdateFee 'Club',0,25.00,'PeterG'
select * from ActivityLog order by dtLodged desc
select * from EntryForm_Fees

