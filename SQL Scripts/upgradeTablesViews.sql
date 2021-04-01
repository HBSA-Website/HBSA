USE [HBSA]
GO

/****** Object:  Table [dbo].[Breaks]    Script Date: 04/30/2014 11:05:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Breaks]') AND type in (N'U'))
DROP TABLE [dbo].[Breaks]
GO

USE [HBSA]
GO

/****** Object:  Table [dbo].[Breaks]    Script Date: 04/30/2014 11:05:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Breaks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MatchResultID] [int] NULL,
	[PlayerID] [int] NULL,
	[Break] [int] NULL
) ON [PRIMARY]

GO

USE [HBSA]
GO

/****** Object:  Table [dbo].[Breaks_Deleted]    Script Date: 04/30/2014 11:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Breaks_Deleted]') AND type in (N'U'))
DROP TABLE [dbo].[Breaks_Deleted]
GO

USE [HBSA]
GO

/****** Object:  Table [dbo].[Breaks_Deleted]    Script Date: 04/30/2014 11:06:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Breaks_Deleted](
	[ID] [int] NOT NULL,
	[MatchResultID] [int] NULL,
	[PlayerID] [int] NULL,
	[Break] [int] NULL
) ON [PRIMARY]

GO

alter table Clubs add
	 ContactName varchar(104)
	,ContactEMail varchar(250)
	,ContactTelNo varchar(20)
	,ContactMobNo varchar(20)

alter table Clubs drop column
	 ContactID
GO
update Clubs
	set	ContactName=FirstName + ' ' + Surname
	   ,ContactEMail= eMailAddress
	   ,ContactTelNo = case when left(dbo.normaliseTelephoneNumber(Telephone),2)='07' then '' else dbo.normaliseTelephoneNumber(Telephone) end
	   ,ContactMobNo = case when left(dbo.normaliseTelephoneNumber(Telephone),2)<>'07' then '' else dbo.normaliseTelephoneNumber(Telephone) end
	from Clubs
	join Teams on ClubID = Clubs.ID 
	cross apply (select top 1 * 
					from ResultsUsers 
					where TeamID=Teams.ID
					order by TeamID) x
GO
use HBSA
go

alter table Teams
	add Contact varchar(104)
	   ,eMail   varchar(250)
GO

USE [HBSA]
GO

/****** Object:  View [dbo].[MatchResultsDetails2]    Script Date: 04/29/2014 12:46:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MatchResultsDetails2]'))
DROP VIEW [dbo].[MatchResultsDetails2]
GO

USE [HBSA]
GO

/****** Object:  View [dbo].[MatchResultsDetails2]    Script Date: 04/29/2014 12:46:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[MatchResultsDetails2]

as

SELECT *
	from MatchResults 
	outer apply (select HomePlayer1=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer4ID) a4

GO

use HBSA
go
if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Competitions]')) drop table Competitions
GO

create table Competitions
	(ID int Identity (1,1)
	,Name varchar(50)
	,LeagueID int
	,CompType int    --1 = Individual, 2 = Pair, 3 = Team
	,NoRounds int
	)
USE [HBSA]
GO

/****** Object:  Table [dbo].[Competitions_Rounds]    Script Date: 04/04/2014 16:38:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Competitions_Rounds]') AND type in (N'U'))
DROP TABLE [dbo].[Competitions_Rounds]
GO

USE [HBSA]
GO

/****** Object:  Table [dbo].[Competitions_Rounds]    Script Date: 04/04/2014 16:38:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Competitions_Rounds](
	[CompetitionID] [int] NOT NULL,
	[RoundNo] [int] NULL,
	[EntryID] [int] NULL,
	[PlayByDate] [date] NULL,
	[Comment] [varchar](256) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



	   
