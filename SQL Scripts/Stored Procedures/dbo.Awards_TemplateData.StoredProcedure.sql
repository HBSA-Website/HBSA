use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TemplateData')
	drop procedure dbo.Awards_TemplateData
GO

create procedure dbo.Awards_TemplateData
	(@AwardType int
	,@AwardID int
	,@SubID int
	,@LeagueID int
	)
as

set nocount on

select * from  Awards_TemplateDetails
		where @AwardType = AwardType
		  and isnull(@AwardID,-1)   = isnull(AwardID,-1)
		  and isnull(@SubID,-1)     = isnull(SubID,-1)
		  and @LeagueID  = LeagueID

GO
exec Awards_TemplateData 3,1,null,1
