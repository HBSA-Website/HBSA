USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDates_Initial]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetFixtureDates_Initial]
	(@SectionID int
	,@FirstDate date
	,@NoOfFixtures int
	)
as

declare @FixtureDate date
	   ,@WeekNo int
	   ,@CurfewStart date
       ,@CurfewEnd date
	   ,@SectionSize int
	
set @FixtureDate=@FirstDate

select @SectionSize=count(*) from Teams where SectionID=@SectionID

set @WeekNo = 1
select @CurfewStart= Startdate
      ,@CurfewEnd  = EndDate
	from FixtureDatesCurfew
	where SectionID=@SectionID

if @CurfewEnd < @CurfewStart
	set @CurfewEnd=dateadd(year,1,@CurfewEnd)

select top 0 * into #tempDates from FixtureDates
	
while @WeekNo <= @NoOfFixtures
	begin
	insert #tempDates 
		select @SectionID,@SectionSize,@WeekNo,@FixtureDate
	set @WeekNo=@WeekNo+1
	set @FixtureDate=dateadd(week,1,@FixtureDate)
	while @FixtureDate between @CurfewStart and @CurfewEnd
		set @FixtureDate=dateadd(week,1,@FixtureDate)
	end
select *
	from #tempDates
drop table #tempDates



GO
exec [GetFixtureDates_Initial] 4, '20 sep 2018', 26