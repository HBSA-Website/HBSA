USE [HBSA]
GO
/****** Object:  Table [dbo].[Breaks]    Script Date: 12/12/2014 17:41:30 ******/
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
