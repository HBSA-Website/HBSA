--show player records for those with handicap changes during the season
select P.* 
	from (select LeagueId, Player, Season from PlayerRecords group by LeagueID, Player, season having count(*) > 1) T
	cross apply (select * from PlayerRecords where LeagueID=T.LeagueID and Player = T.Player and Season=T.season) P 
	order by LeagueID, Player, season
