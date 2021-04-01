use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AssignFixtureGrids')
	drop procedure AssignFixtureGrids
GO

create procedure AssignFixtureGrids
	 @LeagueID int

as

set nocount on
set xact_abort on

--This routine calls the AssignFixtureGrid routine for each Section in a league

begin tran

Declare Sections_Cursor cursor fast_forward for
	select ID 
		from Sections
		where LeagueID=@LeagueID
declare @SectionID int

open Sections_Cursor

fetch Sections_Cursor into @SectionID

while @@FETCH_STATUS=0
	begin
	exec AssignFixtureGrid @SectionID
	fetch Sections_Cursor into @SectionID
	end

commit tran

GO
