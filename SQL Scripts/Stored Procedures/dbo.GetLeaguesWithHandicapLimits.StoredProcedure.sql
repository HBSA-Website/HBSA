USE [HBSA]
GO

alter procedure [dbo].GetLeaguesWithHandicapLimits

as

set nocount on

select 
	 ID	= isnull(ID,'')
	,[League Name]	= isnull([League Name],'')
	,MaxHandicap=case when MaxHandicap=dbo.MaximumInteger() then 'No Limit' else convert(varchar,MaxHandicap) end
	,MinHandicap=case when MinHandicap=dbo.MinimumInteger() then 'No Limit' else convert(varchar,MinHandicap) end

	from Leagues 
	ORDER BY ID

GO
exec GetLeaguesWithHandicapLimits
select * from Leagues