USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerRecordsSeasons]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetPlayerRecordsSeasons]
	(@LeagueID int
	)
as

set nocount on
	
Select distinct Season from PlayerRecords
	where (LeagueID=@LeagueID or @LeagueID=0)
	order by Season


GO
