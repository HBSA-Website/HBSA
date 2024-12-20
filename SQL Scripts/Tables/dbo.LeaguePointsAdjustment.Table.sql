USE [HBSA]
GO
/****** Object:  Table [dbo].[LeaguePointsAdjustment]    Script Date: 12/12/2014 17:41:30 ******/
if exists(select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LeaguePointsAdjustment')
	begin
	DROP INDEX [IX_LeaguePointsAdjustment] ON [dbo].[LeaguePointsAdjustment]
	drop table [dbo].[LeaguePointsAdjustment]
	end
GO
CREATE TABLE [dbo].[LeaguePointsAdjustment](
	[TeamID] [int] NOT NULL,
	[Points] dec(9,1) NULL,
	[Comment] [varchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	ID int identity (1,1)
	)
 
GO
CREATE NONCLUSTERED INDEX [IX_LeaguePointsAdjustment] ON [dbo].[LeaguePointsAdjustment]
(
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
