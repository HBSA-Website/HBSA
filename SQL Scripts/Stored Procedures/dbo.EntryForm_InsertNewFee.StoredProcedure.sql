use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_InsertNewFee')
	drop procedure EntryForm_InsertNewFee
GO

create procedure EntryForm_InsertNewFee
	(@Entity varchar(16)
	,@LeagueID int
	,@Fee money
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

Insert EntryForm_Fees
	VALUES (@Entity,@LeagueID,@Fee)

insert ActivityLog
	select dbo.UKdateTime(getUTCdate()),'EntryForm Fee ' + @Entity + ' inserted',@LeagueID,@user

commit tran
GO
exec EntryForm_InsertNewFee 'Club',0,25.00,'PeterG'
select * from ActivityLog order by dtLodged desc
select * from EntryForm_Fees

