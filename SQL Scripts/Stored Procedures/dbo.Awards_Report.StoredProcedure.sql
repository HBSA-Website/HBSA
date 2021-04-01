USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_Report')
	drop procedure dbo.Awards_Report
GO

create procedure dbo.Awards_Report
	@AwardType int = 0
as

set nocount ON

select distinct
      [League Name]
     , Competition
	 , Trophy
	 , Winner=dbo.Award_Recipient(EntrantID,Entrant2ID,T.RecipientType,T.AwardType)
	 , Award
	 ,A.*
	from Awards A
	join Awards_TemplateDetails T   -- Note this must not be outer join (to filter out possible unwanted runners up etc)
	  on A.LeagueID  = T.LeagueID
	 and A.AwardType = T.AwardType
	 and isnull(A.AwardID,-1)   = case when A.awardType in (4,5,6) then -1 else T.AwardID end  
	 and isnull(A.SubID,-1)	 = case when A.awardType in (3,4,5,6) then -1 else T.SubID end

	where A.AwardType = @AwardType or @AwardType = 0

	order by A.LeagueID, A.AwardType, A.AwardID, A.SubID

GO

exec Awards_Report 3