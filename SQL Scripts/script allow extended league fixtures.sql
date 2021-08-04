USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'checkResultsForWrongTeams')
	drop procedure checkResultsForWrongTeams
GO

CREATE procedure [dbo].[checkResultsForWrongTeams]

as

set nocount on

declare @SectionID int
declare @Fixtures table (MatchDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)
select @SectionID =  MIN(ID) from sections
while @SectionID <= (select max(ID) from sections)
	begin
	Insert @Fixtures
		exec FixtureDatesBySection @SectionID 
	set @SectionID = @SectionID + 1
	end

select R.MatchDate,L.[League Name],S.[Section Name],
       [Home Team]=HC.[Club Name]+' '+HT.Team, --HT.ID,HT.FixtureNo,
       [Away Team]=AC.[Club Name]+' '+AT.Team ,--AT.ID,AT.FixtureNo,
       case when FR.MatchDate IS null 
				then case when FD.MatchDate IS not null
								then 'Possible wrong match date'
								else ''
				     end		   		 
				else 'Wrong home team' end as Comment,
       R.ID
	from MatchResults R
	join Teams HT on R.HomeTeamID=HT.ID
		Join Clubs HC on HT.ClubID=HC.ID 
	join Teams AT on R.AwayTeamID=AT.ID
		Join Clubs AC on AT.ClubID=AC.ID     
	join Sections S on S.ID=HT.SectionID 
	join Leagues L on L.ID=S.LeagueID 

	left join @Fixtures	F
	       on F.MatchDate=R.MatchDate
	      and F.HomeFixtureNo=HT.FixtureNo
	      and F.AwayFixtureNo=AT.FixtureNo
	      and F.SectionID=HT.SectionID
    
    left join @Fixtures FR
	       on FR.MatchDate=R.MatchDate
	      and FR.HomeFixtureNo=AT.FixtureNo
	      and FR.AwayFixtureNo=HT.FixtureNo
	      and FR.SectionID=HT.SectionID
    
    left join @Fixtures FD
	       on FD.HomeFixtureNo=HT.FixtureNo
	      and FD.AwayFixtureNo=AT.FixtureNo
	      and FD.SectionID=HT.SectionID
    
	where F.HomeFixtureNo is null       


GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixtureMatrix')
	drop procedure FixtureMatrix
GO

create procedure [dbo].[FixtureMatrix] 
	 @SectionID int
as

set nocount on

declare @SectionSize int
select @SectionSize=count(*)/2 from Teams where SectionID=@SectionID
declare @SQL varchar(4000)
set @SQL='
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=' + convert(varchar,@SectionID) + '
select [Date]=convert(varchar(11),FixtureDate,113)'
declare @ix int
set @ix=0
while @ix < @SectionSize  
	begin
    set @ix=@ix+1  
	set @SQL=@SQL + '
      ,[' + CHAR(@ix+96) + '] = convert(varchar,h' + convert(varchar,@ix) + ')+'' v ''+convert(varchar,a' + convert(varchar,@ix) + ')'
    end  
set @SQL=@SQL + '      
from FixtureGrids M
join FixtureDates D
  on D.SectionID=' + convert(varchar,@SectionID) + '
 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then 18 else D.WeekNo % @MatrixSize end
where M.SectionID=' + convert(varchar,@SectionID) + '
order by FixtureDate'
exec (@SQL)

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetFixturesSideBySide')
	drop procedure GetFixturesSideBySide
GO
create procedure GetFixturesSideBySide
	@SectionID int

as

create table #Grid
	(RowNo int identity (1,1)
	,FixtureDate date
	)
create table #Teams
	(FixtureNo int
	,Club varchar(400)
	,ClubTelNo varchar(20)
	,TeamTelNo varchar(20)
	,Players varchar(1000)
	)

declare @NoMatchesPerWeek int
select @NoMatchesPerWeek = count(*)/2 from Teams where SectionID=@SectionID
declare @MatchNo int
	   ,@SQL varchar(1000)
set @MatchNo = 0
while @MatchNo < @NoMatchesPerWeek
	begin
	Set @MatchNo=@MatchNo+1
	set @SQL = 
		'alter table #Grid add [' + convert(varchar,@MatchNo) + '] varchar(7)'
	exec (@SQL)
	end

insert #Grid
	exec FixtureMatrix @SectionID
insert #Teams
	exec SectionList @SectionID,null,1
	
select G.*, [ ]=' ', T.* 
	INTO #workTable
	from #Grid G
	left join #Teams T
	  on RowNo=FixtureNo	

alter table #workTable
	drop column RowNo

select * from #workTable

drop table #Grid 
drop table #Teams
drop table #workTable 

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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixturesByLeague')
	drop procedure dbo.FixturesByLeague
GO

create procedure dbo.FixturesByLeague
	(@LeagueID int 
	,@FixtureDate date = NULL
	,@TeamName varchar(100) = NULL
	)
as

set nocount on	

declare @sT table (Fixture_Date varchar(11),HomeTeam varchar(100),AwayTeam varchar(100))
declare @lT table (Fixture_Date varchar(11),HomeTeam varchar(100),AwayTeam varchar(100),Section varchar(100))

declare SectionIDsCursor cursor for
	select ID from Sections where LeagueID=@LeagueID
	order by ID
declare @SectionID int
open SectionIDsCursor
fetch SectionIDsCursor into @SectionID
while @@fetch_status=0
	begin	
	delete from @sT
	insert @sT
		exec FixturesBySection @SectionID,@FixtureDate,@TeamName,1  
	insert @lT 
	    select Fixture_Date, HomeTeam,AwayTeam ,Section 
			from @sT
			cross apply (select Section= [League Name] + ' ' + [Section Name]
				             from Leagues 
					         cross apply (select [Section Name] from Sections where ID=@SectionID) S
						     where ID=@LeagueID
				        ) L
		                 
	fetch SectionIDsCursor into @SectionID
	end

