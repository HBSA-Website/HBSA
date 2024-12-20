USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixturesBySection')
	drop procedure dbo.FixturesBySection
GO

CREATE procedure dbo.FixturesBySection
	(@SectionID int 
	,@FixtureDate date = NULL
	,@TeamName varchar(100) = NULL
	,@FixturesOnly bit = 0
	)
as

set nocount on	

declare @t table (mDate date, Home int, Away int, ID int identity)
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare FixtureListCursor cursor for
	select M.SectionID,M.SectionSize,D.WeekNo,
	   h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8, 
	   FixtureDate
		from FixtureDates D
		left join FixtureGrids M
		  on M.SectionID=@SectionID
		 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then @MatrixSize else D.WeekNo % @MatrixSize end
	 where D.SectionID=@SectionID 
	 order by D.WeekNo
	 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @mDate date
open FixtureListCursor
fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @t values (@mDate, @h1, @a1)
	if not @h2 is null insert @t values (@mDate, @h2, @a2)
	if not @h3 is null insert @t values (@mDate, @h3, @a3)
	if not @h4 is null insert @t values (@mDate, @h4, @a4)
	if not @h5 is null insert @t values (@mDate, @h5, @a5)
	if not @h6 is null insert @t values (@mDate, @h6, @a6)
	if not @h7 is null insert @t values (@mDate, @h7, @a7)
	if not @h8 is null insert @t values (@mDate, @h8, @a8)
	fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
	end
close FixtureListCursor
deallocate FixtureListCursor

select [Fixture Date]=T.mDate, 
       [Home Team]=HC.[Club Name] + ' ' + H.Team, -- + case when H.Contact='WITHDRAWN' then ' (WITHDRAWN)' else '' end, 
       [Away Team]=AC.[Club Name] + ' ' + A.Team, -- + case when A.Contact='WITHDRAWN' then ' (WITHDRAWN)' else '' end, 
	   T.ID
	into #tmp	
	from @t T
	join Teams H on H.FixtureNo=T.Home and H.SectionID=@SectionID
		join Clubs HC on HC.ID=H.ClubID
	join Teams A on A.FixtureNo=T.Away  and A.SectionID=@SectionID
		join Clubs AC on AC.ID=A.ClubID
	order by T.ID

declare FixturesCursor cursor for 
	select [Fixture Date], [Home Team],[Away Team] 
		from #tmp 
		where [Fixture Date] = isnull(@FixtureDate,[Fixture Date])
		  and NOT ([Home Team]='Bye' and [Away Team]='Bye')
		  and ([Home Team] = @TeamName or [Away Team] = @TeamName or @TeamName is null)
		order by ID 

declare @Fixture_Date varchar(11), @HomeTeam varchar(100), @AwayTeam varchar(100)
declare @fT table (Fixture_Date varchar(11), HomeTeam varchar(100), AwayTeam varchar(100), ID int identity (1,1)) 
declare @pDate date
open FixturesCursor
fetch FixturesCursor into @Fixture_Date, @HomeTeam, @AwayTeam
while @@FETCH_STATUS=0
	begin
	if ISNULL(@pDate,'1/1/80') = @Fixture_Date
		insert @fT values ('',@HomeTeam,@AwayTeam)
	else
		begin
		if @pDate is not null
			if @TeamName is null 
				insert @fT values ('','','')
		insert @fT values (@Fixture_Date,@HomeTeam,@AwayTeam)
		set @pDate=@Fixture_Date
		end
	fetch FixturesCursor into @Fixture_Date, @HomeTeam, @AwayTeam
	end
close FixturesCursor
deallocate FixturesCursor

select [Fixture Date]=case when Fixture_Date='' then ''
                      else convert(varchar(11),convert(date,Fixture_Date),113) end
	  ,HomeTeam,AwayTeam from @fT where HomeTeam <> 'Bye' or AwayTeam<>'Bye' order by ID 

if @FixturesOnly=0
	begin
	select [Fixture Date]=Convert(varchar(11),FixtureDate,113) 
		from FixtureDates 
		where sectionID=@SectionID
		order by FixtureDate
	
	select Distinct Team=HomeTeam 
		from @fT 
		where Fixture_Date <> ''
		 and HomeTeam <> ''
		 and HomeTeam <> 'Bye'
		order by HomeTeam
	end



GO

exec FixturesBySection 1,'16 dec 2021',null,1
exec FixturesBySection 1,'7 apr 2022',null,1