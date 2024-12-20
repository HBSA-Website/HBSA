USE [HBSA]
GO
/****** Object:  Table [dbo].[HandicapsReportTable]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HandicapsReportTable](
	[Effective] [date] NULL,
	[SectionID] [int] NULL,
	[ClubID] [int] NULL,
	[PlayerID] [int] NULL,
	[Handicap] [int] NULL,
	[Tagged] [tinyint] NULL,
	[Over70] [bit] NULL,
	[Played] [int] NULL,
	[Won] [int] NULL,
	[Lost] [int] NULL,
	[Delta] [int] NULL,
	[New Handicap] [int] NULL
) ON [PRIMARY]

GO
