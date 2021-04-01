use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_ClubFee')
	drop procedure EntryForm_ClubFee
GO

create procedure EntryForm_ClubFee
	(@ClubID int
	)

as

Declare @EntryFormFee money

Select @EntryFormFee=Fee
	from  EntryForm_Fees
	where Entity='Club'

declare EntryFormFeeCursor cursor fast_forward for
	select EntryFormFee=count(*)*max(fee)
	from EntryForm_Teams
	join EntryForm_Fees on EntryForm_Teams.LeagueID=EntryForm_Fees.LeagueID
	where ClubID=@ClubID
	group by EntryForm_Teams.LeagueID

declare @fee money

open EntryFormFeeCursor

fetch EntryFormFeeCursor into @Fee
while @@FETCH_STATUS = 0
	begin
	set @EntryFormFee=@EntryFormFee+@Fee
	fetch EntryFormFeeCursor into @Fee
	end

close EntryFormFeeCursor

deallocate EntryFormFeeCursor

select @EntryFormFee

GO

exec EntryForm_ClubFee 43
