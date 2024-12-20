USE [HBSA]
GO
/****** Object:  Table [dbo].[Players_Deleted]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Players_Deleted](
	[ID] [int] NOT NULL,
	[Forename] [varchar](50) NOT NULL,
	[Initials] [varchar](4) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[Handicap] [int] NOT NULL,
	[LeagueID] [smallint] NOT NULL,
	[SectionID] [int] NOT NULL,
	[ClubID] [int] NOT NULL,
	[Team] [char](1) NOT NULL,
	[email] [varchar](250) NULL,
	[TelNo] [varchar](20) NULL,
	[Tagged] [bit] NOT NULL,
	[Over70] [bit] NOT NULL,
	[Played] [bit] NOT NULL,
	[dtLodged] [datetime] NULL,
	[dateRegistered] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
