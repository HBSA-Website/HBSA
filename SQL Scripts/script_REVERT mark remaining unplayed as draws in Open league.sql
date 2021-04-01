--revert -- mark all remaining matches as draws for the season


--select MatchResults.MatchDate,[Section Name],HomeClub.[Club Name],HomeTeam.Team, 
--                                             AwayClub.[Club Name],AwayTeam.Team,*
delete MatchResults

	from MatchResults
         join Teams HomeTeam on HomeTeamID=HomeTeam.id
		 join Teams AwayTeam on AwayTeamID=AwayTeam.ID
		 Join Clubs HomeClub on HomeTeam.ClubID=HomeClub.ID 
		 Join Clubs AwayClub on AwayTeam.ClubID=AwayClub.ID 
		 Join Sections on HomeTeam.SectionID = Sections.ID
		 where HomePlayer1ID=-2
		   and AwayPlayer1ID=-1
		   and HomePlayer2ID=-2
		   and AwayPlayer2ID=-1
		   and HomePlayer3ID=-1
		   and AwayPlayer3ID=-2
		   and HomePlayer4ID=-1
		   and AwayPlayer4ID=-2
		   --and MatchDate < '16 mar 2020'
		   and HomeTeam.SectionID between 1 and 6
		   and UserId = 'PeteG'

--order by MatchResults.matchdate