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
	  ,Handicap
	  ,Season=CONVERT(char(4),R.Season-1) + '-' + convert(char(4),R.season)
	  ,R.Hcap,R.P, R.W, R.L, [Old Team]=R.Team, R.Tag
	from EntryForm_Players P
	left join EntryForm_Clubs 
		on P.ClubID = EntryForm_Clubs.ClubID
	cross apply (Select [League Name] from Leagues where ID=LeagueID) l
	outer apply (select top 1 * from PlayerRecords where leagueID=P.LeagueID and surname=P.Surname and Forename = P.Forename order by Season desc) R
	where Handicap=(select convert(int,[value]) from [Configuration] where [key]='EntryFormNewRegStartHCap')
	order by [Club Name]
GO

exec EntryFormsNewPlayers
--select * from EntryForm_players where surname='Tyas' or surname like '%Hemi%'
--select * from clubs where id=41
