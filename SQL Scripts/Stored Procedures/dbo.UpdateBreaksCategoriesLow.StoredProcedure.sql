USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateBreaksCategoriesLow')
	drop procedure UpdateBreaksCategoriesLow
GO

create procedure dbo.UpdateBreaksCategoriesLow
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

declare @atFirst bit
	   ,@atLast bit
select @atFirst = case when min(ID)=@ID then 1 else 0 end from BreaksCategories where LeagueID=@LeagueID
select @atLast = case when max(ID)=@ID then 1 else 0 end from BreaksCategories where LeagueID=@LeagueID

If @atFirst = 0 and @Handicap=dbo.MinimumInteger()
		begin
		if @@trancount > 0
			rollback transaction;
		raiserror('ERROR: Cannot set the LowHandicap to No Limit for other than the first category for this league',17,0)
		return
		end

Declare @LowHCap int
--prevent low handicap being less that league limit
select @LowHCap = MinHandicap from Leagues where ID=@LeagueID
if @Handicap >= @LowHCap
	Set @LowHCap=@Handicap
else --warning
	raiserror('WARNING: Low handicap changed to the league limit',10,0)

	if @atFirst = 0
		begin --update the previous high handicap as 1 less than this low handicap
		update BreaksCategories
			set HighHandicap=@LowHCap - 1
			where ID=@ID-1
		end

	--update the category low handicap
	update BreaksCategories
		set LowHandicap=@LowHCap
		where ID=@ID

	If (select HighHandicap from BreaksCategories where ID=@ID) < @LowHCAP
		begin
		update BreaksCategories
			set HighHandicap=@LowHCap+1
			where ID=@ID
		if @atLast = 0
			update BreaksCategories
				set LowHandicap=@LowHCap+2
				where ID=@ID+1
		 end
	
	commit tran

GO
--exec UpdateBreaksCategoriesLow 2, 6, -2147483648

--
select * from BreaksCategories where LeagueID=1
exec UpdateBreaksCategoriesLow 1,1,-2147483648
select * from BreaksCategories where LeagueID=1
--select * from Leagues
select dbo.MinimumInteger()