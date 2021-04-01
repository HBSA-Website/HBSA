select p.Forename,p.initials,p.surname,handicap,[Club Name],Team,[League Name],[Section Name],id
	from PlayerDetails p
	join
	(select Forename,initials,surname,LeagueID
		from Players 
		group by Forename,initials,surname,LeagueID
		having count(*) > 1) d
	  on p.Forename=d.Forename
	 and p.Initials=d.Initials
	 and p.Surname=d.Surname
	 and p.LeagueID=d.LeagueID
	 order by p.LeagueID,p.surname,p.Forename,p.initials
--delete Players where id in (1055,1056)