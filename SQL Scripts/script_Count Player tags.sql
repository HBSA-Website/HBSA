use hbsa
go
select Tag = dbo.TagDescription(tagged) , [Total] = count(*)
	from players
	where id > 0
	  and sectionID > 0
	  and played = 1
	group by tagged
	order by tagged
select Tag = dbo.TagDescription(tagged) , [League Name], [Count] = count(*)
	from players
	join Leagues on Leagues.ID = LeagueID
	where players.ID > 0
	  and sectionID > 0
	  and played = 1
	group by tagged, [League Name]
	order by [League Name], tagged