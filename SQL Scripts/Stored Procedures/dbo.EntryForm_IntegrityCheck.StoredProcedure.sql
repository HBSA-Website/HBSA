use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_IntegrityCheck')
	drop procedure EntryForm_IntegrityCheck
GO

create procedure EntryForm_IntegrityCheck

as

select Category='Player with invalid ClubID',P.PlayerID,P.Forename,P.Initials,P.Surname,[League Name],P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from EntryForm_Players P
	outer apply (Select ClubID from EntryForm_Clubs where ClubID=P.ClubID) Clubs
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and Clubs.ClubID is null

select Category='Player with invalid Team letter',P.PlayerID,P.Forename,P.Initials,P.Surname,[League Name],[Club Name],P.Team,P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from EntryForm_Players P
	cross apply (Select ClubID, [Club Name] from EntryForm_Clubs where ClubID=P.ClubID) C
	outer apply (Select Team from EntryForm_Teams where  ClubID=P.ClubID and Team=P.Team and LeagueID=P.LeagueID) T
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and T.Team is null
   order by [Club Name],P.LeagueID,Surname,Forename

select Category='Team with invalid ClubID',T.ClubID,[League Name],T.Team,T.Contact,T.email,T.TelNo 
	from EntryForm_Teams T
	outer apply (Select ClubID from EntryForm_Clubs where ClubID=T.ClubID) C
	outer apply (Select [League Name] from Leagues where ID=T.LeagueID) L
	where C.ClubID is null

Select Category='Club with no team',C.*
	from EntryForm_Clubs C
	outer apply (Select ClubID from EntryForm_Teams where ClubID=C.ClubID) T
	where T.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Club with no players',C.*
	from EntryForm_Clubs C
	outer apply (Select ClubID from EntryForm_Players where ClubID=C.ClubID) P
	where P.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Team with no players',C.[Club Name],T.Team,L.[League Name],T.TelNo,T.Contact,t.eMail
	from EntryForm_Teams T
	outer apply (Select ClubID, Team from EntryForm_Players where ClubID=T.ClubID and Team=T.Team) P
	outer apply (Select [Club Name] from EntryForm_Clubs where ClubID=T.ClubID) C
	outer apply (Select [League Name] from Leagues where ID=T.LeagueID) L
	where P.Team is null


GO

exec EntryForm_IntegrityCheck

