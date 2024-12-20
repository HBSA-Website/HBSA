USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Awards_lastSixMatchesWinners')
	drop procedure Awards_lastSixMatchesWinners
GO

CREATE procedure dbo.Awards_lastSixMatchesWinners

as

set nocount on
set xact_abort on

begin tran

declare @AwardType int
select @AwardType=AwardType 
	from Awards_Types 
	where StoredProcedureName = object_name(@@procid)

delete Awards where AwardType=5

declare @MaxPts int, @MaxWon int, @MaxDrawn int
declare @last6 table
	(TeamID int, LeagueID int, Won int, Drawn int, Lost int, Points int)

declare Leagues_Cursor cursor fast_forward for
	select ID from Leagues order by ID
declare @LeagueID int

open Leagues_Cursor
fetch Leagues_Cursor into @LeagueID
while @@FETCH_STATUS=0
	begin

	delete @Last6
	insert @Last6
		exec Awards_lastSixMatches @LeagueID

	select top 1 @MaxPts=Points,@MaxWon=won,@MaxDrawn=drawn
		from @last6 L
		  -- exclude any division/section winners
		  where teamID NOT in (select entrantID from Awards where AwardType=1 and subid=1 and LeagueID = @LeagueID) 
		order by Points desc, Won desc

	insert Awards
		select @AwardType
	      ,NULL
		  ,NULL
		  ,@LeagueID
		  ,teamID
		  ,NULL
		from @last6 L
		where @MaxPts=Points and @MaxWon=won and @MaxDrawn=drawn
		  -- exclude any division/section winners
		  and teamID NOT in (select entrantID from Awards where AwardType=1 and subid=1 and LeagueID = @LeagueID) 

	fetch Leagues_Cursor into @LeagueID

	end

close Leagues_Cursor
deallocate Leagues_Cursor

commit tran
GO

exec Awards_lastSixMatchesWinners
EXEC Awards_Report 5
