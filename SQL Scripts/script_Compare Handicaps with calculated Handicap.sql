select Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+isnull(Teams.Team,'')
      ,Player=Players.Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Players.Surname
      ,Tag=case when Players.Tagged = 3 then 'Unseasoned'
	            when Players.Tagged = 2 then '2 Seasons to go'
				when Players.Tagged = 1 then '1 Season to go'
				else ''
           end 
      ,[Over70(80 Vets)]=Players.Over70
	  ,[Last Season H'cap effective from]=convert(varchar(11),T.Effective,113)
      ,[Last Season H'cap]=T.Handicap
      ,T.Played
      ,T.Won
      ,T.Lost
      ,T.Delta
      ,[Current Handicap]=Players.Handicap
	  ,CorrectHandicap=dbo.newHandicap(T.Handicap,T.Played,T.Won,Players.LeagueID,Players.tagged,Players.Over70)
	from Players
	left join HandicapsReportTable T on Players.ID=PlayerID
	join Sections on Sections.ID=Players.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=Players.ClubID
	left join Teams on Teams.SectionID=Players.SectionID 
	               and Teams.ClubID=Players.ClubID 
		   	       and Teams.Team=Players.team
	left join ManualHandicaps MH
	   on MH.Surname=Players.Surname
      and MH.Forename=left(Players.Forename,len(MH.Forename))
	  and MH.LeagueID=Players.LeagueID


	where T.PlayerID = 860
	  --and Players.Handicap <> dbo.newHandicap(T.Handicap,T.Played,T.Won,Players.LeagueID,Players.tagged,Players.Over70)
	  and MH.Surname is null
	  and T.Effective = (select max(effective) from HandicapsReportTable where PlayerID=Players.ID)
	order by Player, Players.SectionID, [Club Name]
