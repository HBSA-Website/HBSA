USE [HBSA]
GO
/****** Object:  Table [dbo].[BreaksCategories]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BreaksCategories](
	[LeagueID] [int] NULL,
	[LowHandicap] [int] NULL,
	[HighHandicap] [int] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
