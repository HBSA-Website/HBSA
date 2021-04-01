USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FixtureGrid_Move_Week')
	DROP procedure FixtureGrid_Move_Week
GO

create procedure FixtureGrid_Move_Week
	(@SectionID int
	,@Week1 int --the week that is to be moved
	,@Week2 int --where to move to (it will be immediately after this one)
	,@Unlocked bit
	)
as

set nocount on
set xact_abort on

declare @SectionSize int
select top 1 @SectionSize= SectionSize from FixtureGrids where sectionID = @SectionID
declare @MaxWeeks int
if @Unlocked = 1 
	set @MaxWeeks = (@SectionSize-1)*2
else
	set @MaxWeeks = @SectionSize-1
if @Week1 > @MaxWeeks
or @Week2 > @MaxWeeks
or @Week1 < 1
or @Week2 < 1
	raiserror('Invalid week number',15,1)
else
	begin	
	begin tran

	--update (only the first half if locked) to contain week numbers multiplied by 2 and negated
	update FixtureGrids
		set WeekNo = -(WeekNo*2)
		where SectionID = @SectionID 
		  and WeekNo < @MaxWeeks
    --update the week to move to the slot after the where to move week
	update FixtureGrids
		set WeekNo = -(@Week2*2) - 1
		where SectionID = @SectionID 
		  and WeekNo = -(@Week1*2)

	--Resequence the week numbers the 1st half of the grid
	select rowNo=ROW_NUMBER() over (order by WeekNo desc),SectionID,WeekNo
		into #tmp 
		from FixtureGrids
		where SectionID=@SectionID 
		  and WeekNo < 0
        order by Weekno desc
	merge FixtureGrids as target
		using (select SectionID,WeekNo, rowNo from #tmp) as source (SectionID, WeekNo, rowNo)
		on (target.SectionID = source.SectionID and
		    target.WeekNo    = source.WeekNo)
		when matched then
			update set WeekNo=rowNo
			;

	--if the 2nd half is locked then
		--having swapped the weeks in the 1st half, rebuild the 2nd half
	if @Unlocked <> 1
		update FixtureGridSecondHalf
			set h1=FixtureGridFirstHalf.a1, a1=FixtureGridFirstHalf.h1
		       ,h2=FixtureGridFirstHalf.a2, a2=FixtureGridFirstHalf.h2
		       ,h3=FixtureGridFirstHalf.a3, a3=FixtureGridFirstHalf.h3
		       ,h4=FixtureGridFirstHalf.a4, a4=FixtureGridFirstHalf.h4
		       ,h5=FixtureGridFirstHalf.a5, a5=FixtureGridFirstHalf.h5
		       ,h6=FixtureGridFirstHalf.a6, a6=FixtureGridFirstHalf.h6
		       ,h7=FixtureGridFirstHalf.a7, a7=FixtureGridFirstHalf.h7
		       ,h8=FixtureGridFirstHalf.a8, a8=FixtureGridFirstHalf.h8
	
		from FixtureGrids FixtureGridSecondHalf
		join FixtureGrids FixtureGridFirstHalf 
		  on FixtureGridSecondHalf.SectionID=FixtureGridFirstHalf.sectionID 
		 and FixtureGridFirstHalf.weekNo=FixtureGridSecondHalf.weekNo-13
	
		where FixtureGridSecondHalf.SectionID=10
		  and FixtureGridSecondHalf.WeekNo > 13

    commit tran

	end
GO

exec FixtureGrid_Move_Week 10,4,1,1
select * from FixtureGrids where SectionID=10 order by WeekNo


--exec AssignFixtureGrid 10