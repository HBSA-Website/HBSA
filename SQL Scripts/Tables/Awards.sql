USE [HBSA]
GO
/****** Object:  Index [AwardsTemplate_Unique]    Script Date: 11/04/2018 11:12:08 ******/
DROP INDEX [AwardsTemplate_Unique] ON [dbo].[Awards_Template]
GO
/****** Object:  Index [IX_Awards]    Script Date: 11/04/2018 11:12:08 ******/
DROP INDEX [IX_Awards] ON [dbo].[Awards]
GO
/****** Object:  Table [dbo].[Awards_Types]    Script Date: 11/04/2018 11:12:08 ******/
DROP TABLE [dbo].[Awards_Types]
GO
/****** Object:  Table [dbo].[Awards_Template]    Script Date: 11/04/2018 11:12:08 ******/
DROP TABLE [dbo].[Awards_Template]
GO
/****** Object:  Table [dbo].[Awards_Names]    Script Date: 11/04/2018 11:12:08 ******/
DROP TABLE [dbo].[Awards_Names]
GO
/****** Object:  Table [dbo].[Awards]    Script Date: 11/04/2018 11:12:08 ******/
DROP TABLE [dbo].[Awards]
GO
/****** Object:  Table [dbo].[Awards]    Script Date: 11/04/2018 11:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Awards](
	[AwardType] [int] NULL,
	[AwardID] [int] NULL,
	[SubID] [int] NULL,
	[LeagueID] [int] NULL,
	[EntrantID] [int] NULL,
	[Entrant2ID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Awards_Names]    Script Date: 11/04/2018 11:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Awards_Names](
	[AwardType] [int] NULL,
	[Name] [varchar](255) NULL,
	[Description] [varchar](63) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Awards_Template]    Script Date: 11/04/2018 11:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Awards_Template](
	[AwardType] [int] NULL,
	[AwardID] [int] NULL,
	[SubID] [int] NULL,
	[LeagueID] [int] NULL,
	[Trophy] [varchar](255) NULL,
	[Award] [varchar](255) NULL,
	[MultipleWinners] [bit] NULL,
	[RecipientType] [varchar](15) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Awards_Types]    Script Date: 11/04/2018 11:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Awards_Types](
	[AwardType] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[Description] [varchar](63) NULL,
	[StoredProcedureName] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (1, N'[League] [Section] [Position]', N'Leagues')
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (2, N'[Competition] [Position]', N'Competitions')
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (3, N'Highest Break ([LowHandicap] to [HighHandicap])', N'Highest Break by category')
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (4, N'Highest break in the [League]', N'Highest Break in a league')
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (5, N'Best last 6 match results in the [League]', N'Best last 6 results')
GO
INSERT [dbo].[Awards_Names] ([AwardType], [Name], [Description]) VALUES (6, N'Most Promising Young Player', N'Most Promising Young Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 9, 1, 2, N'M.E. Consultancy Millenium Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 8, 1, 2, N'M.E. Consultancy Millenium Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 7, 1, 2, N'John Clegg Memorial Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 4, 2, 2, N'Frank Swallow Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 4, 1, 2, N'W. Cuerdon Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (5, NULL, NULL, 2, N'Morris Gledhill Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 6, 2, 2, NULL, N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 6, 1, 2, N'S. Garbutt Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 5, 3, 2, N'J. & L. Scott Trophy', N'Prize', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 5, 4, 2, N'J. & L. Scott Trophy', N'Prize', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 5, 2, 2, N'J. & L. Scott Trophy', N'Prize', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 5, 1, 2, N'J. & L. Scott Trophy', N'Prize', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (4, NULL, NULL, 2, N'Francis Hayward Trophy', N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 10, 2, 3, N'Frank Hallam Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 10, 1, 3, N'H. Wilkinson Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (5, NULL, NULL, 3, N'Norman Hargreaves Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 9, 2, 3, NULL, N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 9, 1, 3, N'Victor Muff Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 8, 4, 3, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 8, 3, 3, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 8, 2, 3, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 8, 1, 3, N'Frank Fisher Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 7, 4, 3, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 7, 3, 3, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 7, 2, 3, N'Ted Warren Memorial Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 7, 1, 3, N'F. C. Mitchell Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 7, NULL, 3, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 8, NULL, 3, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 9, NULL, 3, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 10, NULL, 3, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (4, NULL, NULL, 3, N'Tommy Donlan Memorial Trophy', N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 6, 1, 1, N'Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 5, 1, 1, N'Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 4, 1, 1, N'Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 3, 1, 1, N'Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 2, 1, 1, N'Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (1, 1, 1, 1, N'Gene Short Memorial Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 12, 2, 1, NULL, N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 12, 1, 1, N'John Needham Plate', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 11, 2, 1, N'Janet Hanlon Rosebowl', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 11, 1, 1, N'Bass North Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (5, NULL, NULL, 1, N'Sandy Fraser Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 4, 2, 1, NULL, N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 4, 1, 1, N'Raymond Woodhead Trophy', N'Cash', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 2, 4, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 2, 3, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 2, 2, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 2, 1, 1, N'J. Cock & W. P. North Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 3, 4, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 3, 3, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 3, 2, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 3, 1, 1, N'Mrs E. Oldham Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 10, 4, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 10, 3, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 10, 2, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 10, 1, 1, N'Stanley Broadbent Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 1, 4, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 1, 3, 1, NULL, N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 1, 2, 1, N'Morris Gledhill Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 1, 1, 1, N'Huddersfield Examiner Trophy', N'Cash', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (6, NULL, NULL, 1, N'David Downs Trophy', N'Trophy', 0, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 1, NULL, 1, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 2, NULL, 1, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 3, NULL, 1, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 4, NULL, 1, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (3, 5, NULL, 1, NULL, N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (4, NULL, NULL, 1, N'Paul Hunter Memorial Trophy', N'Trophy', 1, N'Player')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 13, 1, 2, N'W. Cuerdon Trophy', N'Trophy', 0, N'Team')
GO
INSERT [dbo].[Awards_Template] ([AwardType], [AwardID], [SubID], [LeagueID], [Trophy], [Award], [MultipleWinners], [RecipientType]) VALUES (2, 13, 2, 2, N'Frank Swallow Trophy', N'Prize', 0, N'Team')
GO
SET IDENTITY_INSERT [dbo].[Awards_Types] ON 

GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (1, N'[League] [Section] [Position]', N'Leagues', N'Awards_LeagueWinners')
GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (2, N'[Competition] [Position]', N'Competitions', N'Awards_CompWinners')
GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (3, N'Highest Break ([LowHandicap] to [HighHandicap])', N'Highest Break by category', N'Awards_Breaks')
GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (4, N'Highest break in the [League]', N'Highest Break in a league', N'Awards_HighBreaksByLeague')
GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (5, N'Best last 6 match results in the [League]', N'Best last 6 results', N'Awards_lastSixMatchesWinners')
GO
INSERT [dbo].[Awards_Types] ([AwardType], [Name], [Description], [StoredProcedureName]) VALUES (6, N'Most Promising Young Player', N'Most Promising Young Player', NULL)
GO
SET IDENTITY_INSERT [dbo].[Awards_Types] OFF
GO
/****** Object:  Index [IX_Awards]    Script Date: 11/04/2018 11:12:08 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Awards] ON [dbo].[Awards]
(
	[AwardType] ASC,
	[AwardID] ASC,
	[SubID] ASC,
	[LeagueID] ASC,
	[EntrantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AwardsTemplate_Unique]    Script Date: 11/04/2018 11:12:08 ******/
CREATE UNIQUE NONCLUSTERED INDEX [AwardsTemplate_Unique] ON [dbo].[Awards_Template]
(
	[AwardType] ASC,
	[AwardID] ASC,
	[SubID] ASC,
	[LeagueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
