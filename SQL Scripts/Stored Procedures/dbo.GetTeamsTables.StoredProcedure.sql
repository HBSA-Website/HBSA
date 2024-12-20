use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetTeamsTables')
	drop procedure GetTeamsTables
GO

create procedure GetTeamsTables
	 @LeagueID int

as

set nocount on

declare @MaxFixtureNo int

select @MaxFixtureNo=max(FixtureNo) 
	from teams 
	cross apply (select LeagueID, [Section Name] from Sections where ID=SectionID)L 
	where LeagueID=@LeagueID 

declare @SQL1 varchar(2000)
set @SQL1='select * into #tmp1 from
	(select FixtureNo,[Section Name],TeamName=case when [Club Name] = ''Bye'' then ''Bye ('' + convert(varchar(5),ID) + '')'' else [Club Name] end + '' '' + Team 
	from teams
	cross apply (select LeagueID, [Section Name] from Sections where ID=SectionID)L
	cross apply (select [Club Name] from Clubs where ID=ClubID) C
	where LeagueID=' + convert(varchar(5),@LeagueID) + ') as src

pivot 
	(max(TeamName) 
		for [Section Name] in ('

declare @SQL2 varchar(2000)
set @SQL2='select * into #tmp2 from
	(select FixtureNo,SectionID,TeamID=ID
	from teams
	cross apply (select LeagueID, [Section Name] from Sections where ID=SectionID)L
	cross apply (select [Club Name] from Clubs where ID=ClubID) C
	where LeagueID=' + convert(varchar(5),@LeagueID) + ') as src

pivot 
	(max(TeamID) 
		for SectionID in ('

declare SectionsCursor cursor fast_forward for
	select ID, [Section Name] 
		from Sections
		where LeagueID=@LeagueID
declare @SectionID int
	   ,@SectionName varchar(50)

open SectionsCursor
fetch SectionsCursor into @SectionID, @SectionName

while @@fetch_status = 0
	begin
	set @sql1=@sql1 + '[' + @SectionName + '],'
	set @sql2=@sql2 + '[' + convert(varchar(2),@SectionID) + '],'
	fetch SectionsCursor into @SectionID, @SectionName
	end

close SectionsCursor
deallocate SectionsCursor

set @sql1=left(@sql1,len(@sql1)-1) + ')) as t
             insert #tmp1 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+1) + ')
             insert #tmp1 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+2) + ')
             insert #tmp1 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+3) + ')
             insert #tmp1 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+4) + ')
			 select * from #tmp1 order by abs(FixtureNo)
			 drop table #tmp1'
set @sql2=left(@sql2,len(@sql2)-1) + ')) as t
             insert #tmp2 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+1) + ')
             insert #tmp2 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+2) + ')
             insert #tmp2 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+3) + ')
             insert #tmp2 (FixtureNo) values (' + convert(varchar,@MaxFixtureNo+4) + ')
			 select * from #tmp2 order by abs(FixtureNo)
			 drop table #tmp2'

exec (@sql1) 
exec (@sql2)

GO


