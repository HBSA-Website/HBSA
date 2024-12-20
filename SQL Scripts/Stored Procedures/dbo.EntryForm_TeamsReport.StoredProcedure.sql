USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_TeamsReport')
	DROP procedure EntryForm_TeamsReport
GO

create procedure EntryForm_TeamsReport
	@WIP int = 0 -- only report entries that have at least reached this stage

as

set nocount on
select League=[League Name] 
	  ,[Club Name]
      ,Team
	  ,OldSection=isnull([Section Name],'New Team')	
       
	from EntryForm_Clubs C
	join EntryForm_Teams T on T.ClubID=C.ClubID 
	join Leagues on ID=LeagueID 
	outer apply (select top 1 [Section name]
					from Teams 
					cross apply (select [Section name] from Sections where ID=SectionID) s
					where ClubID=C.ClubID
					  and Team=T.Team
					  and SectionID in (select ID from Sections where LeagueID=T.LeagueID)) Div

	where WIP >= @WIP
	  and WIP = case when @WIP = -2 then 1 else WIP end

	order by LeagueID,[Club Name],Team

GO

exec EntryForm_TeamsReport 2