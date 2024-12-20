USE [HBSA]
GO
/****** Object:  Table [dbo].[admin]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin](
	[Username] [varchar](50) NULL,
	[Password] [varchar](255) NULL,
	[Forename] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Email] [varchar](255) NULL,
	[Function] [varchar](255) NULL
) ON [PRIMARY]
CREATE UNIQUE CLUSTERED INDEX [adminUsernames] ON [dbo].[admin]
(username)
GO

GO
