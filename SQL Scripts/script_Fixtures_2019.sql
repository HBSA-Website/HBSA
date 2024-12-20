USE [HBSA]
GO

set xact_abort on

begin tran

/****** Object:  Table [dbo].[Teams]    Script Date: 15/08/2019 13:38:20 ******/
TRUNCATE TABLE [dbo].[Teams]
GO
/****** Object:  Table [dbo].[FixtureGrids]    Script Date: 15/08/2019 13:38:20 ******/
TRUNCATE TABLE [dbo].[FixtureGrids]
GO
/****** Object:  Table [dbo].[FixtureDatesCurfew]    Script Date: 15/08/2019 13:38:20 ******/
TRUNCATE TABLE [dbo].[FixtureDatesCurfew]
GO
/****** Object:  Table [dbo].[FixtureDates]    Script Date: 15/08/2019 13:38:20 ******/
TRUNCATE TABLE [dbo].[FixtureDates]
GO
/****** Object:  Table [dbo].[FixtureDates]    Script Date: 15/08/2019 13:38:20 ******/
GO
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 1, CAST(N'2019-09-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 2, CAST(N'2019-10-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 3, CAST(N'2019-10-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 4, CAST(N'2019-10-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 5, CAST(N'2019-10-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 6, CAST(N'2019-11-04' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 7, CAST(N'2019-11-11' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 8, CAST(N'2019-11-18' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 9, CAST(N'2019-11-25' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 10, CAST(N'2019-12-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 11, CAST(N'2019-12-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 12, CAST(N'2020-01-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 13, CAST(N'2020-01-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 14, CAST(N'2020-01-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 15, CAST(N'2020-02-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 16, CAST(N'2020-02-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 17, CAST(N'2020-02-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 18, CAST(N'2020-02-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 19, CAST(N'2020-03-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 20, CAST(N'2020-03-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 21, CAST(N'2020-03-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (9, 12, 22, CAST(N'2020-03-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 1, CAST(N'2019-09-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 2, CAST(N'2019-10-01' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 3, CAST(N'2019-10-08' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 4, CAST(N'2019-10-15' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 5, CAST(N'2019-10-22' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 6, CAST(N'2019-10-29' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 7, CAST(N'2019-11-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 8, CAST(N'2019-11-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 9, CAST(N'2019-11-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 10, CAST(N'2019-11-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 11, CAST(N'2019-12-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 12, CAST(N'2019-12-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 13, CAST(N'2019-12-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 14, CAST(N'2020-01-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 15, CAST(N'2020-01-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 16, CAST(N'2020-01-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 17, CAST(N'2020-02-04' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 18, CAST(N'2020-02-11' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 19, CAST(N'2020-02-18' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 20, CAST(N'2020-02-25' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 21, CAST(N'2020-03-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (10, 12, 22, CAST(N'2020-03-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 1, CAST(N'2019-09-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 2, CAST(N'2019-10-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 3, CAST(N'2019-10-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 4, CAST(N'2019-10-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 5, CAST(N'2019-10-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 6, CAST(N'2019-11-04' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 7, CAST(N'2019-11-11' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 8, CAST(N'2019-11-18' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 9, CAST(N'2019-11-25' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 10, CAST(N'2019-12-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 11, CAST(N'2019-12-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 12, CAST(N'2020-01-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 13, CAST(N'2020-01-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 14, CAST(N'2020-01-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 15, CAST(N'2020-02-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 16, CAST(N'2020-02-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 17, CAST(N'2020-02-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 18, CAST(N'2020-02-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 19, CAST(N'2020-03-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 20, CAST(N'2020-03-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 21, CAST(N'2020-03-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (7, 12, 22, CAST(N'2020-03-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 1, CAST(N'2019-09-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 2, CAST(N'2019-10-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 3, CAST(N'2019-10-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 4, CAST(N'2019-10-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 5, CAST(N'2019-10-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 6, CAST(N'2019-11-04' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 7, CAST(N'2019-11-11' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 8, CAST(N'2019-11-18' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 9, CAST(N'2019-11-25' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 10, CAST(N'2019-12-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 11, CAST(N'2019-12-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 12, CAST(N'2020-01-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 13, CAST(N'2020-01-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 14, CAST(N'2020-01-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 15, CAST(N'2020-02-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 16, CAST(N'2020-02-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 17, CAST(N'2020-02-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 18, CAST(N'2020-02-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 19, CAST(N'2020-03-02' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 20, CAST(N'2020-03-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 21, CAST(N'2020-03-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (8, 12, 22, CAST(N'2020-03-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 8, CAST(N'2019-11-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 12, CAST(N'2019-12-05' AS Date))
GO
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (1, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 8, CAST(N'2019-11-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 12, CAST(N'2019-12-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (2, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 8, CAST(N'2019-11-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 12, CAST(N'2019-12-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (3, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 8, CAST(N'2019-11-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 12, CAST(N'2019-12-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (4, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 8, CAST(N'2019-11-07' AS Date))
GO
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 12, CAST(N'2019-12-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (5, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 1, CAST(N'2019-09-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 2, CAST(N'2019-09-26' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 3, CAST(N'2019-10-03' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 4, CAST(N'2019-10-10' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 5, CAST(N'2019-10-17' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 6, CAST(N'2019-10-24' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 7, CAST(N'2019-10-31' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 8, CAST(N'2019-11-07' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 9, CAST(N'2019-11-14' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 10, CAST(N'2019-11-21' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 11, CAST(N'2019-11-28' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 12, CAST(N'2019-12-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 13, CAST(N'2019-12-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 14, CAST(N'2019-12-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 15, CAST(N'2020-01-09' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 16, CAST(N'2020-01-16' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 17, CAST(N'2020-01-23' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 18, CAST(N'2020-01-30' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 19, CAST(N'2020-02-06' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 20, CAST(N'2020-02-13' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 21, CAST(N'2020-02-20' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 22, CAST(N'2020-02-27' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 23, CAST(N'2020-03-05' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 24, CAST(N'2020-03-12' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 25, CAST(N'2020-03-19' AS Date))
INSERT [dbo].[FixtureDates] ([SectionID], [SectionSize], [WeekNo], [FixtureDate]) VALUES (6, 14, 26, CAST(N'2020-03-26' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (1, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (2, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (3, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (4, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (5, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (6, CAST(N'2019-12-20' AS Date), CAST(N'2020-01-03' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (7, CAST(N'2019-12-14' AS Date), CAST(N'2020-01-06' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (8, CAST(N'2019-12-14' AS Date), CAST(N'2020-01-06' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (9, CAST(N'2019-12-14' AS Date), CAST(N'2020-01-06' AS Date))
INSERT [dbo].[FixtureDatesCurfew] ([SectionID], [StartDate], [Enddate]) VALUES (10, CAST(N'2019-12-18' AS Date), CAST(N'2020-01-07' AS Date))
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 11, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 12, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 24, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 25, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (1, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 11, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 12, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 24, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 25, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (2, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 11, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 12, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 24, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 25, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (3, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 11, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 12, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 24, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 25, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (4, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 11, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 12, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 24, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 25, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (6, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 1, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 2, 12, 7, 8, 6, 9, 5, 10, 4, 11, 3, 1, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 3, 2, 12, 3, 1, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 4, 12, 8, 9, 7, 10, 6, 11, 5, 1, 4, 2, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 5, 3, 12, 4, 2, 5, 1, 6, 11, 7, 10, 8, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 6, 12, 9, 10, 8, 11, 7, 1, 6, 2, 5, 3, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 7, 4, 12, 5, 3, 6, 2, 7, 1, 8, 11, 9, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 8, 12, 10, 11, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 9, 5, 12, 6, 4, 7, 3, 8, 2, 9, 1, 10, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 10, 12, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 11, 6, 12, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 12, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 13, 7, 12, 6, 8, 5, 9, 4, 10, 3, 11, 2, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 14, 12, 2, 1, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 15, 8, 12, 7, 9, 6, 10, 5, 11, 4, 1, 3, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 16, 12, 3, 2, 4, 1, 5, 11, 6, 10, 7, 9, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 17, 9, 12, 8, 10, 7, 11, 6, 1, 5, 2, 4, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 18, 12, 4, 3, 5, 2, 6, 1, 7, 11, 8, 10, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 19, 10, 12, 9, 11, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 20, 12, 5, 4, 6, 3, 7, 2, 8, 1, 9, 11, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 21, 11, 12, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (10, 12, 22, 12, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 1, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 2, 12, 7, 8, 6, 9, 5, 10, 4, 11, 3, 1, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 3, 2, 12, 3, 1, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 4, 12, 8, 9, 7, 10, 6, 11, 5, 1, 4, 2, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 5, 3, 12, 4, 2, 5, 1, 6, 11, 7, 10, 8, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 6, 12, 9, 10, 8, 11, 7, 1, 6, 2, 5, 3, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 7, 4, 12, 5, 3, 6, 2, 7, 1, 8, 11, 9, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 8, 12, 10, 11, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 9, 5, 12, 6, 4, 7, 3, 8, 2, 9, 1, 10, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 10, 12, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 11, 6, 12, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 12, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 13, 7, 12, 6, 8, 5, 9, 4, 10, 3, 11, 2, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 14, 12, 2, 1, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 15, 8, 12, 7, 9, 6, 10, 5, 11, 4, 1, 3, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 16, 12, 3, 2, 4, 1, 5, 11, 6, 10, 7, 9, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 17, 9, 12, 8, 10, 7, 11, 6, 1, 5, 2, 4, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 18, 12, 4, 3, 5, 2, 6, 1, 7, 11, 8, 10, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 19, 10, 12, 9, 11, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 20, 12, 5, 4, 6, 3, 7, 2, 8, 1, 9, 11, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 21, 11, 12, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (7, 12, 22, 12, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 1, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 2, 12, 7, 8, 6, 9, 5, 10, 4, 11, 3, 1, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 3, 2, 12, 3, 1, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 4, 12, 8, 9, 7, 10, 6, 11, 5, 1, 4, 2, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 5, 3, 12, 4, 2, 5, 1, 6, 11, 7, 10, 8, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 6, 12, 9, 10, 8, 11, 7, 1, 6, 2, 5, 3, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 7, 4, 12, 5, 3, 6, 2, 7, 1, 8, 11, 9, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 8, 12, 10, 11, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 9, 5, 12, 6, 4, 7, 3, 8, 2, 9, 1, 10, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 10, 12, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 11, 6, 12, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 12, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 13, 7, 12, 6, 8, 5, 9, 4, 10, 3, 11, 2, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 14, 12, 2, 1, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 15, 8, 12, 7, 9, 6, 10, 5, 11, 4, 1, 3, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 16, 12, 3, 2, 4, 1, 5, 11, 6, 10, 7, 9, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 17, 9, 12, 8, 10, 7, 11, 6, 1, 5, 2, 4, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 18, 12, 4, 3, 5, 2, 6, 1, 7, 11, 8, 10, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 19, 10, 12, 9, 11, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 20, 12, 5, 4, 6, 3, 7, 2, 8, 1, 9, 11, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 21, 11, 12, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (8, 12, 22, 12, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 1, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 2, 12, 7, 8, 6, 9, 5, 10, 4, 11, 3, 1, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 3, 2, 12, 3, 1, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 4, 12, 8, 9, 7, 10, 6, 11, 5, 1, 4, 2, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 5, 3, 12, 4, 2, 5, 1, 6, 11, 7, 10, 8, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 6, 12, 9, 10, 8, 11, 7, 1, 6, 2, 5, 3, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 7, 4, 12, 5, 3, 6, 2, 7, 1, 8, 11, 9, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 8, 12, 10, 11, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 9, 5, 12, 6, 4, 7, 3, 8, 2, 9, 1, 10, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 10, 12, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 11, 6, 12, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 12, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 13, 7, 12, 6, 8, 5, 9, 4, 10, 3, 11, 2, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 14, 12, 2, 1, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 15, 8, 12, 7, 9, 6, 10, 5, 11, 4, 1, 3, 2, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 16, 12, 3, 2, 4, 1, 5, 11, 6, 10, 7, 9, 8, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 17, 9, 12, 8, 10, 7, 11, 6, 1, 5, 2, 4, 3, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 18, 12, 4, 3, 5, 2, 6, 1, 7, 11, 8, 10, 9, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 19, 10, 12, 9, 11, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 20, 12, 5, 4, 6, 3, 7, 2, 8, 1, 9, 11, 10, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 21, 11, 12, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (9, 12, 22, 12, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 1, 1, 14, 2, 13, 3, 12, 4, 11, 5, 10, 6, 9, 7, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 2, 14, 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 1, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 3, 2, 14, 3, 1, 4, 13, 5, 12, 6, 11, 7, 10, 8, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 4, 14, 9, 10, 8, 11, 7, 12, 6, 13, 5, 1, 4, 2, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 5, 3, 14, 4, 2, 5, 1, 6, 13, 7, 12, 8, 11, 9, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 6, 14, 10, 11, 9, 12, 8, 13, 7, 1, 6, 2, 5, 3, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 7, 4, 14, 5, 3, 6, 2, 7, 1, 8, 13, 9, 12, 10, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 8, 14, 11, 12, 10, 13, 9, 1, 8, 2, 7, 3, 6, 4, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 9, 5, 14, 6, 4, 7, 3, 8, 2, 9, 1, 10, 13, 11, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 10, 14, 12, 13, 11, 1, 10, 2, 9, 3, 8, 4, 7, 5, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 11, 14, 13, 1, 12, 2, 11, 3, 10, 4, 9, 5, 8, 6, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 12, 6, 14, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12, 13, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 13, 7, 14, 8, 6, 9, 5, 10, 4, 11, 3, 12, 2, 13, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 14, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 15, 8, 14, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 1, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 16, 14, 2, 1, 3, 13, 4, 12, 5, 11, 6, 10, 7, 9, 8, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 17, 9, 14, 8, 10, 7, 11, 6, 12, 5, 13, 4, 1, 3, 2, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 18, 14, 3, 2, 4, 1, 5, 13, 6, 12, 7, 11, 8, 10, 9, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 19, 10, 14, 9, 11, 8, 12, 7, 13, 6, 1, 5, 2, 4, 3, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 20, 14, 4, 3, 5, 2, 6, 1, 7, 13, 8, 12, 9, 11, 10, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 21, 11, 14, 10, 12, 9, 13, 8, 1, 7, 2, 6, 3, 5, 4, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 22, 14, 5, 4, 6, 3, 7, 2, 8, 1, 9, 13, 10, 12, 11, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 23, 12, 14, 11, 13, 10, 1, 9, 2, 8, 3, 7, 4, 6, 5, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 24, 13, 14, 12, 1, 11, 2, 10, 3, 9, 4, 8, 5, 7, 6, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 25, 14, 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 13, 12, NULL, NULL)
GO
INSERT [dbo].[FixtureGrids] ([SectionID], [SectionSize], [WeekNo], [h1], [a1], [h2], [a2], [h3], [a3], [h4], [a4], [h5], [a5], [h6], [a6], [h7], [a7], [h8], [a8]) VALUES (5, 14, 26, 14, 7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1, 13, NULL, NULL)
GO

SET IDENTITY_INSERT [dbo].[Teams] ON 

INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1331, 6, 13, 44, N'B', N'07881946276', N'doug heathcote', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (2, 2, 8, 31, N'D', N'07707 583038', N'Joe Portelli', N'fini1948@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (5, 2, 14, 6, N'B', N'07900008631', N'Martin Burgess', N'martin.budgie@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (7, 1, 12, 25, N' ', N'07952 343644', N'Ian Shepherd', N'I.sheppy@yahoo.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (8, 1, 13, 46, N' ', N'07977330472', N'Bob Pickup', N'bobthescrap@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (9, 3, 6, 44, N'A', N'539480', N'Tim Whitehouse', N'dillibards@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (10, 1, 2, 21, N'B', N'07876506486', N'James Scholefield', N'mrjims@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (11, 1, 5, 13, N'A', N'07786620814', N'Dave Wenzel', N'davidmichael.wenzel@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (12, 3, 11, 5, N'B', N'07976260758', N'Jeff Waters', N'jeffwaters57@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (14, 2, 4, 15, N' ', N'07708790150', N'lee shaw', N'Lds1985@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (16, 1, 7, 6, N'D', N'07791574081', N'Mark Bentley', N'long50shanks@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (18, 2, 3, 41, N'A', N'', N'Pat Daw', N'marytkelly51@yahoo.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (20, 2, 10, 11, N'C', N'07831942970', N'Derek Frost', N'derek.frost@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (22, 4, 8, 27, N' ', N'07428117790', N'David Crosbie', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (25, 4, 14, 48, N'B', N'07812818088', N'Steve Holmes', N'holmes.stephen7@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (26, 1, 8, 24, N' ', N'07879060368', N'Dean Poutney', N'r_dean@live.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (27, 4, 7, 43, N'A', N'07788292461', N'Lee Quarmby', N'lucyandleeq@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (28, 6, 8, 26, N'A', N'07708339135', N'John Shaw', N'shawbros9.john@uwclub.net')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (29, 1, 14, 23, N'A', N'07811389501', N'Paul Bodsworth', N'paul.bodsworth@weirgroup.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (30, 4, 6, 7, N' ', N'07740123588', N'Andrew Marsden', N'andrew@marsden20.orangehome.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (32, 1, 11, 20, N'B', N'07904244200', N'Martin Taylor', N'martinvegas99@yahoo.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (34, 1, 9, 21, N'A', N'07767447695', N'Graham Jordan', N'snookera@lindleylib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (36, 5, 6, 1, N'A', N'07917631421', N'Steve Taylor', N'steviet6274@yahoo.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1332, 10, 11, 34, N' ', N'07894890387', N'PaulGarraty', N'paul.garraty@sky.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (38, 2, 6, 35, N'A', N'', N'Gareth Shaw', N'dyers@huddersfielddyeing.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (39, 3, 5, 34, N' ', N'07894890387', N'PaulGarraty', N'paul.garraty@sky.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (40, 3, 7, 48, N'A', N'07803702036', N'Gordon Bennett', N'gordon.bennett@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (41, 3, 9, 45, N'B', N'07804607676', N'Sully hussain', N'Sultanhussain216@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (42, 1, 10, 16, N'A', N'07854906729', N'James Watson', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (43, 2, 5, 14, N'B', N'07889 056342', N'Wayne Baker', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (45, 5, 3, 33, N'A', N'07949061007', N'Keith Gledhill', N'keith2109@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (48, 4, 4, 20, N'A', N'07950231017', N'ian hoyle', N'mcbeal88@googlemail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (50, 2, 13, 35, N'B', N'07584 669228', N'N Brook', N'brook147@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (52, 3, 8, 31, N'A', N'07889 292985', N'Philip Headey', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (53, 2, 1, 26, N'B', N'07725354502', N'Charlie Shaw', N'charlieshaw82@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (54, 3, 13, 18, N' ', N'07749459628', N'Paul Schofield', N'scoff@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (55, 5, 14, 11, N'B', N'07795 511960', N'Tim Huntington', N'tim_huntington@live.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1333, 7, 8, 33, N'A', N'07724845837', N'Mervyn Williams', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1334, 10, 12, 32, N' ', N'07456494788', N'Martin Wood', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (60, 6, 11, 3, N'A', N'07850593826', N'Richard B. Gee', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (64, 4, 3, 19, N'B', N'', N'Paul Johnson', N'johno56pj@googlemail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (65, 5, 1, 6, N'C', N'07790617893', N'Mick Howlett', N'nis795649@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (66, 3, 2, 28, N'A', N'07908619153', N'Graham Whitehouse', N'open.a@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (67, 3, 1, 31, N'B', N'07889292985', N'Malcolm Waddington', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1335, 4, 9, 55, N'A', N'07771897226', N'Mark Heap', N'markheap13@googlemail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (69, 1, 4, 5, N'A', N'01484539416', N'David Walsh', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (70, 5, 7, 29, N'A', N'07801469636', N'Alan Heywood', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (71, 3, 12, 2, N'A', N'07922442795', N'Bart O''Toole', N'bart.otoole@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (73, 4, 12, 37, N'B', N'', N'Derek Hey', N'derekhey@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1336, 4, 2, 55, N'B', N'07910367980', N'Paul Baxter', N'paulnigelbaxter@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1337, 9, 6, 15, N' ', N'', N'Eddie Charlotte', N'e.j.charlotte2@live.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (76, 5, 13, 1, N'B', N'', N'Martin Sykes', N'martin.sykes@capitafinancial.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (77, 6, 14, 29, N'B', N'07722491534', N'Neil Hinchliffe', N'neilhinchliffe@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (80, 3, 10, 19, N'A', N'07748225769', N'Neil armstrong', N'neil.armstrong2@tiscali.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (82, 4, 1, 31, N'C', N'07880 682586', N'James Bloom', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (84, 3, 3, 16, N'C', N'07853451745', N'James Dolan', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (85, 6, 4, 3, N'C', N'07855939228', N'Andy Middleton', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (86, 1, 6, 32, N'A', N'07718127383', N'Chris Heywood', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1338, 2, 12, 39, N'A', N'07787708027', N'Neil Boustead', N'mattbarrett1908@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (90, 5, 2, 45, N'A', N'07804883992', N'Kyle keyworth', N'Kyleelnino96@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (92, 5, 12, 14, N'A', N'', N'Eddie Charlotte', N'ej.charlotte@live.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (93, 3, 4, 3, N'B', N'07795273007', N'Syd Cogger', N'sydmc8@virginmedia.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (95, 2, 9, 28, N'B', N'07769742934', N'Rob Armitage', N'open.b@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (96, 6, 2, 12, N' ', N'01484325079', N'Dave Peacock', N'barbara.peacock@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (191, 6, 1, 49, N'A', N'07932616563', N'Alex tattersley', N'Alextatterlsey123@outlook.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (146, 6, 10, 41, N'B', N'', N'Max Crines', N'marytkelly51@yahoo.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (147, 5, 9, 28, N'C', N'07713123366', N'Martin Garside', N'open.c@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1339, 10, 6, 55, N'A', N'07456494788', N'Martin Wood', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (153, 5, 10, 33, N'B', N'07724845837', N'Andrew Wike', N'barbarawike@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (194, 1, 1, 31, N'E', N'07718 770002', N'Mark White', N'christine.white@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (97, 7, 9, 37, N'C', N'01484689458', N'PETER BOOTH', N'31peterbooth@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (103, 8, 3, 31, N'A', N'07722995102', N'Malcolm Waddington', N'mandpwad@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1340, 7, 7, 51, N' ', N'07890032041', N'Pete Gilbert', N'gilbertp@outlook.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (158, 7, 10, 28, N'C', N'07596130559', N'Billy Keenan', N'vets.c@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (108, 7, 1, 29, N'A', N'07840966936', N'David J Simmons', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (106, 8, 2, 11, N'A', N'07305226468', N'John Moorhouse', N'johnmoorhouse285@yahoo.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (107, 9, 11, 4, N'A', N'07778490379', N'NEIL WIMPENNY', N'wimpenny121@btinternet.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (119, 8, 11, 5, N'A', N'01484539416', N'David Walsh', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (132, 7, 3, 37, N'A', N'07740 100443', N'Dennis Lomax', N'd.lomax349@btinternet.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (114, 8, 9, 31, N'B', N'07880 682586', N'John Earnshaw', N'john_earnshaw@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (117, 8, 1, 11, N'C', N'01484846355', N'Trevor Bullas', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1341, 6, 9, 21, N'C', N'07446822998', N'Neil Armstrong', N'n31l.armstrong@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1342, 8, 5, 4, N'B', N'07778490379', N'NEIL WIMPENNY', N'wimpenny121@btinternet.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (99, 7, 4, 40, N'A', N'07414101943', N'David Hardy', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1343, 4, 5, 37, N'A', N'01484689458', N'peter booth', N'31peterbooth@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (122, 9, 3, 41, N' ', N'01484312176', N'John Comerford', N'jmcomerford52@googlemail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (124, 8, 7, 11, N'B', N'07831942970', N'Derek Frost', N'derek.frost@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (100, 8, 4, 28, N'A', N'07927228688', N'Keith Forward', N'vets.a@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (123, 8, 6, 44, N'B', N'07930143801', N'Dave tyas', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (164, 9, 2, 31, N'C', N'07707583038', N'Joe Portelli', N'fini1948@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (131, 9, 9, 28, N'B', N'07445994791', N'Geoff Ramm', N'vets.b@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (120, 9, 7, 29, N'B', N'07879534748', N'Geoff Chadwick', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (111, 7, 2, 33, N'B', N'07870 296587', N'Sean Mulhall', N'seanmulhall963@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (133, 10, 8, 48, N'A', N'07812818088', N'Steve Holmes', N'holmes.stephen7@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1344, 7, 6, 20, N'A', N'07443003730', N'James Mclellan', N'jamese.mclellan@virginmedia.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (134, 10, 5, 44, N' ', N'07403700897', N'Tim Whitehouse', N'dillibards@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (267, 4, 13, 32, N'B', N'07799060705', N'John Siswick', N'john.andviv@btinternet.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (160, 10, 9, 28, N'A', N'07769742934', N'Robert Armitage', N'billiards.a@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (139, 10, 10, 7, N' ', N'01484667460', N'Matthew Peaker', N'peakersydney@aol.com')
GO
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (141, 10, 3, 37, N'A', N'07516437974', N'derek hey', N'derekhey@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1345, 9, 8, 40, N'B', N'07903564726', N'John Allen', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (136, 10, 4, 21, N'A', N'01484535923', N'Brian Cousen', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (157, 10, 7, 31, N'A', N'07722995102', N'Malcolm Waddington', N'mandpwad@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (162, 10, 2, 48, N'B', N'07379851032', N'John Wilson', N'johnwilson556@virginmedia.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1346, 6, 12, 13, N'B', N'07462864737', N'wayne booth', N'davidmichael.wenzel@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1347, 6, 5, 10, N'A', N'07702321835', N'Tony Proctor', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (4, 1, 3, 11, N'A', N'07840580869', N'Haydn Corbett', N'haydncorbett59@hotmail.co')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (212, 2, 11, 40, N'A', N'07984555396', N'John Wise', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (235, 8, 12, 3, N' ', N'01484 685575', N'John Bowden', N'jonib_bowden@hotmail.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (239, 8, 8, 52, N'B', N'07701038639', N'John Lea', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1348, 3, 14, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (241, 2, 2, 28, N'D', N'07878378875', N'Darren Bottomley', N'open.d@marshlib.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (253, 4, 10, 33, N'C', N'07870296587', N'Sean Mulhall', N'seanmulhall963@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1349, 2, 7, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (214, 7, 11, 23, N' ', N'07910019206', N'Chris Ball', N'robinball2017@outlook.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1351, 5, 11, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (216, 5, 8, 31, N'F', N'07447 473701', N'Cameron Gibson', N'camz90@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1352, 6, 6, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (219, 5, 5, 2, N'B', N'07733937000', N'Philip Bermingham', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (259, 7, 12, 19, N'A', N'07748225769', N'Neil armstrong', N'neil.armstrong2@tiscali.co.uk')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (260, 5, 4, 40, N'B', N'07973197441', N'Richard Whitcombe', N'rwhitcombe@talktalk.net')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (262, 7, 5, 5, N'B', N'0148340128', N'Malcolm Smith', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (279, 9, 10, 53, N'A', N'01484689904', N'Robert Barlow', N'silverdale2@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (280, 9, 5, 1, N' ', N'01484302203', N'Eric Abbott', N'jezwhitehead@hotmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (281, 9, 1, 45, N' ', N'07982479486', N'martin hussain', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1353, 6, 7, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (283, 10, 1, 31, N'B', N'07718770002', N'Mark White', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (284, 6, 3, 33, N'D', N'07724845837', N'Richard Gallagher', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (285, 9, 4, 54, N' ', N'07954794825', N'Colin Binns', N'colin.binns@ntlworld.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1354, 9, 12, 8, N' ', N'', N'', N'')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (287, 8, 10, 48, N'A', N'07803702036', N'Gordon Bennett', N'gordonb152@gmail.com')
INSERT [dbo].[Teams] ([ID], [SectionID], [FixtureNo], [ClubID], [Team], [TelNo], [Contact], [eMail]) VALUES (1350, 4, 11, 8, N' ', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[Teams] OFF

commit tran 
