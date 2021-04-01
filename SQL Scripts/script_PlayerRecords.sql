declare @WinLosses table (MatchDate date, PlayerID int, Player varchar(106), Handicap int, WinLose tinyint)
insert @WinLosses
	select
		 MatchDate
		,HomePlayer1ID
		,HomePlayer1
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer2ID
		,HomePlayer2
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer3ID
		,HomePlayer3
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer4ID
		,HomePlayer4
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer4ID <> 0 and AwayPlayer4ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer1ID
		,AwayPlayer1
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer2ID
		,AwayPlayer2
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer3ID
		,AwayPlayer3
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer4ID
		,AwayPlayer4
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer4ID <> 0 and AwayPlayer4ID <> 0

--select * from @WinLosses where Player='Adam Harper'

--select Matchdate
--      ,Section=[League Name] + ' ' + [Section Name]
--      ,Team=[Club Name] + ' ' + Team
--      ,Player
--      ,Handicap
--      ,Tagged
--      ,Over70
--      ,WinLose
      
--	from @WinLosses
--	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team from Players where ID=PlayerID) p
--	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
--	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
--	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c
--	order by SectionID, [Club Name] + ' ' + Team, Player

select [Effective Date]=min(Matchdate)
      ,Section=max([League Name] + ' ' + [Section Name])
      ,Team=[Club Name] + ' ' + Team
      ,Player
      ,Handicap
      ,Tagged=max(convert(tinyint,Tagged))
      ,Over70=max(convert(tinyint,Over70))
      ,Played=count(WinLose)
      ,Won=sum(WinLose)
      ,Lost=count(WinLose)-sum(WinLose)
      
	from @WinLosses
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team from Players where ID=PlayerID) p
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c

	where Tagged = 1
	
	group by SectionID, [Club Name] + ' ' + Team, Player, Handicap

	order by SectionID, [Club Name] + ' ' + Team, Player