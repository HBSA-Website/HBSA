USE [HBSA]
GO
if exists (select top 1 ID from ResultsUsers)
	drop table ResultsUsers
GO
CREATE TABLE ResultsUsers(
	[eMailAddress] [varchar](255) NOT NULL,
	[Password] [varchar](255) NOT NULL,
	[Confirmed] [varchar](10) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Telephone] [varchar](25) NULL,
	[TeamID] [int] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ResultsUsers] PRIMARY KEY CLUSTERED 
(
	[eMailAddress] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Index [IX_ResultsUsers_Team]    Script Date: 26/09/2018 14:44:55 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ResultsUsers_Team] ON [dbo].[ResultsUsers]
(
	[eMailAddress] ASC,
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

