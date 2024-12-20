USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'TeamResultsSheet')
	drop procedure TeamResultsSheet
GO

CREATE procedure TeamResultsSheet
	@TeamID int

as


set nocount on

declare @Matches table
	(ID	int
	,MatchDate date
	,Home varchar(55)
	,hFrames int
	,aFrames int
	,Away varchar(55)
	,FixtureDate date
	)
insert @Matches exec listMatches @TeamID

declare @HomeTeam varchar(55) 
select @HomeTeam=[Club Name] + ' ' + Team
	from Teams
	cross apply (select [Club Name] from Clubs where id=ClubID) x
	where ID=@TeamID 

create table #TeamResults
	(ID int
	,MatchDate date
	,Opposition varchar(55)
	,[v] char (1)
	,Result varchar(10)
	,[For] int
	,[Agn] int
	)

insert #TeamResults
	select
		 ID, MatchDate
		,case when Home = @HomeTeam then Away else Home end
		,case when Home = @HomeTeam then 'H' else 'A' end
		,case when case when Home = @HomeTeam then hFrames else aFrames end > case when Home = @HomeTeam then aFrames else hFrames end then 'Win' 
		      when case when Home = @HomeTeam then hFrames else aFrames end < case when Home = @HomeTeam then aFrames else hFrames end then 'Lose' 
		                                                                                                                               else 'Draw'
         end		                                                                                                                                
		,case when Home = @HomeTeam then hFrames else aFrames end
		,case when Home = @HomeTeam then aFrames else hFrames end 
	from @Matches

declare @Players table (Player varchar(55))	
insert @Players
	select	Player= Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end
		from MatchResultsDetails 
		where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
order by 	Player

declare cPlayers cursor fast_forward for
	select Player=Replace(Player,'''','`') 
		from @Players
		where Player is not null

open cPlayers
declare  @Player varchar(55)
		,@SQL varchar(8000)
		,@selectSQL varchar(8000)
		,@dataSQL varchar(8000)
		,@total1SQL varchar (8000)
        ,@total2SQL varchar (8000)
        ,@total3SQL varchar (8000)
        ,@total4SQL varchar (8000)
        ,@total5SQL varchar (8000)
       

set @total1SQL='insert #TeamResults
select Null,null,null,null,''Points'',null,null'
set @total2SQL='insert #TeamResults
select Null,null,null,null,''Frames'',null,null'
set @total3SQL='insert #TeamResults
select Null,null,null,null,''Avg Points'',null,null'
set @total4SQL='insert #TeamResults
select Null,null,null,null,''% Points'',null,null'
set @total5SQL='insert #TeamResults
select Null,null,null,null,Result=''% Frames'',null,null'

set @selectSQL = 
'select	 MatchDate = convert(varchar(11),Matchdate,113)
		,Opposition
		,[v] 
		,Result = Result + case when [For] is not null then '' '' + Convert(char(2),[For]) + Convert(char(2),[Agn]) else '''' end'
set @dataSQL = 
'select	 MatchDate = convert(varchar(11),Matchdate,113)
		,Opposition
		,[v] 
		,Result
		,[For]
		,[Agn]'

fetch cPlayers into @Player
while @@fetch_status=0
	begin
	set @SQL = 
			'alter table #TeamResults add [' + @Player + ' F] int, [' + @Player + ' A] int'
	exec (@SQL)		
	set @selectSQL=@selectSQL + '
		,[' + @Player + ']=convert(varchar,[' + @Player + ' F]) + '' - '' + convert(varchar,[' + @Player + ' A])'
	
	set @dataSQL=@dataSQL + '
		,[' + @Player + ' F], [' + @Player + ' A]'

	set @total1SQL=@total1SQL + '
		, sum([' + @Player + ' F]), sum([' + @Player + ' A])'
	set @total2SQL=@total2SQL + '
		, sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end)
        , sum(case when [' + @Player + ' F]<[' + @Player + ' A] then 1 else 0 end)'
	set @total3SQL=@total3SQL + '
		, convert(int,sum([' + @Player + ' F])/count([' + @Player + ' F]))
        , convert(int,sum([' + @Player + ' A])/count([' + @Player + ' A]))'
	set @total4SQL=@total4SQL + '
		, (sum([' + @Player + ' F]) * 100)/(sum([' + @Player + ' F]) + sum([' + @Player + ' A]))
        , 100-(sum([' + @Player + ' F]) * 100)/(sum([' + @Player + ' F]) + sum([' + @Player + ' A]))'
	set @total5SQL=@total5SQL + '
		, round(sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end) * 100/count([' + @Player + ' F]),2)
        , 100-round(sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end) * 100/count([' + @Player + ' A]),2)'
    
	fetch cPlayers into @Player
	end
close cPlayers
deallocate cPlayers
set @selectSQL=@selectSQL + '
	from #TeamResults'
set @dataSQL=@dataSQL + '
	from #TeamResults'
