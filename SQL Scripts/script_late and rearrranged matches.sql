select FixtureDate, MatchDate, dateLodged=convert(date,dateTimeLodged), MatchResultsDetails.* 
	from MatchResultsDetails
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=AwayTeamID) A
						--Cross apply (select LeagueID from Sections where ID=F.SectionID) L
						cross apply (Select FixtureDate from FixtureDates where SectionID= F.SectionID and WeekNo = F.WeekNo) D
						where F.SectionID=H.SectionID
						  and ((h1=H.FixtureNo and a1=A.FixtureNo)
					 	    or (h2=H.FixtureNo and a2=A.FixtureNo)
						    or (h3=H.FixtureNo and a3=A.FixtureNo)
						    or (h4=H.FixtureNo and a4=A.FixtureNo)
						    or (h5=H.FixtureNo and a5=A.FixtureNo)
						    or (h6=H.FixtureNo and a6=A.FixtureNo)
						    or (h7=H.FixtureNo and a7=A.FixtureNo)
						    or (h8=H.FixtureNo and a8=A.FixtureNo)
						       )
			   )FD

	where FixtureDate <> MatchDate
	   or abs(datediff (day,DateTimeLodged,FixtureDate)) > 7

--exec checkForResultsCard 56,71