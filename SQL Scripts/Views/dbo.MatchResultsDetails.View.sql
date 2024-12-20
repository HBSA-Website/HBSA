USE [HBSA]
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails')
	drop view dbo.MatchResultsDetails
GO


CREATE view [dbo].[MatchResultsDetails]

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

	GO

select * from MatchResultsDetails