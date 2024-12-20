USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateBreaksCategoriesHigh')
	drop procedure UpdateBreaksCategoriesHigh
GO

create procedure dbo.UpdateBreaksCategoriesHigh
	(@LeagueID int
	,@ID int
	,@Handicap int
	)
as	

set nocount on
set xact_abort on

begin tran

if @LeagueID <> (select top 1 LeagueID from BreaksCategories where ID=@ID)
	begin
	raiserror('ERROR: LeagueID does not match Break Category ID',17,0)
	if @@TRANCOUNT>0
		rollback tran
	return
	end

Declare @HighHCap int
--prevent High handicap being higher than league limit
select @HighHCap = MaxHandicap from Leagues where ID=@LeagueID
if @Handicap <= @HighHCap
	Set @HighHCap=@Handicap
else --warning
	raiserror('WARNING: High handicap changed to the league limit',10,0)

If @HighHCap < (Select LowHandicap from BreaksCategories where ID=@ID)
	begin
	raiserror('ERROR: Cannot set High handicap less than the Low Handicap',17,0)
	if @@TRANCOUNT>0
		rollback tran
	return
	end

--update the category High handicap
update BreaksCategories
	set HighHandicap=@HighHCap
	where ID=@ID

commit tran

GO
--exec UpdateBreaksCategoriesHigh 3, 10, 2147483647
--exec UpdateBreaksCategoriesHigh 1, 6, -25

--select * from BreaksCategories where LeagueID=3
select x=dbo.MaximumInteger()
