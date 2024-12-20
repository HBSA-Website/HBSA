USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetBreaksCategories2')
	drop procedure GetBreaksCategories2
GO

create procedure dbo.GetBreaksCategories2
	(@LeagueID int = 0
	)
as	

set nocount on

select [League Name]
      ,LeagueID
	  ,LowHandicap = case when LowHandicap = dbo.MinimumInteger() then 'No Lower Limit'
	                      when LowHandicap = dbo.MaximumInteger() then 'No Upper Limit'
						  else convert(varchar,LowHandicap)
                     end
	  ,HighHandicap = case when HighHandicap = dbo.MaximumInteger() then 'No Upper Limit'
	                       when HighHandicap = dbo.MinimumInteger() then 'No Lower Limit'
						   else convert(varchar,HighHandicap)
                     end
	  ,ID 
	from BreaksCategories 
	cross apply (select [League Name], MinHandicap, MaxHandicap from Leagues where ID=LeagueID) L
	where @LeagueID = 0
	   or @LeagueID = LeagueID
	order by ID

GO
exec GetBreaksCategories2 3
select * from BreaksCategories where LeagueID=1