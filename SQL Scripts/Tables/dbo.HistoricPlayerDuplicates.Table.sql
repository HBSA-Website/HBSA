USE [HBSA]
GO
/****** Object:  Table [dbo].[HistoricPlayerDuplicates]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoricPlayerDuplicates](
	[LeagueID] [int] NULL,
	[PlayerID] [int] NULL,
	[Player] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
