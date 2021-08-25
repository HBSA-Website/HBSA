use hbsa
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryFormsNewPlayers')
	drop procedure dbo.EntryFormsNewPlayers
GO

create procedure EntryFormsNewPlayers

as

set nocount on

 select Player=dbo.FullPlayerName(P.Forename, P.Initials, P.Surname)
      ,Team = [Club Name] + ' ' + P.Team
	  ,[League Name]
	  ,P.Handicap
	  ,Season=CONVERT(char(4),R.Season-1) + '-' + convert(char(4),R.season)
	  ,R.Hcap,R.P, R.W, R.L, [Old Team]=R.Team, R.Tag
	  ,Captain=dbo.FullPlayerName(C.Forename,C.Initials,C.Surname)
	  ,C.TelNo
	  ,C.eMail
	from EntryForm_Players P
	join EntryForm_Clubs 
		on P.ClubID = EntryForm_Clubs.ClubID
	cross apply (Select [League Name] from Leagues where ID=LeagueID) l
	outer apply (select top 1 * from PlayerRecords where leagueID=P.LeagueID and surname=P.Surname and Forename = P.Forename order by Season desc) R
	left join EntryForm_Teams T
	   on T.ClubID = P.ClubID and T.Team=P.Team AND t.LeagueID = p.LeagueID
	LEFT JOIN EntryForm_Players c
	  ON c.PlayerID=Captain
	where P.Handicap=(select convert(int,[value]) from [Configuration] where [key]='EntryFormNewRegStartHCap')
	order by [Club Name]
GO

exec EntryFormsNewPlayers
--select * from EntryForm_players where surname='BROADBENT' or surname like '%Hemi%'
--select * from clubs where id=41
