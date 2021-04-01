USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'IntegrityCheck')
	drop procedure IntegrityCheck
GO

create procedure IntegrityCheck

as

select Category='Player with invalid ClubID',P.ID,P.ClubID,P.Forename,P.Initials,P.Surname,[League Name],P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from Players P
	outer apply (Select ClubID from Clubs where ID=P.ClubID) Clubs
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and Clubs.ClubID is null

select Category='Player with invalid Team letter',P.ID,P.Forename,P.Initials,P.Surname,[League Name],[Club Name],P.Team,P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from Players P
	cross apply (Select ClubID, [Club Name] from Clubs where ID=P.ClubID) C
	outer apply (Select Team from Teams where  ClubID=P.ClubID and Team=P.Team and LeagueID=P.LeagueID) T
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and T.Team is null
   order by [Club Name],P.LeagueID,Surname,Forename

select Category='Team with invalid ClubID',T.ClubID,[League Name],[Section Name],T.Team,T.Contact,T.email,T.TelNo 
	from TeamsDetails T
	outer apply (Select ClubID from Clubs where ID=T.ClubID) C
	outer apply (Select LeagueID,[Section Name] from Sections where ID=T.SectionID) S
	outer apply (Select [League Name] from Leagues where ID=S.LeagueID) L
	where C.ClubID is null

Select Category='Club with no team',C.*
	from Clubs C
	outer apply (Select ClubID from Teams where ClubID=C.ID) T
	where T.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Club with no players',C.*
	from Clubs C
	outer apply (Select ClubID from Players where ClubID=C.ID) P
	where P.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Team with no players',C.[Club Name],T.Team,L.[League Name],[Section Name],T.TelNo,T.Contact,t.eMail
	from TeamsDetails T
	outer apply (Select ClubID, Team from Players where ClubID=T.ClubID and Team=T.Team) P
	outer apply (Select [Club Name] from Clubs where ID=T.ClubID) C
	outer apply (Select LeagueID,[Section Name] from Sections where ID=T.SectionID) S
	outer apply (Select [League Name] from Leagues where ID=S.LeagueID) L
	where P.Team is null
	  and [Club Name]<>'Bye'

select Category='Breaks with invalid PlayerID',B.*
	from Breaks B
	outer apply (Select ID from Players where ID=PlayerID) P
	where P.ID is null
   order by B.ID

select Category='Match with invalid HomePlayer1ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer1ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer2ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer2ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer3ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer3ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer4ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer4ID) P
	where isnull(M.Homeplayer4id,0) <> 0
	  and P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer1ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer1ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer2ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer2ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer3ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer3ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer4ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer4ID) P
	where isnull(M.Awayplayer4id,0) <> 0
	  and P.ID is null
   order by M.ID

select Category='LeaguePointsAdjustment with invalid TeamID',L.*
	from LeaguePointsAdjustment L
	outer apply (Select ID from Teams where ID=teamID) T
	where T.ID is null
   order by T.ID

select Category='PlayerRecords with invalid PlayerID',L.*
	from PlayerRecords L
	outer apply (Select ID,surname,initials,forename from Players where ID=PlayerID) P
	where P.ID is null
	  and isnull(L.PlayerID,0)<>0
   order by Season,Team

GO

exec IntegrityCheck
