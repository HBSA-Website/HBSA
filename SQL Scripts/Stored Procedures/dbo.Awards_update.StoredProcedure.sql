use HBSA

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_update')
	drop procedure dbo.Awards_update
GO

create procedure dbo.Awards_update
	(@AwardType int
	,@AwardID int
	,@SubID int
	,@LeagueID int
	,@EntrantID int
	,@Entrant2ID int = NULL
	)
as

set nocount on
set xact_abort on

begin tran

update Awards

	set EntrantID  = @EntrantID
	   ,Entrant2ID = @Entrant2ID

	where AwardType = @AwardType
	  and AwardID   = case when @awardType in (4,5,6) then NULL else @AwardID end
	  and SubID     = case when @SubID in (3,4,5,6) then NULL else @SubID end
	  and LeagueID  = @LeagueID
	
exec Awards_GenerateReportTable

commit tran
GO
exec Awards_update 4,null,null,2,912,null