USE [HBSA]
GO
/****** Object:  Table [dbo].[Breaks_Historic]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Breaks_Historic](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Season] [int] NULL,
	[Section] [varchar](101) NULL,
	[Player] [varchar](104) NULL,
	[Break] [int] NULL,
	[LeagueID] [int] NULL,
	[SectionID] [int] NULL,
	[PlayerID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
