USE [HBSA]
GO
/****** Object:  Table [dbo].[PlayerRecords]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PlayerRecords](
	[LeagueID] [int] NOT NULL,
	[Player] [varchar](100) NOT NULL,
	[Season] [int] NOT NULL,
	[Hcap] [int] NOT NULL,
	[P] [int] NULL,
	[W] [int] NULL,
	[L] [int] NULL,
	[Team] [varchar](75) NULL,
	[Tag] [varchar](15) NULL,
	[PlayerID] [int] NULL,
	[Forename] [varchar](50) NULL,
	[Initials] [varchar](4) NULL,
	[Surname] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
