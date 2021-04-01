select *
--Player=dbo.FullPlayerName(A.Forename,A.Initials,A.Surname),
--	   Team1=C.[Club Name]+' '+A.Team,A. LeagueID,
--	   Team2=D.[Club Name]+' '+B.Team,B.LeagueID

	from Players A
	join Players B on dbo.FullPlayerName(A.Forename,A.Initials,A.Surname) = dbo.FullPlayerName(B.Forename,B.Initials,B.Surname)
                  AND A.LeagueID = B.LeagueID
				  AND A.ID < B.id
	join Clubs C on C.ID=A.ClubID
	join Clubs D on D.ID=B.ClubID
	order by dbo.FullPlayerName(A.Forename,A.Initials,A.Surname)
