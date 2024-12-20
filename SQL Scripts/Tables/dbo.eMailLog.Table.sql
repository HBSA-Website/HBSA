USE [HBSA]
GO
/****** Object:  Table [dbo].[eMailLog]    Script Date: 12/12/2014 17:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[eMailLog](
	[dtLodged] [datetime] NOT NULL,
	[Sender] [varchar](255) NULL,
	[ReplyTo] [varchar](512) NULL,
	[ToAddresses] [varchar](1024) NOT NULL,
	[CCAddresses] [varchar](512) NULL,
	[BCCAddresses] [varchar](512) NULL,
	[Subject] [varchar](255) NULL,
	[Body] [varchar](max) NULL,
	[MatchResultID] [int] NULL,
	[UserID] [varchar](255) NULL,
	[SMTPServer] [varchar](255) NULL,
	[SMTPPort] [int] NULL
) ON [PRIMARY] 

GO
SET ANSI_PADDING OFF
GO
