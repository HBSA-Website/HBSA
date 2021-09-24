--select * from MatchResultsDetails M order by ID
--select * from Breaks
declare @ThisSeason int
       ,@Season char(7)
select @ThisSeason=Datepart(year,convert(date,[value]))
   from Configuration where [key] = 'CloseSeasonEndDate'
select @Season=Convert(char(4),@ThisSeason) + '/' + Convert(char(2),(@ThisSeason+1) % 100)

select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer1ID,HomePlayer=HomePlayer1
      ,AwayPlayerID=AwayPlayer1ID,AwayPlayer=AwayPlayer1
	  ,HomeScore=HomePlayer1Score
	  ,AwayScore=AwayPlayer1Score
	  ,HomePlayerHcap=HomeHandicap1
	  ,AwayPlayerHCap=AwayHandicap1
	  ,HomeBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=HomePlayer1ID)
	  ,AwayBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=AwayPlayer1ID)
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join Breaks HB on HB.MatchResultID = M.ID
	      and HB.PlayerID = HomePlayer1ID
	left join Breaks AB on AB.MatchResultID = M.ID
	      and AB.PlayerID = AwayPlayer1ID
union all
select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer2ID,HomePlayer=HomePlayer2
      ,AwayPlayerID=AwayPlayer2ID,AwayPlayer=AwayPlayer2
	  ,HomeScore=HomePlayer2Score
	  ,AwayScore=AwayPlayer2Score
	  ,HomePlayerHcap=HomeHandicap2
	  ,AwayPlayerHCap=AwayHandicap2
	  ,HomeBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=HomePlayer2ID)
	  ,AwayBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=AwayPlayer2ID)
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join Breaks HB on HB.MatchResultID = M.ID
	      and HB.PlayerID = HomePlayer1ID
	left join Breaks AB on AB.MatchResultID = M.ID
	      and AB.PlayerID = AwayPlayer1ID
union all
select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer3ID,HomePlayer=HomePlayer3
      ,AwayPlayerID=AwayPlayer3ID,AwayPlayer=AwayPlayer3
	  ,HomeScore=HomePlayer3Score
	  ,AwayScore=AwayPlayer3Score
	  ,HomePlayerHcap=HomeHandicap3
	  ,AwayPlayerHCap=AwayHandicap3
	  ,HomeBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=HomePlayer3ID)
	  ,AwayBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=AwayPlayer3ID)
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join Breaks HB on HB.MatchResultID = M.ID
	      and HB.PlayerID = HomePlayer1ID
	left join Breaks AB on AB.MatchResultID = M.ID
	      and AB.PlayerID = AwayPlayer1ID
union all
select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer4ID,HomePlayer=HomePlayer4
      ,AwayPlayerID=AwayPlayer4ID,AwayPlayer=AwayPlayer4
	  ,HomeScore=HomePlayer4Score
	  ,AwayScore=AwayPlayer4Score
	  ,HomePlayerHcap=HomeHandicap4
	  ,AwayPlayerHCap=AwayHandicap4
	  ,HomeBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=HomePlayer4ID)
	  ,AwayBreak1 = (Select top 1 [Break] from Breaks where MatchResultID = M.ID and PlayerID=AwayPlayer4ID)
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join Breaks HB on HB.MatchResultID = M.ID
	      and HB.PlayerID = HomePlayer1ID
	left join Breaks AB on AB.MatchResultID = M.ID
	      and AB.PlayerID = AwayPlayer1ID
	where LeagueID < 3 
order by FixtureID
