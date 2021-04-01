use HBSA

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_delete')
	drop procedure dbo.Awards_delete
GO

create procedure dbo.Awards_delete
	(@AwardType int
	,@AwardID int
	,@SubID int
	,@LeagueID int
	,@EntrantID int
	)
as

set nocount on
set xact_abort on

begin tran

delete Awards

	where AwardType = @AwardType
	  and isnull(AwardID,-1) = case when @AwardType in (4,5,6) then -1 else @AwardID end
	  and isnull(SubID,-1)   = case when @AwardType in (3,4,5,6) then -1 else @SubID end
	  and LeagueID  = @LeagueID
	  and EntrantID=@EntrantID

exec Awards_GenerateReportTable

commit tran
	
GO