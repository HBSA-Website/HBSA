USE [HBSA]
GO
/****** Object:  Table [dbo].[HistoricPlayerUnknowns]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoricPlayerUnknowns](
	[Surname] [varchar](50) NULL,
	[Forename] [varchar](50) NULL,
	[Initials] [varchar](4) NULL,
	[PlayerID] [int] NULL,
	[LeagueID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
