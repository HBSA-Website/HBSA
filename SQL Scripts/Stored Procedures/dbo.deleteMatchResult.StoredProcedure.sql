USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[deleteMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[deleteMatchResult]
	(@MatchResultID int
	,@UserID varchar(255)
	)
as

set nocount on
set xact_abort on

if @MatchResultID is not null
	begin
	
	begin tran
	
	if exists (select MatchResultID from Breaks where MatchResultID=@MatchResultID)
		begin
		insert into Breaks_Deleted select * from Breaks where MatchResultID=@MatchResultID
		delete from Breaks where MatchResultID=@MatchResultID
		end
	
	
	insert MatchResults_Deleted select * from MatchResults where ID = @MatchResultID
	delete matchResults where ID = @MatchResultID
	
	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate())
		,'delete match result: MatchresultID='+convert(varchar,@MatchresultID)
		,@MatchResultID
		,@Userid)
	
	commit tran
	
	end


GO
