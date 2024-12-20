USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Award_Competition')
	drop function dbo.Award_Competition
GO

CREATE FUNCTION dbo.Award_Competition 
	(@EntrantID int
	,@Entrant2ID int
	,@AwardType int
	,@CompID int
	)

RETURNS varchar(255)

AS

BEGIN

case when AwardType=1 then [League Name]+' '+ [Section Name] + case when SubID = 1 then ' Winners' when SubId = 2 then ' Runners Up' end					  					                     
                    when AwardType=2 then Name  + case when SubID = 1 then ' Winner' when SubId = 2 then ' Runner Up' else ' Semi Finalist' end
					when AwardType=3 then 'Highest Break (' + [League Name] + ') - ['+convert(varchar,LowHandicap) + ' to ' + convert(varchar,HighHandicap) + ']'
					when AwardType=4 then 'Highest break in the ' + [League Name] + ' League'
					when AwardType=5 Then 'Best last 6 match results in the ' + [League Name] + ' League' 
					when AwardType=6 then 'Most Promising Young Player'
					                 else NULL
				end
return isnull(@Entrant,'')

END


GO

select dbo.Award_Recipient(1198,null,2,2)
select dbo.Award_Recipient(97,null,2,4)
