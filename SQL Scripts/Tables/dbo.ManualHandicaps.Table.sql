USE [HBSA]
GO
/****** Object:  Table [dbo].[ManualHandicaps]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ManualHandicaps](
	[Surname] [varchar](50) NULL,
	[Forename] [varchar](50) NULL,
	[LeagueID] [int] NULL,
	[Handicap] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
