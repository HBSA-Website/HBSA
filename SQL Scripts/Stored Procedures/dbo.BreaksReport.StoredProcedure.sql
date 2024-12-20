USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'BreaksReport')
	drop procedure BreaksReport
GO

create procedure BreaksReport
	(@LeagueID int
	)
as	

set nocount on

select	 PlayerID,Name= Forename + case when Initials = '' then ' ' else ' ' + Initials + '. ' end + Surname
		,PlayerDetails.LeagueID, Leagues.[League Name]
		,Handicap = 
		 case when PlayerID=HomePlayer1ID then HomeHandicap1
		      when PlayerID=HomePlayer2ID then HomeHandicap2
		      when PlayerID=HomePlayer3ID then HomeHandicap3
		      when PlayerID=HomePlayer4ID then HomeHandicap4
		      when PlayerID=AwayPlayer1ID then AwayHandicap1
		      when PlayerID=AwayPlayer2ID then AwayHandicap2
		      when PlayerID=AwayPlayer3ID then AwayHandicap3
		      when PlayerID=AwayPlayer4ID then AwayHandicap4
		      --else matchresultid
		 end     
		,[Break], Category=BreaksCategories.ID
		--,*
	into #tempBreaks	
	from Breaks
         join PlayerDetails on PlayerDetails.ID=PlayerID
         join MatchResults on MatchResults.ID=MatchResultID
         join Leagues on Leagues.ID = LeagueID
         join BreaksCategories on BreaksCategories.[LeagueID]=PlayerDetails.LeagueID and Handicap between LowHandicap and HighHandicap
         
    where PlayerDetails.LeagueID=@LeagueID

select *, [Type]='Std'	
	into #tempBreaks2
	from #tempBreaks    

declare HighestBreaks cursor fast_forward for
	select [Name]=isnull([name],''),[Break]=isnull([Break],''),Category=bc.id,LeagueID= @LeagueID,[League Name]=(select [League Name] from Leagues where id=@LeagueID)
		from BreaksCategories bc
		outer apply (select tb.Name,tb.[Break],Category=tb.Category
						from #tempBreaks tb
						join (select [Break]=MAX([Break]),Category
									from #tempBreaks
									group by Category) MB
						  on tb.[Break] = MB.[Break]		
						 and tb.Category=MB.Category
						 where tb.Category=bc.id
					)hb 
			 where bc.leagueid=@LeagueID
			 order by ID 

declare @hbName varchar(250),@hbBreak int, @hbCategory int, @hbLeagueID int, @hbLeagueName varchar(50)
declare @prevBreak int, @prevCategory int, @prevPlayer varchar(250)
set @prevBreak = -1 set @prevCategory = -1
open HighestBreaks
fetch HighestBreaks into @hbName, @hbBreak, @hbCategory, @hbLeagueID, @hbLeagueName
while @@FETCH_STATUS=0
	begin
	if @prevCategory=@hbCategory and @prevBreak=@hbBreak
		set @prevPlayer=@prevPlayer + ', ' + @hbName
	else
		begin
		if @prevPlayer is not null
			insert #tempBreaks2
				select 	0, 'Highest break (' + @prevPlayer + ')', @hbLeagueID, @hbLeagueName, 0, @prevBreak, @prevCategory, 'Top'	
		select @prevPlayer=@hbName, @prevCategory=@hbCategory, @prevBreak=@hbBreak
		end	
	fetch HighestBreaks into @hbName, @hbBreak, @hbCategory, @hbLeagueID, @hbLeagueName
	end

if @prevPlayer is not null
	insert #tempBreaks2
		select 	0, 'Highest break (' + @prevPlayer + ')', @hbLeagueID, @hbLeagueName, 0, @prevBreak, @prevCategory, 'Top'

close HighestBreaks
deallocate HighestBreaks

create table #BreaksReport
	(ID int identity (1,1)
	)

declare CategoriesCursor cursor fast_forward for
	select ID, Category=convert(varchar,LowHandicap) + ' to ' + convert(varchar,HighHandicap)
	 from BreaksCategories where LeagueID=@LeagueID 

