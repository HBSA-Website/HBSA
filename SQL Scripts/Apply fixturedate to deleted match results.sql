use hbsa
go

insert MatchResultsFixtureDates
select M.ID,D.FixtureDate --, MatchDate,
		--HT.*, G.* 
		from MatchResults_Deleted M
         join teams HT on HT.ID=HomeTeamID  
         join teams AT on AT.ID=AwayTeamID  
         join FixtureGrids G on G.SectionID=HT.SectionID 
		 
		 and (  (HT.FixtureNo = h1 and AT.FixtureNo = a1) or
		        (HT.FixtureNo = h2 and AT.FixtureNo = a2) or
		        (HT.FixtureNo = h3 and AT.FixtureNo = a3) or
		        (HT.FixtureNo = h4 and AT.FixtureNo = a4) or
		        (HT.FixtureNo = h5 and AT.FixtureNo = a5) or
		        (HT.FixtureNo = h6 and AT.FixtureNo = a6) or
		        (HT.FixtureNo = h7 and AT.FixtureNo = a7) or
		        (HT.FixtureNo = h8 and AT.FixtureNo = a8) )
		 join FixtureDates D on D.SectionID=HT.SectionID 
		                    and D.WeekNo=G.WeekNo
         left join MatchResultsFixtureDates on M.ID=MatchResultID
		 where MatchResultID is null


