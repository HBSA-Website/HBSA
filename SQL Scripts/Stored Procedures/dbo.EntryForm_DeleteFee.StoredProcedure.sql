use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_DeleteFee')
	drop procedure EntryForm_DeleteFee
GO

create procedure EntryForm_DeleteFee
	(@Entity varchar(16)
	,@LeagueID int
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

delete EntryForm_Fees
	where Entity = @Entity
	  and isnull(LeagueID,0) = isnull(@LeagueID,0)

insert ActivityLog
	select dbo.UKdateTime(getUTCdate())
	     ,'EntryForm Fee Deleted ' + @Entity 
		 ,@LeagueID,@user

commit tran
GO
exec EntryForm_DeleteFee 'Club',null,'PeterG'
select * from ActivityLog order by dtLodged desc
SELECT * FROM EntryForm_Fees
