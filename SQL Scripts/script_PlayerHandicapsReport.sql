select Name=Forename + ' ' + case when isnull(initials,'')='' then ' ' else initials+'. ' end + Surname
	,Handicap, Tagged, Over70
	,[Club Name],Team, [League Name], [Section Name] 
	from PlayerDetails where ID >=0
	order by LeagueID,SectionID,ClubID,Team,Forename + ' ' + case when isnull(initials,'')='' then ' ' else initials+'. ' end + Surname