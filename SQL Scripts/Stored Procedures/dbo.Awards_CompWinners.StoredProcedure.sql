if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_CompWinners')
	drop procedure dbo.Awards_CompWinners
GO

create procedure dbo.Awards_CompWinners

as

set nocount ON
set xact_abort on

declare @CompetitionID int
	   ,@CompType int
	   ,@LeagueID int
	   ,@NoRounds int

declare  @EntrantID int
        ,@Entrant2ID int
        ,@Winner int
		,@RunnerUp int
		,@Semi1 int
		,@Semi2 int

begin tran

delete Awards where AwardType=2

declare CompsCursor cursor fast_forward for
	select ID, LeagueID, NoRounds, CompType 
		from Competitions 
		order by ID

open CompsCursor
fetch CompsCursor into @CompetitionID, @LeagueID, @NoRounds, @CompType
while @@FETCH_STATUS = 0
	begin

	if exists(select EntrantID from Competitions_Entries where CompetitionID=@CompetitionID and RoundNo=@NoRounds)
	begin

	select @winner=null,@RunnerUp=null,@Semi1=null,@Semi2=null

	declare c Cursor fast_forward for
		select EntrantID, Entrant2ID 
			from Competitions_Entries
			where CompetitionID=@CompetitionID and roundNo >= @NoRounds -2
			order by RoundNo desc

	open c
	fetch c into @EntrantID, @Entrant2ID
	while @@FETCH_STATUS=0
		begin
		if @winner is null
			begin
			set @Winner=@EntrantID
				insert Awards
					select 2
						,@CompetitionID
						,1
						,LeagueID=@LeagueID
						,@EntrantID
						,@Entrant2ID
			end
		else
		    begin
			if @RunnerUp is null
				begin
				if @EntrantID <> @Winner
					begin
					set @RunnerUp=@EntrantID
					insert Awards
						select 2
							  ,@CompetitionID
							  ,2
							  ,LeagueID=@LeagueID
							  ,@EntrantID
							  ,@Entrant2ID
					end
				end
			else
				begin
				if @Semi1 is null
					begin
					if @EntrantID <> @winner and @EntrantID <> @RunnerUp 
						begin
						set @Semi1 = @EntrantID
						insert Awards
							select 2
								  ,@CompetitionID
								  ,3
								  ,LeagueID=@LeagueID
								  ,@EntrantID
								  ,@Entrant2ID
						end
					end
	            else
					begin
					if @EntrantID <> @winner and @EntrantID <> @RunnerUp and @EntrantID <> @Semi1
						begin
						set @Semi2 = @EntrantID
						insert Awards
							select 2
								  ,@CompetitionID
								  ,4
								  ,LeagueID=@LeagueID
								  ,@EntrantID
								  ,@Entrant2ID
						end
		            end
				end
	        end
	
	fetch c into @EntrantID, @Entrant2ID
		
	end
	
	close c
	deallocate c

	end

	fetch CompsCursor into @CompetitionID, @LeagueID, @NoRounds, @CompType
	end

close CompsCursor
deallocate CompsCursor

commit tran

GO

exec Awards_CompWinners
exec awards_Report 2


