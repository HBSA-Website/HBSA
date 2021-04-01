USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[updateLeaguePointsAdjustment]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter procedure [dbo].[updateLeaguePointsAdjustment]
	(@TeamID int
	,@Points dec(9,1)
	,@Comment varchar(255)
	,@CreatedBy varchar(50)
	)
as

set nocount on

if exists (select TeamID from LeaguePointsAdjustment where TeamID=@TeamID)
	if @Points = 0
		delete LeaguePointsAdjustment
			where TeamID=@TeamID
	else
		update LeaguePointsAdjustment
			set	Points=@Points
			   ,Comment=@Comment
			   ,CreatedDate=dbo.UKdateTime(getUTCdate())
			   ,CreatedBy=@CreatedBy
			where TeamID=@TeamID
else
	insert LeaguePointsAdjustment 
		values
		(@TeamID 
		,@Points 
		,@Comment
		,dbo.UKdateTime(getUTCdate())
		,@CreatedBy 
		)
		


GO
