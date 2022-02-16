USE [HBSA]
GO

/****** Object:  Table [dbo].[MatchResultsFixtureDates]    Script Date: 16/02/2022 19:35:56 ******/
if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MatchResultsFixtureDates') 
	DROP TABLE [dbo].[MatchResultsFixtureDates]
GO

CREATE TABLE [dbo].[MatchResultsFixtureDates](
	[MatchResultID] [int] NOT NULL,
	[FixtureDate] [date] NOT NULL,
 CONSTRAINT [PK_MatchResultsFixtureDates] PRIMARY KEY CLUSTERED 
(
	[MatchResultID], 
	[FixtureDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

insert MatchResultsFixtureDates
     select ID, FixtureDate from MatchResultsDetails2
