USE [HBSA]
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

exec GetFixturesSideBySide 10
