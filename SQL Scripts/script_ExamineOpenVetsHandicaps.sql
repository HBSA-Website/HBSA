select [Open Name] = dbo.FullPlayerName(O.Forename,O.Initials,O.Surname)
	  ,[Open Handicap]=O.Handicap
	  ,[Open Club Name] = OC.[Club Name]
      ,[Vets Name] = dbo.FullPlayerName(V.Forename,V.Initials,V.Surname) 
	  ,[Vets Handicap] = V.Handicap
	  ,[Vets Club Name] = VC.[Club Name]
	  ,[Handicap Difference]= O.Handicap-V.Handicap
	  ,[Played]=V.Played
	from Players O
	join Players V
	  on V.leagueid=2
	 and O.surname=V.surname
	 and (   O.forename = V.forename 
	      or O.Forename like (V.Forename + '%')
		  or V.Forename like (O.Forename + '%')
		 )
	 --and O.ClubID = V.ClubID
	 and V.Handicap > -40
	join Clubs OC
	  on O.ClubID = OC.ID
	join Clubs VC
	  on V.ClubID = VC.ID
	where O.LeagueID=1
	  and O.handicap - V.handicap < 11 
	order by [Handicap Difference] 
