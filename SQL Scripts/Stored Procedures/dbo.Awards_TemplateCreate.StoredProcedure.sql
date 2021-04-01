use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TemplateCreate')
	drop procedure dbo.Awards_TemplateCreate
GO

create procedure dbo.Awards_TemplateCreate
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


if exists (select * from Awards_Template 
					where @AwardType = AwardType
					  and isnull(@AwardID,-1)   = isnull(AwardID,-1)
					  and isnull(@SubID,-1)     = isnull(SubID,-1)
					  and @LeagueID  = LeagueID)
	raiserror('Cannot create Awards Template as it already exists',17,17)

else
                    
	insert Awards_Template
		select 
			 @AwardType 
			,@AwardID 
			,@SubID 
			,@LeagueID 
			,@Trophy 
			,@Award 
			,@MultipleWinners
			,@RecipientType
GO

select * from Awards_Template
exec Awards_TemplateData 1,9,1,2