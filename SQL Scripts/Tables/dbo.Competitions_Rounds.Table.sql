USE [HBSA]
GO
/****** Object:  Table [dbo].[Competitions_Rounds]    Script Date: 12/12/2014 17:41:30 ******/
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
