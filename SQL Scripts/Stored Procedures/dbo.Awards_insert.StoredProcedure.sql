use HBSA

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_insert')
	drop procedure dbo.Awards_insert
GO

create procedure dbo.Awards_insert
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

if exists (select * from Awards 
                    where AwardType = @AwardType
					  and isnull(AwardID,-1)   = isnull(@AwardID,-1)
					  and isnull(SubID,-1)     = isnull(@SubID,-1)
					  and LeagueID  = @LeagueID) 
	if @AwardType <> 3
		raiserror ('Cannot insert as this award already exists',15,0)
	else
		BEGIN
		raiserror ('Warning this award already exists',15,0)
		insert Awards
			select
			   @AwardType
			  ,case when @AwardType in (4,5,6) then NULL else @AwardID end			
			  ,NULL
			  ,@LeagueID
			  ,@EntrantID
			  ,@Entrant2ID
		END
else

	insert Awards
		select
		   @AwardType
		  ,case when @AwardType in (4,5,6) then NULL else @AwardID end
		  ,case when @AwardType in (3,4,5,6) then NULL else @SubID end
		  ,@LeagueID
		  ,@EntrantID
		  ,@Entrant2ID

exec Awards_GenerateReportTable

commit tran

GO
