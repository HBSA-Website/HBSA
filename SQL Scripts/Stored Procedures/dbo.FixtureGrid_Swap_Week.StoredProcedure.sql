USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FixtureGrid_Swap_Week')
	DROP procedure FixtureGrid_Swap_Week
GO

create procedure FixtureGrid_Swap_Week
	(@SectionID int
	,@Week1 int
	,@Week2 int
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
	
	--swap the weeks in the 1st half
	update FixtureGrids
		set WeekNo=-1
		where SectionID=@SectionID and WeekNo=@Week2
	update FixtureGrids
		set WeekNo=@Week2
		where SectionID=@SectionID and WeekNo=@Week1
	update FixtureGrids
		set WeekNo=@Week1
		where SectionID=@SectionID and WeekNo=-1
	
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
		 and FixtureGridFirstHalf.weekNo=FixtureGridSecondHalf.weekNo-@MaxWeeks
	
		where FixtureGridSecondHalf.SectionID=@SectionID
		  and FixtureGridSecondHalf.WeekNo > @MaxWeeks

    commit tran

	end
GO

exec AssignFixtureGrid 10
exec FixtureGrid_Swap_Week 10,4,14,1
select * from FixtureGrids where SectionID=10 order by WeekNo
exec AssignFixtureGrid 10

