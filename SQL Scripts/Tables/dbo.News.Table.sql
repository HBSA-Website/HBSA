USE [HBSA]
GO
/****** Object:  Table [dbo].[News]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[ID] [int] NULL,
	[Title] [nvarchar](50) NULL,
	[Article] [nvarchar](max) NULL,
	[Date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
