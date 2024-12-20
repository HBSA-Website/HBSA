USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionEntrants')
	drop procedure GetCompetitionEntrants
GO
create procedure GetCompetitionEntrants
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
	   ,@LeagueID int

select   @CompType = CompType 
		,@LeagueID=LeagueID
	from Competitions where ID=@CompetitionID

--get IDs already entered
create table #EntrantIDs (EntrantID int)
insert #EntrantIDs select EntrantID from Competitions_Entries where CompetitionID=@CompetitionID
insert #EntrantIDs select Entrant2ID from Competitions_Entries where CompetitionID=@CompetitionID and Entrant2ID is not null

if @CompType=4 
	begin
	select EntrantID = Teams.ID, 
	       Entrant = [Club Name] + ' ' + Team
		from Teams
		left join Clubs on Clubs.ID=ClubID
		left join Sections on Sections.ID=SectionID 
		left join #EntrantIDs E on E.EntrantID=Teams.ID
		where (LeagueID = @LeagueID or SectionID = -1)  --include comps only teams
		  and E.EntrantID is null
		  and [Club Name] <> 'Bye'
		order by [Club Name], Team
	end
else
	select
       EntrantID = Players.ID, 
       Entrant = dbo.FullPlayerName(Forename,Initials,Surname) +
				            case when @CompType <> 1 and @CompType <> 3 then ' (' + convert(varchar,Handicap) + ')' else '' end 
		from Players 	
		left join #EntrantIDs on #EntrantIDs.EntrantID = Players.ID
		where LeagueID=@LeagueID
		  and #EntrantIDs.EntrantID is null
		order by Entrant

drop table #EntrantIDs

GO
exec GetCompetitionEntrants 12
--1398