USE [HBSA]
GO

if exists (select VIEW_NAME from INFORMATION_SCHEMA.VIEW_TABLE_USAGE where VIEW_NAME = 'Awards_TemplateDetails')
	drop view Awards_TemplateDetails
GO

CREATE View dbo.Awards_TemplateDetails

as

select [League Name]
      ,Competition = dbo.Awards_TemplateCompetition(AwardType,AwardID,SubID,LeagueID)
	  ,AT.*
	  
from Awards_Template AT
outer apply(select [League Name] from leagues where ID=leagueID) x

GO

select * from Awards_TemplateDetails
	order by LeagueID, AwardType, AwardID, SubID


