USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsApplyFixtures')
	drop procedure JuniorsApplyFixtures
GO

create procedure JuniorsApplyFixtures

as

set nocount on
set xact_abort on

begin tran

truncate table JuniorResults

declare @NoDivs int
       ,@DivSize int
	   ,@EntryID int
	   ,@NoEntries int
	   ,@DivID int
select @NoDivs = max(Division), @EntryID=1, @DivID=1, @NoEntries=count(*) 
	from JuniorLeagues

create table #matrix 
	(WeekNo int
	,h1 int, a1 int,h2 int, a2 int,h3 int, a3 int,h4 int, a4 int,h5 int, a5 int,h6 int, a6 int,h7 int, a7 int,h8 int, a8 int)  
	
while @DivID <= @NoDivs
	begin
	select @DivSize = count(*) from JuniorLeagues where Division=@DivID
	if @DivSize > 16
		begin
		raiserror ('Cannot have a division with more than 16 players',17,17)
		return
		end
	truncate table #matrix
	insert #matrix
		exec GenerateFixtureMatrix @DivSize
	declare Matrix_cursor cursor fast_forward for
		select TOP ((select count(*) from #matrix)/2) * from #matrix
	declare @WeekNo int,@h1 int,@a1 int,@h2 int,@a2 int,@h3 int,@a3 int,@h4 int,@a4 int,@h5 int,@a5 int,@h6 int,@a6 int,@h7 int,@a7 int,@h8 int,@a8 int
	open Matrix_cursor
	fetch Matrix_cursor into @WeekNo,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8
	while @@FETCH_STATUS=0
		begin
		insert JuniorResults
			select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
				 from JuniorLeagues home
				 join JuniorLeagues away on away.FixtureID=@a1 and away.Division=@DivID
			     where home.FixtureID=@h1 and home.Division=@DivID
			if @DivSize > 2
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a2 and away.Division=@DivID
						 where home.FixtureID=@h2 and home.Division=@DivID
			if @DivSize > 4
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a3 and away.Division=@DivID
						 where home.FixtureID=@h3 and home.Division=@DivID
			if @DivSize > 6
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a4 and away.Division=@DivID
						 where home.FixtureID=@h4 and home.Division=@DivID
			if @DivSize > 8
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a5 and away.Division=@DivID
						 where home.FixtureID=@h5 and home.Division=@DivID
			if @DivSize > 10
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a6 and away.Division=@DivID
						 where home.FixtureID=@h6 and home.Division=@DivID
			if @DivSize > 12
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a7 and away.Division=@DivID
						 where home.FixtureID=@h7 and home.Division=@DivID
			if @DivSize > 14
				insert JuniorResults
					select @DivID, home.Entrant,away.Entrant,0,0,0,0,0,0
						 from JuniorLeagues home
						 join JuniorLeagues away on away.FixtureID=@a8 and away.Division=@DivID
						 where home.FixtureID=@h8 and home.Division=@DivID

		
		fetch Matrix_cursor into @WeekNo,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8
		end

		close Matrix_cursor
		deallocate Matrix_cursor


	set @DivID=@DivID+1
	end

drop table #matrix

commit tran

GO
exec JuniorsApplyFixtures
select * from JuniorResults Order by Division, HomePlayer, AwayPlayer