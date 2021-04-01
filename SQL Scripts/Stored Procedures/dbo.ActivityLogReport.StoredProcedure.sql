use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ActivityLogReport')
	drop procedure dbo.ActivityLogReport
GO

create procedure dbo.ActivityLogReport
	(@From dateTime = NULL
	,@To datetime   = NULL
	,@Activity varchar(255)  = ''
	,@Action varchar(255)= ''
	,@What varchar(255) = ''      
	)
as

set nocount on

if @From is null
	select @From = min(dtLodged) from ActivityLog
if @To is null
	select @To = max(dtLodged) from ActivityLog

select [Date Time]=convert(varchar(17),dtLodged,113)
      ,Activity = left(Activity,30)
	  ,KeyID
	  ,byWhom = left(byWhom,30)
	  ,[Procedure]
	  ,[Key Words]
	  ,[Action]
	  ,KeyIDUse
	  ,Comment
      ,What = case when KeyIDUse = 'PlayerID' then 
			           (select 'Player: ' + dbo.FullPlayerName(Forename, initials, Surname) 
					        from players where ID=KeyID)
	               when KeyIDUse = 'ClubID' then 
				        (select 'Club: ' + [Club Name] 
						    from Clubs where ID = KeyID)
                   when KeyIDUse = 'MatchResultID' then 
						(select Match 
							from MatchResultsDetails4 where ID = KeyID)
                   when KeyIDUse = 'BreakID' then 
						(select 'Break of ' + convert(varchar,[Break]) + ' by ' + dbo.FullPlayerName(Forename,Initials,Surname) + ' in ' + Match 
							from (select * from Breaks_Deleted union select * from Breaks) B
							join MatchResultsDetails4 on MatchResultsDetails4.ID = B.MatchResultID
							join Players P on P.ID=PlayerID  
							where B.ID = KeyID)
				   else Activity
              end
			   
	from ActivityLog L

	left join ActivityLogMetadata M
	  on Activity like '%' + [Key words] + '%'

	where dtLodged between @From and @To 
	  and Activity like '%' + @Activity + '%'
	  and (@Action = '' or @Action = Action) 
	  and case when KeyIDUse = 'PlayerID' then 
			           (select 'Player: ' + dbo.FullPlayerName(Forename, initials, Surname) 
					        from players where ID=KeyID)
	               when KeyIDUse = 'ClubID' then 
				        (select 'Club: ' + [Club Name] 
						    from Clubs where ID = KeyID)
                   when KeyIDUse = 'MatchResultID' then 
						(select Match 
							from MatchResultsDetails4 where ID = KeyID)
                   when KeyIDUse = 'BreakID' then 
						(select 'Break of ' + convert(varchar,[Break]) + ' by ' + dbo.FullPlayerName(Forename,Initials,Surname) + ' in ' + Match 
							from (select * from Breaks_Deleted union select * from Breaks) B
							join MatchResultsDetails4 on MatchResultsDetails4.ID = B.MatchResultID
							join Players P on P.ID=PlayerID  
							where B.ID = KeyID)
				   else Activity
              end
			     like '%' + @What + '%'

	order by dtLodged desc

GO
