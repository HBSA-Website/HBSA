USE [HBSA]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Teams](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL,
	[FixtureNo] [int] NOT NULL,
	[ClubID] [int] NOT NULL,
	[Team] [char](1) NULL,
	[Captain] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
