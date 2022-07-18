USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[updateLeaguePointsAdjustment]    Script Date: 12/12/2014 17:46:01 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='insertLeaguePointsAdjustment')
	drop procedure dbo.insertLeaguePointsAdjustment
GO

create procedure [dbo].[insertLeaguePointsAdjustment]
	(@TeamID int
	,@Points dec(9,1)
	,@Comment varchar(255)
	,@CreatedBy varchar(50)
	)
as

set nocount on

	insert LeaguePointsAdjustment
		select @TeamID
		 	  ,@Points
			  ,@Comment
			  ,dbo.UKdateTime(getUTCdate())
			  ,@CreatedBy

GO
