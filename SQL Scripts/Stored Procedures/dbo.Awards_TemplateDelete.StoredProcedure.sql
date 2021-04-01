use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TemplateDelete')
	drop procedure dbo.Awards_TemplateDelete
GO

create procedure dbo.Awards_TemplateDelete
	(@AwardType int
	,@AwardID int
	,@SubID int
	,@LeagueID int
	,@Override bit = 0
	)
as

set nocount on

if exists (select * from Awards 
					where @AwardType = AwardType
					  and isnull(@AwardID,-1)   = isnull(AwardID,-1)
					  and isnull(@SubID,-1)     = isnull(SubID,-1)
					  and @LeagueID  = LeagueID)
and @Override <> 1
	raiserror('There is a linked award',17,17)

else
         
	delete Awards_Template
		where @AwardType = AwardType
		  and isnull(@AwardID,-1)   = isnull(AwardID,-1)
		  and isnull(@SubID,-1)     = isnull(SubID,-1)
		  and @LeagueID  = LeagueID

GO
exec Awards_TemplateDelete 1,1,1,1