close SectionIDsCursor
deallocate SectionIDsCursor	

select [Fixture Date]=case when Fixture_Date='' then '' else convert(varchar(11),convert(date,Fixture_Date),113) end,HomeTeam,AwayTeam,Section
	 from @lT	
	
select [Fixture Date]=Convert(varchar(11),FixtureDate,113) 
	from FixtureDates 
	where sectionID=(select top 1 ID from Sections where LeagueID=@LeagueID)
	order by FixtureDate

select Distinct Team=HomeTeam 
	from @lT 
	where Fixture_Date <> '' 
	  and HomeTeam <> '' 
	  and Hometeam <> 'Bye'
	order by HomeTeam


GO
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

declare @Fixtures table (MatchDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare c cursor for
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
	   ,@h8 int,@a8 int, @MatchDate date
open c
fetch c into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @MatchDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @Fixtures values (@MatchDate, @h1, @a1, @sid)
	if not @h2 is null insert @Fixtures values (@MatchDate, @h2, @a2, @sid)
	if not @h3 is null insert @Fixtures values (@MatchDate, @h3, @a3, @sid)
	if not @h4 is null insert @Fixtures values (@MatchDate, @h4, @a4, @sid)
	if not @h5 is null insert @Fixtures values (@MatchDate, @h5, @a5, @sid)
	if not @h6 is null insert @Fixtures values (@MatchDate, @h6, @a6, @sid)
	if not @h7 is null insert @Fixtures values (@MatchDate, @h7, @a7, @sid)
	if not @h8 is null insert @Fixtures values (@MatchDate, @h8, @a8, @sid)
	fetch c into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @MatchDate
	end
close c
deallocate c

select * 
	from @Fixtures
GO
If exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetFixtureDates')
	drop procedure dbo.GetFixtureDates
GO

CREATE procedure [dbo].[GetFixtureDates] 
	 @TeamID int
as

set nocount on

declare @StartYear int
       ,@SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID
select top 1 
	@StartYear=datepart(Year,FixtureDate) 
	from FixtureDates 
	where SectionID=@SectionID
	order by FixtureDate

declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID

select D.WeekNo, [Date]=convert(varchar(11),FixtureDate,113)
      ,AwayTeamID=A.ID, AwayTeam=C.[Club Name] + ' ' + A.Team
	  ,HalfWay=convert(bit,case when FixtureDate > (select Fixturedate from FixtureDates where SectionID=@SectionID and weekNo = SectionSize-1) then 1 else 0 end)
	from Teams T
	
	Join FixtureGrids G
	  on G.SectionID=T.SectionID
	  
	join FixtureDates D
		on D.SectionID = @SectionID
	   and case when D.WeekNo % @MatrixSize = 0 then @MatrixSize else D.WeekNo % @MatrixSize end=G.WeekNo  
	   
	join Teams A --AwayTeam
	  on A.SectionID=T.SectionID
	 and A.FixtureNo=case when h1=T.FixtureNo then a1   
	                      when h2=T.FixtureNo then a2
	                      when h3=T.FixtureNo then a3
	                      when h4=T.FixtureNo then a4
	                      when h5=T.FixtureNo then a5
	                      when h6=T.FixtureNo then a6
	                      when h7=T.FixtureNo then a7
	                      when h8=T.FixtureNo then a8
	                 end     
   	 join Clubs C
   	   on C.ID=A.ClubID 
   	   
	where T.ID=@TeamID
	  and   ((h1 = T.FixtureNo and a1 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h2 = T.FixtureNo and a2 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h3 = T.FixtureNo and a3 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h4 = T.FixtureNo and a4 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h5 = T.FixtureNo and a5 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h6 = T.FixtureNo and a6 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h7 = T.FixtureNo and a7 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h8 = T.FixtureNo and a8 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) )	         

	order by D.WeekNo

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetFixtures')
	drop procedure GetFixtures
GO
create procedure GetFixtures
	@SectionID int

as
	
exec FixtureMatrix @SectionID
exec SectionList @SectionID,null,1

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
		 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then 18 else D.WeekNo % @MatrixSize end
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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetAwayTeam')
	drop procedure GetAwayTeam
GO

CREATE procedure [dbo].[GetAwayTeam]
	(@Weekno int
	,@SectionID int
	,@HomeTeamID int
	)
as

set nocount on

declare @HomeFixtureNo int
	select @HomeFixtureNo = FixtureNo from Teams where ID=@HomeTeamID
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare @AwayFixtureNo int
	select @AwayFixtureNo =
	case when h1 = @HomeFixtureNo then a1
	     when h2 = @HomeFixtureNo then a2
	     when h3 = @HomeFixtureNo then a3
	     when h4 = @HomeFixtureNo then a4
	     when h5 = @HomeFixtureNo then a5
	     when h6 = @HomeFixtureNo then a6
	     when h7 = @HomeFixtureNo then a7
	     when h8 = @HomeFixtureNo then a8
	end     
	     
from FixtureGrids
where SectionID=@SectionID
  and WeekNo=case when @Weekno  % @MatrixSize = 0 then 18 else @Weekno % @MatrixSize end

declare @AwayTeamID int
select @AwayTeamID = ID from Teams where SectionID = @SectionID and FixtureNo=@AwayFixtureNo 

exec TeamDetails @AwayTeamID

GO
