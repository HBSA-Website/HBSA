USE [HBSA]
GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[dtLodged] [datetime] NULL,
	[Activity] [varchar](3000) NULL,
	[KeyID] [int] NULL,
	[byWhom] [varchar](3000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
