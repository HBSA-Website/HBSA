USE [HBSA]
if exists (Select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FullTeamList')
	drop procedure FullTeamList
GO

create procedure dbo.FullTeamList

as

set nocount on	

select T.ID, Team= [Club Name] + ' ' + Team + ' - ' + [League Name] + case when [Section Name] = '' then '' else ' (' + rtrim([Section Name]) + ')' end
	from    Teams T 
	join Clubs C on C.ID=T.ClubID
	join Sections S on S.ID = SectionID
	join Leagues L on L.ID=LeagueID
	where [Club Name] <> 'Bye'

order by Team

GO

exec FullTeamList