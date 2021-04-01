use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_AvailableAwards')
	drop procedure dbo.Awards_AvailableAwards
GO

create procedure dbo.Awards_AvailableAwards
	(@AllAwards tinyint = 0
	)

/*
	This procedure lists those awards from the awards template that 
	do not have a winner assigned, or all of them if @AllAwards is non zero
*/

as

select distinct T.* 

	from Awards_TemplateDetails T
	left join awards A
		   on A.awardType = T.awardType
          and isnull(A.AwardID,-1)   = isnull(T.AwardID,-1)
		  and isnull(A.SubID,-1)     = isnull(T.SubID,-1)
		  and A.LeagueID  = T.LeagueID
	where A.AwardType is null
	   or A.AwardType = 3 --can have multiple awards for highest break in category
	   or @AllAwards <> 0

	order by T.LeagueID
			,T.awardType
			,T.AwardID
			,T.Subid

GO

exec Awards_AvailableAwards 1
