USE HBSA
GO
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DownloadHandicaps')
	drop procedure dbo.DownloadHandicaps
go

create procedure dbo.DownloadHandicaps
as

set nocount on

	declare @Players table (Player varchar(100))

		
declare @WinLosses table 
	(FirstDateLodged date
	,PlayerID int
	,Player varchar(106)
	,League varchar(50)
	,Handicap int
	,WinLose tinyint
	)
		 	
insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer1ID
		,HomePlayer1
		,[League Name]
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = HomePlayer1ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where HomePlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer2ID
		,HomePlayer2
		,[League Name]
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = HomePlayer2ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where HomePlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer3ID
		,HomePlayer3
		,[League Name]
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = HomePlayer3ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where HomePlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer4ID
		,HomePlayer4
		,[League Name]
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = HomePlayer4ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where HomePlayer4ID > 0 and AwayPlayer4ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer1ID
		,AwayPlayer1
		,[League Name]
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = AwayPlayer1ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where AwayPlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer2ID
		,AwayPlayer2
		,[League Name]
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = AwayPlayer2ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where AwayPlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer3ID
		,AwayPlayer3
		,[League Name]
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = AwayPlayer3ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where AwayPlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer4ID
		,AwayPlayer4
		,[League Name]
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails6
	cross apply (select SectionID from Players where ID = AwayPlayer4ID) S
	cross apply (select LeagueID from Sections where ID = SectionID) S2
	cross apply (select [League Name] from Leagues where ID = LeagueID) L
	where AwayPlayer4ID > 0 and AwayPlayer4ID > 0
--select * from @WinLosses
select PlayerID, Player, League, Handicap, DateFrom=min(FirstDateLodged)
      ,Played=count(Winlose)
	  ,Won=sum(Winlose)
	  ,lost=count(Winlose) - sum(Winlose)
	into #tmp
	from @WinLosses
	group by PlayerID, Player, League, Handicap
	order by PlayerID, DateFrom

select PlayerID, Player
	  ,Tag = dbo.TagDescription(Tagged)
	  ,League
	  ,[From] = convert(varchar(11), DateFrom, 113)
      ,Handicap
      ,Played
	  ,Won
	  ,Lost=Played - won
	from #tmp T
	cross apply (select Tagged from Players where ID = T.PlayerID) Tag
	where dateFrom =
			(select max(Datefrom) from #tmp where PlayerID = T.PlayerID)
	order by League, Player

drop table #tmp

GO
exec DownloadHandicaps
