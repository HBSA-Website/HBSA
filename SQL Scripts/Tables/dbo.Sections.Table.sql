USE [HBSA]
GO
/****** Object:  Table [dbo].[Sections]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sections](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeagueID] [int] NULL,
	[Section Name] [varchar](50) NULL,
	[ReversedMatrix] [tinyint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
