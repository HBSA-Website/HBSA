USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[insertMatchBreak]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[insertMatchBreak]
	(@MatchResultID int
	,@PlayerID int
	,@Break int
	,@UserID varchar(255) = ''
	)
as

set nocount on

insert Breaks
	select @MatchResultID,@PlayerID,@Break 	
	
insert ActivityLog values
	(dbo.UKdateTime(getUTCdate()),'insert Match Break',SCOPE_IDENTITY(),@UserID)  



GO
