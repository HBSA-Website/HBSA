USE [HBSA]
GO
/****** Object:  Table [dbo].[FixtureDates]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FixtureDates](
	[SectionID] [smallint] NULL,
	[SectionSize] [int] NULL,
	[WeekNo] [int] NULL,
	[FixtureDate] [date] NULL
) ON [PRIMARY]

GO
