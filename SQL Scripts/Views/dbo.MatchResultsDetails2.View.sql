USE [HBSA]
GO
/****** Object:  View [dbo].[MatchResultsDetails2]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails2')
	drop view dbo.MatchResultsDetails2
GO

CREATE view dbo.MatchResultsDetails2

as

SELECT *
	from MatchResults R
	outer apply (select HomePlayer1=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=dbo.FullPlayerName(Forename, Initials, Surname) from Players where ID=AwayPlayer4ID) a4
	outer apply (select FixtureDate from MatchResultsFixtureDates where MatchResultID = ID ) FD

GO