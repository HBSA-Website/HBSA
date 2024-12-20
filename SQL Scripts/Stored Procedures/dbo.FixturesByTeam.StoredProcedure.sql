USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixturesByTeam')
	drop procedure FixturesByTeam
GO


CREATE procedure FixturesByTeam
	(@LeagueSectionID int 
	,@TeamName varchar(100)
	)
as

set nocount on	

declare @SectionID int

if @LeagueSectionID > 99
	select @SectionID=Teams.SectionID
		from teams
		join Clubs on [Club Name] = left(@teamName,Len([Club Name]))
		          and SectionID in (Select ID from Sections where LeagueID=@LeagueSectionID-100)
		where ClubID = Clubs.ID 
		  and team   = case when [Club Name]=@TeamName then '' else right(@teamName,1) end
else
	set @SectionID = @LeagueSectionID

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
	 --where M.SectionID in (case when @sectionID>99 then (select ID from Sections where LeagueID=@SectionID-100)
	 --                                             else @SectionID
		--				   end)						   
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

select [Match Date]=T.mDate, 
       [Home Team]=HC.[Club Name] + ' ' + H.Team, 
       [Away Team]=AC.[Club Name] + ' ' + A.Team
	into #tmp	
	from @t T
	join Teams H on H.FixtureNo=T.Home and H.SectionID=@SectionID
		join Clubs HC on HC.ID=H.ClubID
	join Teams A on A.FixtureNo=T.Away  and A.SectionID=@SectionID
		join Clubs AC on AC.ID=A.ClubID
	order by T.ID

declare FixturesCursor cursor for 
	select * 
		from #tmp 
		where NOT ([Home Team]='Bye' and [Away Team]='Bye')
		  and ([Home Team] = @TeamName or [Away Team] = @TeamName or @TeamName is null)

declare @MatchDate date, @HomeTeam varchar(100), @AwayTeam varchar(100)
declare @fT table (MatchDate date, HomeTeam varchar(100), AwayTeam varchar(100))
declare @pDate date
open FixturesCursor
fetch FixturesCursor into @MatchDate, @HomeTeam, @AwayTeam
while @@FETCH_STATUS=0
	begin
	if ISNULL(@pDate,'1/1/80') = @MatchDate
		insert @fT values ('',@HomeTeam,@AwayTeam)
	else
		begin
		if @pDate is not null
			if @TeamName is null 
				insert @fT values ('','','')
		insert @fT values (@MatchDate,@HomeTeam,@AwayTeam)
		set @pDate=@MatchDate
		end
	fetch FixturesCursor into @MatchDate, @HomeTeam, @AwayTeam
	end
close FixturesCursor
deallocate FixturesCursor

if @LeagueSectionID > 99
	select     Section=(select [League Name] + ' ' + [Section Name] from Sections join Leagues on Leagues.ID=LeagueID where Sections.ID=@SectionID	)
			  ,FixtureDate=convert(varchar(11),MatchDate,113)
			  ,Venue=case when HomeTeam=@TeamName then 'Home' else 'Away' end
			  ,Opponent=case when HomeTeam=@TeamName then AwayTeam else HomeTeam end 
	    from @fT 
		where HomeTeam <> 'Bye' or AwayTeam<>'Bye' 
		order by Matchdate
else
	select     FixtureDate=convert(varchar(11),Convert(date,MatchDate),113)
			  ,Venue=case when HomeTeam=@TeamName then 'Home' else 'Away' end
			  ,Opponent=case when HomeTeam=@TeamName then AwayTeam else HomeTeam end 
	    from @fT 
		where HomeTeam <> 'Bye' or AwayTeam<>'Bye' 
		order by Matchdate

GO

exec FixturesByTeam 10, 'Levels A'