USE [HBSA]
GO
/****** Object:  Table [dbo].[MatchResults_Deleted]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MatchResults_Deleted](
	[ID] [int] NOT NULL,
	[MatchDate] [date] NOT NULL,
	[HomeTeamID] [int] NOT NULL,
	[AwayTeamID] [int] NOT NULL,
	[HomePlayer1ID] [int] NULL,
	[HomePlayer1Score] [int] NULL,
	[HomeHandicap1] [int] NULL,
	[AwayPlayer1ID] [int] NULL,
	[AwayPlayer1Score] [int] NULL,
	[AwayHandicap1] [int] NULL,
	[HomePlayer2ID] [int] NULL,
	[HomePlayer2Score] [int] NULL,
	[HomeHandicap2] [int] NULL,
	[AwayPlayer2ID] [int] NULL,
	[AwayPlayer2Score] [int] NULL,
	[AwayHandicap2] [int] NULL,
	[HomePlayer3ID] [int] NULL,
	[HomePlayer3Score] [int] NULL,
	[HomeHandicap3] [int] NULL,
	[AwayPlayer3ID] [int] NULL,
	[AwayPlayer3Score] [int] NULL,
	[AwayHandicap3] [int] NULL,
	[HomePlayer4ID] [int] NULL,
	[HomePlayer4Score] [int] NULL,
	[HomeHandicap4] [int] NULL,
	[AwayPlayer4ID] [int] NULL,
	[AwayPlayer4Score] [int] NULL,
	[AwayHandicap4] [int] NULL,
	[DateTimeLodged] [datetime] NULL,
	[UserID] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
