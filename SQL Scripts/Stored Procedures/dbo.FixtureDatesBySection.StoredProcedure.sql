USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[FixtureDatesBySection]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FixtureDatesBySection')
	drop procedure [dbo].[FixtureDatesBySection] 
GO

CREATE procedure [dbo].[FixtureDatesBySection] 
	(@SectionID int 
	)
as

set nocount on	

declare @SectionSize int
select @SectionSize=count(*) from Teams where SectionID=@SectionID

declare @Fixtures table (FixtureDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare FixturesCursor cursor for
	select M.SectionID,M.SectionSize,D.WeekNo,
	   h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8, 
	   FixtureDate
		from FixtureDates D
		left join FixtureGrids M
		  on M.SectionID=D.SectionID --@SectionID
		 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then @MatrixSize else D.WeekNo % @MatrixSize end
	 where D.SectionID=@SectionID or @SectionID=0
	 order by D.WeekNo
 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @FixtureDate date
open FixturesCursor
fetch FixturesCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @FixtureDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @Fixtures values (@FixtureDate, @h1, @a1, @sid)
	if not @h2 is null insert @Fixtures values (@FixtureDate, @h2, @a2, @sid)
	if not @h3 is null insert @Fixtures values (@FixtureDate, @h3, @a3, @sid)
	if not @h4 is null insert @Fixtures values (@FixtureDate, @h4, @a4, @sid)
	if not @h5 is null insert @Fixtures values (@FixtureDate, @h5, @a5, @sid)
	if not @h6 is null insert @Fixtures values (@FixtureDate, @h6, @a6, @sid)
	if not @h7 is null insert @Fixtures values (@FixtureDate, @h7, @a7, @sid)
	if not @h8 is null insert @Fixtures values (@FixtureDate, @h8, @a8, @sid)
	fetch FixturesCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @FixtureDate
	end
close FixturesCursor
deallocate FixturesCursor

select F.* , HomeTeamID=H.ID, AwayteamID=A.ID
	from @Fixtures F
	cross apply (Select ID from Teams where SectionID=F.SectionID and F.HomeFixtureNo=FixtureNo) H 
	cross apply (Select ID from Teams where SectionID=F.SectionID and F.AwayFixtureNo=FixtureNo) A
	order by SectionID, FixtureDate
GO
exec FixtureDatesBySection 1
exec FixtureDatesBySection 2

