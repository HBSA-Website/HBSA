USE [HBSA]
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Fines')
	DROP TABLE [dbo].[Fines]
GO

CREATE TABLE [dbo].[Fines](
	[dtLodged] [datetime] NOT NULL,
	[ClubID] [int] NOT NULL,
	[Offence] [varchar](255) NOT NULL,
	[Comment] [varchar](255) NULL,
	[Fine] [decimal](5, 2) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL
) 
GO

SET ANSI_PADDING OFF
GO


