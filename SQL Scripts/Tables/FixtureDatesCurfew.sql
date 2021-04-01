USE [HBSA]
GO

/****** Object:  Table [dbo].[FixtureDatesCurfew]    Script Date: 05/02/2014 15:46:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FixtureDatesCurfew]') AND type in (N'U'))
DROP TABLE [dbo].[FixtureDatesCurfew]
GO

USE [HBSA]
GO

/****** Object:  Table [dbo].[FixtureDatesCurfew]    Script Date: 05/02/2014 15:46:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FixtureDatesCurfew](
	[LeagueID] [int] NULL,
	[StartDate] [date] NULL,
	[Enddate] [date] NULL
) ON [PRIMARY]

GO

insert FixtureDatesCurfew select 1,'20 dec 2013','1 jan 2014'
insert FixtureDatesCurfew select 2,'20 dec 2013','1 jan 2014'
insert FixtureDatesCurfew select 3,'20 dec 2013','1 jan 2014'
go
