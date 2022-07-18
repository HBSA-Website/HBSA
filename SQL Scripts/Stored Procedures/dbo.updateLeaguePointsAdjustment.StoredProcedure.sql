USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[updateLeaguePointsAdjustment]    Script Date: 12/12/2014 17:46:01 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='updateLeaguePointsAdjustment')
	drop procedure dbo.updateLeaguePointsAdjustment
GO

create procedure [dbo].[updateLeaguePointsAdjustment]
	(@AdjustmentID int
	,@Points dec(9,1)
	,@Comment varchar(255)
	,@CreatedBy varchar(50)
	)
as

set nocount on

	update LeaguePointsAdjustment
		set	Points=@Points
		   ,Comment=@Comment
		   ,CreatedDate=dbo.UKdateTime(getUTCdate())
		   ,CreatedBy=@CreatedBy
		where ID=@AdjustmentID

GO
