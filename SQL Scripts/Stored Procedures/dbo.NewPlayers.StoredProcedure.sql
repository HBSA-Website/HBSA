use hbsa
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='NewPlayers')
	drop procedure dbo.NewPlayers
GO

create procedure dbo.NewPlayers

as

set nocount on

 select PlayerID = P.ID
	  ,Player=dbo.FullPlayerName(P.Forename, P.Initials, P.Surname)
      ,Team = [Club Name] + ' ' + P.Team
	  ,[League Name]
	  ,P.Handicap
	  ,Season=CONVERT(char(4),R.Season-1) + '-' + convert(char(4),R.season)
	  ,R.Hcap,R.P, R.W, R.L, [Old Team]=R.Team, R.Tag
	  ,Captain=dbo.FullPlayerName(C.Forename,C.Initials,C.Surname)
	  ,C.TelNo
	  ,C.eMail
	from Players P
	join Clubs 
		on P.ClubID = Clubs.ID
	cross apply (Select [League Name] from Leagues where ID=LeagueID) l
	outer apply (select top 1 * from PlayerRecords where leagueID=P.LeagueID and surname=P.Surname and Forename = P.Forename order by Season desc) R
	left join Teams T
	   on T.ClubID = P.ClubID and T.Team=P.Team AND (select LeagueID from Sections where ID = T.sectionID) = p.LeagueID
	LEFT JOIN EntryForm_Players c
	  ON c.PlayerID=Captain
	where P.Handicap=(select convert(int,[value]) from [Configuration] where [key]='EntryFormNewRegStartHCap')
	order by [Club Name]
GO 

exec NewPlayers