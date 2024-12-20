USE [HBSA]
GO
/****** Object:  Table [dbo].[Clubs]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Clubs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Club Name] [varchar](50) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[PostCode] [char](8) NULL,
	[ContactName] [varchar](104) NULL,
	[ContactEMail] [varchar](250) NULL,
	[ContactTelNo] [varchar](20) NULL,
	[ContactMobNo] [varchar](20) NULL,
	[MatchTables] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
