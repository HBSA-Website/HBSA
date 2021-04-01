USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Awards_TemplateCompetition')
	drop function Awards_TemplateCompetition
GO

CREATE function dbo.Awards_TemplateCompetition
	(@AwardType int
	,@AwardID int = NULL
	,@SubId int = NULL
	,@LeagueID int = NULL
	)
returns varchar(255)

as

begin

declare @Competition varchar(255)
select @Competition = replace (replace (replace (replace (replace (replace
							(AT.[Name],'[League]',isnull([League Name],'[League]'))
							          ,'[Competition]',isnull(C.Name,'[Competition]')) 
							          ,'[Section]',isnull([Section Name],'[Section]'))
									  ,'[Position]', case when isnull(@SubID,0)=0 then '[Position]'
									                      when @SubID=1 then 'Winner' 
									                      when @SubID=2 then 'Runner up' 
														  else 'Semi Finalist' 
													  end )
									  ,'[LowHandicap]', case when LowHandicap is null then '[LowHandicap]'
									                         when LowHandicap = dbo.MinimumInteger() then 'No limit'
															 else convert(varchar,LowHandicap)
                                                         end )
									  ,'[HighHandicap]', case when HighHandicap is null then '[HighHandicap]'
									                          when HighHandicap = dbo.MaximumInteger() then 'No limit'
									                          else convert(varchar, HighHandicap)
                                                         end ) 																									                                                                                                                                 
	  
	from Awards_Types AT
	Outer apply (select [League Name] from Leagues where ID=@LeagueID) L
	outer apply (select [Section Name] from sections where ID=@AwardID) S
	outer apply (select Name from Competitions where ID=@AwardID) C
	outer apply (select * from BreaksCategories where LeagueID=@LeagueID and ID=@AwardID) B
	
	where AwardType=@AwardType

return @Competition

end

go

select * from Awards_TemplateDetails where AwardType=3 and LeagueID=3
select dbo.MaximumInteger(), dbo.MinimumInteger()