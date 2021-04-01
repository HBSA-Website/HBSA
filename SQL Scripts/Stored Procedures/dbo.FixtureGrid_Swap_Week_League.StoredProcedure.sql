USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FixtureGrid_Swap_Week_League')
	DROP procedure FixtureGrid_Swap_Week_League
GO

create procedure FixtureGrid_Swap_Week_League
	(@LeagueID int
	,@Week1 int
	,@Week2 int
	,@Unlocked bit
	)
as

set nocount on
set xact_abort on

declare @SectionID int
declare SectionsCursor cursor fast_forward for
	select ID from Sections where LeagueID=@LeagueID

open SectionsCursor
fetch SectionsCursor into @SectionID
while @@fetch_status=0
	begin
	exec FixtureGrid_Swap_Week @SectionID, @Week1, @Week2, @Unlocked
	fetch SectionsCursor into @SectionID
	end

close SectionsCursor
deallocate SectionsCursor

GO

exec FixtureGrid_Swap_Week_League 1,11,12,0