declare @CategoryID int, @Category	varchar(50)
declare @SQL varchar (2000)
declare @selectSQL varchar(2000)
set @selectSQL='select '

open CategoriesCursor
fetch CategoriesCursor into @CategoryID,@Category
while @@FETCH_STATUS=0
	begin
	set @SQL = 
		'alter table #BreaksReport
			add [Player ' + @Category +  '] varchar(120), [Breaks ' + @Category + '] varchar(2000)'
	exec (@SQL)	
	--print @SQL

	set @selectSQL = @selectSQL + 
		'[' + case when left(@category,len(convert(varchar(15),dbo.MinimumInteger()))) = convert(varchar(15),dbo.MinimumInteger())
				       then right (@Category, len(@Category) - len(convert(varchar(15),dbo.MinimumInteger())) - 4) + ' down'
				   when right(@category,len(convert(varchar(15),dbo.MaximumInteger()))) = convert(varchar(15),dbo.MaximumInteger())
				       then left (@Category, len(@Category) - len(convert(varchar(15),dbo.MaximumInteger())) - 4) + ' up'
				else @Category
	           end
		 + '] = [Player ' + @Category +  '], Breaks = [Breaks ' + @Category + '],' 

	declare BreaksCursor cursor fast_forward for
	select PlayerID, Name, [Break]
		from #tempBreaks2
		where Category=@CategoryID
		order by Category,[Type] Desc,Name,playerid

	declare @prevPlayerID int
		   ,@prevName varchar(120)
	       ,@PlayerID int
		   ,@Name varchar(120)
		   ,@Break int
	       ,@Breaks varchar(2000)
	       ,@RecID int
       
	open BreaksCursor
	select @prevPlayerID=-1,@prevName=''

	fetch BreaksCursor into @PlayerID,@name,@Break
	set @RecID=1
	while @@fetch_status=0
		begin
		if @PlayerID <> @prevPlayerID
			begin
			if @prevPlayerID <> -1
				begin
				if (select ID from #BreaksReport where ID=@RecID) is not null
					set @SQL = 
						'update #BreaksReport 
							set [Player ' +  + @Category +  ']=''' + replace(@prevName,'''','''''') + ''' 
							   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
							where ID=' + CONVERT(varchar,@RecID)
				else 
					set @SQL = 
						'insert #BreaksReport
							([Player ' +  + @Category +  ']
			                ,[Breaks ' + @Category + ']) 
				         VALUES
							(''' + replace(@prevName,'''','''''') + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

				exec (@SQL)
				
				set @RecID = @RecID + 1
				end
			select @prevPlayerID=@PlayerID,@prevName=@Name, @Breaks=convert(varchar,@Break)+', '
			end
		else
			select @Breaks = @Breaks+convert(varchar,@Break)+', '
	
		fetch BreaksCursor into @PlayerID,@name,@Break
		end

		if (select ID from #BreaksReport where ID=@RecID) is not null
			set @SQL = 
				'update #BreaksReport 
					set [Player ' +  + @Category +  ']=''' + replace(@prevName,'''','''''') + ''' 
					   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
					where ID=' + CONVERT(varchar,@RecID)
		else 
			set @SQL = 
				'insert #BreaksReport
					([Player ' +  + @Category +  ']
		            ,[Breaks ' + @Category + ']) 
		         VALUES
					(''' + replace(@prevName,'''','''''') + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

		exec (@SQL)
		--print @SQL
	close BreaksCursor
	deallocate BreaksCursor

	fetch CategoriesCursor into @CategoryID,@Category

	end

close CategoriesCursor
deallocate CategoriesCursor

set @selectSQL = left(@selectSQL,len(@selectSQL)-1) + '
	from #BreaksReport'
--print(@selectSQL)	
exec(@selectSQL)	
--select * from #BreaksReport
drop table #tempBreaks	
drop table #tempBreaks2
drop table #BreaksReport


GO
exec BreaksReport 3