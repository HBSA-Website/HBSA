USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[TeamResultsSheet]    Script Date: 12/02/2013 19:07:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[TeamResultsSheet] 
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
	,Result char(4)
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
declare @Player varchar(55)
declare @SQL varchar(4000)
declare @selectSQL varchar(4000)
declare @total1SQL varchar (2000)
       ,@total2SQL varchar (2000)
       ,@total3SQL varchar (2000)
       ,@total4SQL varchar (2000)
       ,@total5SQL varchar (2000)
       

set @total1SQL='
select Null,null,null,null,''Points'''
set @total2SQL='
select Null,null,null,null,''Frames'''
set @total3SQL='
select Null,null,null,null,''Avg Points'''
set @total4SQL='
select Null,null,null,null,''% Points'''
set @total5SQL='
select Null,null,null,null,Result=''% Frames'''

set @selectSQL = 
'select	 MatchDate = convert(varchar(11),Matchdate,113)
		,Opposition
		,[v] 
		,Result = Result + '' '' + Convert(char(2),[For]) + Convert(char(2),[Agn])'

fetch cPlayers into @Player
while @@fetch_status=0
	begin
	set @SQL = 
			'alter table #TeamResults add [' + @Player + ' F] int, [' + @Player + ' A] int'
	exec (@SQL)		
	set @selectSQL=@selectSQL + '
		,[' + @Player + ']=convert(varchar,[' + @Player + ' F]) + '' - '' + convert(varchar,[' + @Player + ' A])'

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

set @total1SQL=@total1SQL + '
	from #TeamResults'
set @total2SQL=@total2SQL + '
	from #TeamResults'
set @total3SQL=@total3SQL + '
	from #TeamResults'
set @total4SQL=@total4SQL + '
	from #TeamResults'
set @total5SQL=@total5SQL + '
	from #TeamResults'

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

	set @SQL =
	'update #teamresults set 
			 [' + @Player1 + ' F] = ' + convert(varchar,@Player1ScoreFor) + '
		    ,[' + @Player1 + ' A] = ' + convert(varchar,@Player1ScoreAgn) + '
			,[' + @Player2 + ' F] = ' + convert(varchar,@Player2ScoreFor) + '
		    ,[' + @Player2 + ' A] = ' + convert(varchar,@Player2ScoreAgn) + '
			,[' + @Player3 + ' F] = ' + convert(varchar,@Player3ScoreFor) + '
		    ,[' + @Player3 + ' A] = ' + convert(varchar,@Player3ScoreAgn)
	if @Player4 is not null	    
		set @SQL=@SQL + '
			,[' + @Player4 + ' F] = ' + convert(varchar,@Player4ScoreFor) + '
		    ,[' + @Player4 + ' A] = ' + convert(varchar,@Player4ScoreAgn)
		
	set @SQL=@SQL + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	fetch cMatches into @ID
	end
close cMatches
deallocate cMatches	
--print @selectSQL
exec (@selectSQL) 

exec (@total5SQL+'
union '+@total4SQL+'
union '+@total3SQL+'
union '+@total2SQL+'
union '+@total1SQL + ' order by Result desc')
	
drop table #TeamResults
go
exec TeamResultsSheet 27