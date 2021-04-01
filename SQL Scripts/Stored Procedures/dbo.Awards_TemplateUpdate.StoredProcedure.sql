use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TemplateUpdate')
	drop procedure dbo.Awards_TemplateUpdate
GO

create procedure dbo.Awards_TemplateUpdate
	(@AwardType int
	,@AwardID int
	,@SubID int
	,@LeagueID int
	,@Trophy varchar(255)
	,@Award varchar(255)
	,@MultipleWinners bit
	,@RecipientType varchar(15)
	)
as

set nocount on

update Awards_Template
	set Trophy	= @Trophy
	   ,Award	= @Award
	   ,MultipleWinners	= @MultipleWinners
	   ,RecipientType = @RecipientType
	where @AwardType = AwardType
	  and isnull(@AwardID,-1)   = isnull(AwardID,-1)
	  and isnull(@SubID,-1)     = isnull(SubID,-1)
	  and @LeagueID  = LeagueID

GO