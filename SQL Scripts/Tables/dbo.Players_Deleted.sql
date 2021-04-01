USE HBSA
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('Players_Deleted'))
	DROP TABLE Players_Deleted

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
)

GO
