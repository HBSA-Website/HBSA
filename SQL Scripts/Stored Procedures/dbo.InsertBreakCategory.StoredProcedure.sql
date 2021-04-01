USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertBreakCategory')
	drop procedure InsertBreakCategory
GO

create procedure dbo.InsertBreakCategory
	-- insert a new break category record below the indicated one.
	(@LeagueID int
	,@ID int
	)
as	

set nocount on
set xact_abort on

begin tran

if @LeagueID <> (select top 1 LeagueID from BreaksCategories where ID=@ID)
	begin
	raiserror('LeagueID does not match Break Category ID',17,0)
	if @@TRANCOUNT>0
		rollback tran
	return
	end

create table #tempCategories
	(LeagueID int
	,LowHandicap int
	,HighHandicap int
	,ID int
	)
insert #tempCategories
	select * from BreaksCategories

insert #tempCategories
	select @LeagueID, HighHandicap ,HighHandicap, NULL
		 from BreaksCategories 
		 where ID = @ID

truncate table BreaksCategories
insert BreaksCategories
	(LeagueID, LowHandicap, HighHandicap)
	select LeagueID, LowHandicap, HighHandicap 
		from #tempCategories
		order by LeagueID, LowHandicap, HighHandicap

drop table #tempCategories

commit tran

GO

select * from BreaksCategories
exec InsertBreakCategory 1,1
--exec InsertBreakCategory 1,5 select * from BreaksCategories
--exec InsertBreakCategory 2,6 select * from BreaksCategories
--exec InsertBreakCategory 3,10 select * from BreaksCategories

