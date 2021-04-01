USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteBreakCategory')
	drop procedure DeleteBreakCategory
GO

create procedure dbo.DeleteBreakCategory
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

Declare @atFirst bit
	   ,@atLast bit
select @atFirst = case when min(ID)=@ID then 1 else 0 end from BreaksCategories where LeagueID=@LeagueID
select @atLast = case when max(ID)=@ID then 1 else 0 end from BreaksCategories where LeagueID=@LeagueID

if @atFirst = 1 and @atLast = 1
	begin
	raiserror('Cannot delete the only entry for a league',17,0)
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

If @atLast = 1
	begin
	update #tempCategories
		set HighHandicap = (select HighHandicap from BreaksCategories where ID=@ID)
		where ID=@ID-1
	end
else
	begin
	update #tempCategories
		set LowHandicap = (select LowHandicap from BreaksCategories where ID=@ID)
		where ID=@ID+1
	end

delete #tempCategories
	where ID=@ID

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
exec DeleteBreakCategory 1,1
--exec DeleteBreakCategory 1,5 
--exec DeleteBreakCategory 2,6 
--exec DeleteBreakCategory 3,8
select * from BreaksCategories

truncate table BreaksCategories
set identity_insert BreaksCategories on
insert BreaksCategories
	(LeagueID, LowHandicap, HighHandicap, ID)
	select * 
		from saveBC
		order by LeagueID, LowHandicap, HighHandicap
set identity_insert BreaksCategories off
