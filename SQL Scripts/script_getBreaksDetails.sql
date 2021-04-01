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
         
    where PlayerDetails.LeagueID=1

select PlayerID=0, Name, LeagueID, [League Name],Handicap,[Break]=MAX([Break]),Category,[Type]='Top'
	into #tempBreaks2
	from #tempBreaks
    where [Break]=(select MAX([break]) from #tempBreaks)
    group by PlayerID, Name, LeagueID, [League Name],Handicap,Category
insert #tempBreaks2
select *, [Type]='Std'
	from #tempBreaks    

select * from #tempBreaks2	
	order by Category,[Type] Desc,Name,playerid

select PlayerID, Name, [Break]
	from #tempBreaks2
	where Category=1
	order by Category,[Type] Desc,Name,playerid

create table #BreaksReport
	(Name1 varchar (110)
	,Breaks1 varchar(1000)
	)
declare c cursor fast_forward for
select PlayerID, Name, [Break]
	from #tempBreaks2
	where Category=1
	order by Category,[Type] Desc,Name,playerid
open c
close c
deallocate c
drop table #tempBreaks	
drop table #tempBreaks2
drop table #BreaksReport

select *, Category=case when LowHandicap < 0 then '(-)' else '(+)' end + convert(varchar,abs(LowHandicap)) + ' to ' +
                   case when HighHandicap < 0 then '(-)' else '(+)' end + convert(varchar,abs(HighHandicap))
	from BreaksCategories where LeagueID=1