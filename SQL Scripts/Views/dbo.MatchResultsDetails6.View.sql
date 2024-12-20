USE [HBSA]
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails6')
	drop view dbo.MatchResultsDetails6
GO


CREATE view [dbo].[MatchResultsDetails6]

as

SELECT *
	from MatchResults 
	outer apply (select HomePlayer1=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer4ID) a4
	cross apply (select FirstDateLodged= convert(date, min(case when X.ID is null then M2.DateTimeLodged else X.DateTimeLodged end))
					from MatchResultsDetails2 M2 
					outer apply (select * 
									from MatchResults_Deleted MD 
									join MatchResultsFixtureDates F on MD.ID = F.MatchResultID
			 						where MD.HomeTeamID=M2.HomeTeamID
									  and MD.AwayTeamID=M2.AwayTeamID
									  and F.FixtureDate=M2.FixtureDate) X
					where M2.ID = MatchResults.ID
					group by M2.ID, M2.HomeTeamID, M2.AwayTeamID,M2.FixtureDate
				)dtL

	GO

select * from MatchResultsDetails6