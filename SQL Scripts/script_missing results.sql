
select G.WeekNo,FixtureDate,Section=[League Name]+' ' + [Section Name]
	,[Club Name],homeTeam.team

	from FixtureGrids G
	join FixtureDates D
	  on D.WeekNo=G.WeekNo
	 and D.LeagueID=(select LeagueID from Sections where ID=G.SectionID)
	join Teams homeTeam
	  on homeTeam.sectionID=G.SectionID
	 and (homeTeam.FixtureNo=G.h1 or
	      homeTeam.FixtureNo=G.h2 or
	      homeTeam.FixtureNo=G.h3 or
	      homeTeam.FixtureNo=G.h4 or
	      homeTeam.FixtureNo=G.h5 or
	      homeTeam.FixtureNo=G.h6 or
	      homeTeam.FixtureNo=G.h7 or
	      homeTeam.FixtureNo=G.h8)

	left join MatchResults R
	  on R.Matchdate=D.FixtureDate
	 and (R.HomeTeamID = homeTeam.ID)
	left join Teams awayTeam
		on awayTeam.SectionID=G.SectionID
	   and awayTeam.FixtureNo=case when homeTeam.FixtureNo=G.h1 then a1
		             when homeTeam.FixtureNo=G.h2 then a2
		             when homeTeam.FixtureNo=G.h3 then a3
		             when homeTeam.FixtureNo=G.h4 then a4
		             when homeTeam.FixtureNo=G.h5 then a5
		             when homeTeam.FixtureNo=G.h6 then a6
		             when homeTeam.FixtureNo=G.h7 then a7
		             when homeTeam.FixtureNo=G.h8 then a8
			    end

	join clubs on Clubs.ID=hometeam.ClubID
	join Leagues on Leagues.ID=D.LeagueID
	join Sections on Sections.ID=G.SectionID

	where homeTeam.ClubID<> (select ID from Clubs where [Club Name]='Bye')
	  and awayteam.ClubID<> (select ID from Clubs where [Club Name]='Bye')
	  and R.ID is null
	  and D.FixtureDate < dateadd(day,-1,getdate())

	order by D.FixtureDate,G.SectionID,Clubs.[Club Name]
 
