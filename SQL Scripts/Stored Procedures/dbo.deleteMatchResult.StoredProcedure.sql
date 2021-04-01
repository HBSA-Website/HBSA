USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[deleteMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[deleteMatchResult]
	(@HomeTeamID int
	,@AwayTeamID int
	,@UserID varchar(255)
	)
as

set nocount on
set xact_abort on

declare @MatchResultID int

select @MatchResultID = ID from matchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID

if @MatchResultID is not null
	begin
	
	begin tran
	
	if exists (select MatchResultID from Breaks where MatchResultID=@MatchResultID)
		begin
		insert into Breaks_Deleted select * from Breaks where MatchResultID=@MatchResultID
		delete from Breaks where MatchResultID=@MatchResultID
		end
	
	
	insert MatchResults_Deleted select * from MatchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID
	delete matchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID
	
	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate())
		,'delete match result: HomeTeamID='+convert(varchar,@HomeTeamID)+ ' and AwayTeamID='+convert(varchar,@AwayTeamID)
		,@MatchResultID
		,@Userid)
	
	commit tran
	
	end


GO
