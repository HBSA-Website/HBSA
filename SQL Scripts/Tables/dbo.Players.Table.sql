USE [HBSA]
GO
/****** Object:  Table [dbo].[Players]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Players](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Forename] [varchar](50) NOT NULL,
	[Initials] [varchar](4) NOT NULL CONSTRAINT [DF_Players_Initials]  DEFAULT (''),
	[Surname] [varchar](50) NOT NULL,
	[Handicap] [int] NOT NULL,
	[LeagueID] [smallint] NOT NULL,
	[SectionID] [int] NOT NULL,
	[ClubID] [int] NOT NULL,
	[Team] [char](1) NOT NULL CONSTRAINT [DF_Players_Team]  DEFAULT (''),
	[email] [varchar](250) NULL,
	[TelNo] [varchar](20) NULL,
	[Tagged] [tinyint] NULL CONSTRAINT [DF_Players_Tagged]  DEFAULT ((0)),
	[Over70] [bit] NOT NULL CONSTRAINT [DF_Players_Over70]  DEFAULT ((0)),
	[Played] [bit] NOT NULL CONSTRAINT [DF_Players_Played]  DEFAULT ((0)),
	[dateRegistered] [date] NULL,
 CONSTRAINT [PK_Players] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
