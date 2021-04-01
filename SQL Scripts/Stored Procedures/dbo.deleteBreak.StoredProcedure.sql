USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteBreak')
	drop procedure DeleteBreak
GO

CREATE procedure DeleteBreak
	(@BreakID int
	,@UserID varchar(255) = ''
	)
as

set nocount on
set xact_abort on

begin tran

insert Breaks_Deleted
	select * from Breaks where ID = @BreakID
delete Breaks
	where ID = @BreakID
	
insert ActivityLog values
	(dbo.UKdateTime(getUTCdate()),'delete Match Break',@BreakID,@UserID)  

commit tran

GO

--exec DeleteBreak 13,'pete'
--select * from Breaks_Deleted
--select * from breaks where ID=13
--select * from ActivityLog order by dtLodged desc
