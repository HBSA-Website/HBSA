USE [HBSA]

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Content')
	drop table Content
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContentData]') AND type in (N'U'))
DROP TABLE [dbo].[ContentData]
GO
/****** Object:  Table [dbo].[ContentData]    Script Date: 20/05/2020 18:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ContentName] [varchar](128) NULL,
	[ContentHTML] [varchar](max) NULL,
	[dtLodged] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'AssociationRules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Attendance', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Competitions Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Conduct', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Final league places', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Handicap Leagues Supplementary Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Home', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'ImportantDates', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'League Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Minutes', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Officials', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Open Billiards League Supplementary Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Open Snooker League Supplementary Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'PlayerExceptions', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'PresidentsMessage', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'ROH_Billiards', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'ROH_Snooker', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'ROH_Veterans', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Trophy and Prize Winners', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Veterans Snooker League Supplementary Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Yorkshire Association Rules', N'')
GO
INSERT [dbo].[Content] ([ContentName], [ContentHTML]) VALUES (N'Yorkshire', N'')
GO
