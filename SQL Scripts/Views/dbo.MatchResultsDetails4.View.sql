USE [HBSA]
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails4')
	drop view dbo.MatchResultsDetails4
GO


CREATE view [dbo].[MatchResultsDetails4]

as

SELECT *
	from MatchResults M
	outer apply (select HomePlayer1=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=Forename + case when Initials<>'' then ' ' + Initials+'. ' else ' ' end + Surname from Players where ID=AwayPlayer4ID) a4
	outer apply (select Match=HC.[Club Name] + HT.Team + ' v ' + AC.[Club Name] + AT.Team + ' on ' + convert(varchar(11),MatchDate,113) + ' in ' + [League Name] + ' ' + S.[Section Name]
					from MatchResults M2
					join Teams HT cross apply (select [Club Name] from Clubs where ID = HT.ClubID) HC on HT.ID = HomeTeamID 
					join Teams AT cross apply (select [Club Name] from Clubs where ID = AT.ClubID) AC on AT.ID = AwayTeamID
					join sections S on S.ID=HT.SectionID
				    join Leagues L on L.ID=S.LeagueID
					where M.ID=M2.ID) H
GO

select * from MatchResultsDetails4