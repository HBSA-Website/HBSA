use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_GetFees')
	drop procedure EntryForm_GetFees
GO

create procedure EntryForm_GetFees

as

set nocount on

select Entity
	  ,LeagueID=isnull(LeagueID,0)
	  ,League=case when LeagueID=0 then 'Not League dependent' else isnull([League Name],'') end
	  ,Fee
	from EntryForm_Fees
	outer apply (select [League Name] 
					from Leagues
					where ID = LeagueID) l
	order by Entity, LeagueID
              

GO
exec EntryForm_GetFees