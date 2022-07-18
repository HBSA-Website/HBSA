USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[updateLeaguePointsAdjustment]    Script Date: 12/12/2014 17:46:01 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='DeleteLeaguePointsAdjustment')
	drop procedure dbo.DeleteLeaguePointsAdjustment
GO

create procedure [dbo].[DeleteLeaguePointsAdjustment]
	(@AdjustmentID int
	)
as

set nocount on

	delete LeaguePointsAdjustment
		Where ID =  @AdjustmentID

GO
