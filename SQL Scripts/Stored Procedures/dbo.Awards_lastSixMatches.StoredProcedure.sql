USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Awards_lastSixMatches')
	drop procedure Awards_lastSixMatches
GO

CREATE procedure dbo.Awards_lastSixMatches
	(@LeagueID int
	)
as

set nocount on

select R.ID
      ,MatchDate
	  ,HomeTeamID=H.ID
	  ,H_Pts= case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	          case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	          case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	          case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end
	  ,A_Pts= case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	          case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	          case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	          case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end
      ,AwayTeamID=A.ID
	  
into #temp
	
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	

	where l.ID=@LeagueID
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team

select ID, Matchdate, TeamID=HomeTeamID, Points=H_Pts 
	into  #temp2
	from #temp
insert into #temp2
	select ID, Matchdate, TeamID=AwayTeamID, Points=A_Pts 
	from #temp

select top 0 * into #temp3 from #temp2
declare MatchPoints_Cursor cursor fast_forward for
	select * from #temp2
		order by TeamID, MatchDate Desc
declare @prevID int
       ,@teamID int
	   ,@Points int
	   ,@accumPoints int
	   ,@counter int
	   ,@mDate date
	   ,@ID int

select @prevID=-1
	  ,@accumPoints=0
	  ,@counter=0

open MatchPoints_Cursor
fetch MatchPoints_Cursor into @ID, @mDate, @teamID, @Points
while @@fetch_status = 0
	begin
	if @teamID <> @previd
		begin
		set @prevID=@teamID
		select @counter=0
		end
	if @counter < 6 
		begin
		insert #temp3 select @ID, @mDate, @teamID, @Points
		set @counter = @counter + 1		
		end
	fetch MatchPoints_Cursor into @ID, @mDate, @teamID, @Points
	end

close MatchPoints_Cursor
deallocate MatchPoints_Cursor
if @counter < 6 
	insert #temp3 select @ID, @mDate, @teamID, @Points

declare @toWin int, @toDraw int, @toLose int

if @LeagueID=1
	select  @toWin=3, @toDraw=2, @toLose=1
else
	select  @toWin=2, @toDraw=-1, @toLose=1

declare @SQL1 varchar(1500)
       ,@SQL2 varchar(1500)
       ,@SQL3 varchar(1500)
       ,@SQL4 varchar(1500)
       ,@SQL5 varchar(1500)
       ,@SQL6 varchar(1500)
       ,@SQL7 varchar(1500)
       ,@SQL8 varchar(1500)
       ,@SQL9 varchar(1500)
       ,@SQL10 varchar(1500)
       ,@SQL11 varchar(1500)
       ,@SQL12 varchar(1500)
select  @SQL1  = ''
       ,@SQL2  = ''
       ,@SQL3  = ''
       ,@SQL4  = ''
       ,@SQL5  = ''
       ,@SQL6  = ''
       ,@SQL7  = ''
       ,@SQL8  = ''
       ,@SQL9  = ''
       ,@SQL10  = ''
       ,@SQL11 = ''
       ,@SQL12 = ''

declare dates_Cursor cursor fast_forward for
	select distinct matchdate from #temp3 order by matchdate 
declare @md date

set @SQL1='
select   TeamID
        ,LeagueID=' + convert(varchar,@LeagueID) + '
		,Won =
'
set @SQL3 = '
		,Drawn =
'
set @SQL5 = '
		,Lost =
'
set @SQL8 = '
		,Points=
'
set @SQL10 = '
	from (select #temp3.TeamID, LeagueID, MatchDate, Points from #temp3 join teams on teamID=teams.ID join sections on sectionID=sections.id) as src
	pivot (sum(Points) 
			for matchDate in
			    ('
set @SQL12 = '
				)
		 ) as pvt

	order by points desc, Won desc, drawn desc'

open dates_Cursor
fetch dates_Cursor into @md
while @@FETCH_STATUS=0
	begin
	set @SQL2 = @SQL2 + '
			      case when isnull([' + convert(varchar(11),@md,106) + '],0) >= ' + convert(varchar,@toWin) + ' then 1 else 0 end +'
	set @SQL4 = @SQL4 + '
			      case when isnull([' + convert(varchar(11),@md,106) + '],0) = ' + convert(varchar,@toDraw) + ' then 1 else 0 end +'
	set @SQL6 = @SQL6 + '
			      case when [' + convert(varchar(11),@md,106) + '] <= ' + convert(varchar,@toLose) + ' then 1 else 0 end +'
	
--	set @SQL7 = @SQL7 + '
--		,[' + convert(varchar(11),@md,106) + ']'		
	set @SQL9 = @SQL9 + '
			      isnull([' + convert(varchar(11),@md,106) + '],0) +'
	set @SQL11 = @SQL11 + '
				 [' + convert(varchar(11),@md,106) + '],'

	fetch dates_Cursor into @md
	end

close dates_Cursor
deallocate dates_Cursor

set @SQL2 = left (@SQL2, len(@SQL2)-1)
set @SQL4 = left (@SQL4, len(@SQL4)-1)
set @SQL6 = left (@SQL6, len(@SQL6)-1)
set @SQL9 = left (@SQL9, len(@SQL9)-1)
set @SQL11= left (@SQL11, len(@SQL11)-1)
exec (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL8 + @SQL9 + @SQL10 + @SQL11 + @SQL12)


drop table #temp
drop table #temp2
drop table #temp3

GO

exec Awards_lastSixMatches 2
select * from teams join clubs on Clubs.id=clubid where teams.id=262


