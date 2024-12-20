USE [HBSA]
GO
/****** Object:  Table [dbo].[Competitions]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Competitions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[LeagueID] [int] NULL,
	[CompType] [int] NULL,
	[NoRounds] [int] NULL,
	[Comment] [varchar](256) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
