	select [Dup Player]  = AP1.Player
	      ,[1st Partner] = AP2.Player
	      ,[2nd Partner] = BP1.Player

		from Competitions_EntryForms A
		join Competitions_EntryForms B
          on A.CompetitionID=B.CompetitionID and A.EntrantID=B.Entrant2ID

        cross apply (select Player = dbo.FullPlayerName(Forename,Initials,Surname) + ' (' + [Club Name] + ')'
						from Players 
						cross apply (select [Club Name] from Clubs where ID=ClubID) C
						where ID=A.EntrantID) AP1
        cross apply (select Player = dbo.FullPlayerName(Forename,Initials,Surname) + ' (' + [Club Name] + ')' 
						from Players 
						cross apply (select [Club Name] from Clubs where ID=ClubID) C
						where ID=A.Entrant2ID) AP2
		cross apply (select Player = dbo.FullPlayerName(Forename,Initials,Surname) + ' (' + [Club Name] + ')' 
						from Players 
						cross apply (select [Club Name] from Clubs where ID=ClubID) C
						where ID=B.EntrantID) BP1
		

		where A.CompetitionID=3