set @total1SQL=@total1SQL + '
	from #TeamResults where ID is not null'
set @total2SQL=@total2SQL + '
	from #TeamResults where ID is not null'
set @total3SQL=@total3SQL + '
	from #TeamResults where ID is not null'
set @total4SQL=@total4SQL + '
	from #TeamResults where ID is not null'
set @total5SQL=@total5SQL + '
	from #TeamResults where ID is not null'

declare cMatches cursor fast_forward for
	select ID from #TeamResults
declare @ID int

declare   @Player1 varchar(55)
		 ,@Player1ScoreFor int
		 ,@Player1ScoreAgn int
		 ,@Player2 varchar(55)
		 ,@Player2ScoreFor int
		 ,@Player2ScoreAgn int
		 ,@Player3 varchar(55)
		 ,@Player3ScoreFor int
		 ,@Player3ScoreAgn int
		 ,@Player4 varchar(55)
		 ,@Player4ScoreFor int
		 ,@Player4ScoreAgn int

open 	cMatches
fetch cMatches into @ID
while @@fetch_status=0
	begin
	
	select
		  @Player1 = replace(case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end,'''','`')
		 ,@Player1ScoreFor = case when HomeTeamID=@TeamID then HomePlayer1Score else AwayPlayer1Score end 
		 ,@Player1ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer1Score else HomePlayer1Score end 
		 ,@Player2 = replace(case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end,'''','`')
		 ,@Player2ScoreFor = case when HomeTeamID=@TeamID then HomePlayer2Score else AwayPlayer2Score end 
		 ,@Player2ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer2Score else HomePlayer2Score end 
		 ,@Player3 = replace(case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end,'''','`')
		 ,@Player3ScoreFor = case when HomeTeamID=@TeamID then HomePlayer3Score else AwayPlayer3Score end 
		 ,@Player3ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer3Score else HomePlayer3Score end 
		 ,@Player4 = replace(case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end,'''','`')
		 ,@Player4ScoreFor = case when HomeTeamID=@TeamID then HomePlayer4Score else AwayPlayer4Score end 
		 ,@Player4ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer4Score else HomePlayer4Score end 
	
		from MatchResultsDetails where ID=@ID

/*
update #teamresults set 
			 [No Show F] = isnull([No Show F],0) + 0
		    ,[No Show A] = 1
			,[No Show F] = 0
		    ,[No Show A] = 1
			,[No Show F] = 0
		    ,[No Show A] = 1
*/
	set @SQL =
	'update #teamresults set 
			[' + @Player1 + ' F] = isnull([' + @Player1 + ' F],0) + ' + convert(varchar,@Player1ScoreFor) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	set @SQL =
	'update #teamresults set 
		    [' + @Player1 + ' A] = isnull([' + @Player1 + ' A],0) + ' + convert(varchar,@Player1ScoreAgn) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	set @SQL =
	'update #teamresults set 
			[' + @Player2 + ' F] = isnull([' + @Player2 + ' F],0) + ' + convert(varchar,@Player2ScoreFor) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	set @SQL =
	'update #teamresults set 
		    [' + @Player2 + ' A] = isnull([' + @Player2 + ' A],0) + ' + convert(varchar,@Player2ScoreAgn) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	set @SQL =
	'update #teamresults set 
			[' + @Player3 + ' F] = isnull([' + @Player3 + ' F],0) + ' + convert(varchar,@Player3ScoreFor) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	set @SQL =
	'update #teamresults set 
		    [' + @Player3 + ' A] = isnull([' + @Player3 + ' A],0) + ' + convert(varchar,@Player3ScoreAgn) + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	if @Player4 is not null	  
		begin  
		set @SQL =
		'update #teamresults set 
				[' + @Player4 + ' F] = isnull([' + @Player4 + ' F],0) + ' + convert(varchar,@Player4ScoreFor) + '
			where ID = ' + convert(varchar,@ID)   
		exec (@SQL)
		set @SQL =
		'update #teamresults set 
			    [' + @Player4 + ' A] = isnull([' + @Player4 + ' A],0) + ' + convert(varchar,@Player4ScoreAgn) + '
			where ID = ' + convert(varchar,@ID)   
		exec (@SQL)
			end
	
	fetch cMatches into @ID
	end
close cMatches
deallocate cMatches	

--Points analysis
select Played= count(Matchdate)
      ,Won= sum(case when Result='Win' then 1 else 0 end)
      ,Drawn=sum(case when Result='Draw' then 1 else 0 end)
      ,Lost=sum(case when Result='Lose' then 1 else 0 end)
	  ,Points=sum([For])
	from #TeamResults

--Get player analyses
insert #TeamResults (ID) values (null)
exec (@total1SQL)
exec (@total2SQL)
exec (@total3SQL)
exec (@total4SQL)
exec (@total5SQL)

--print @selectSQL
exec (@selectSQL) 

--Raw data for use by program
exec (@dataSQL)

drop table #TeamResults



GO
