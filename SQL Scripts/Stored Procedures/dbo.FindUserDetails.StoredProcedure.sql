use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FindUserDetails')
	drop procedure FindUserDetails
GO

create procedure FindUserDetails
	 (@ClubName varchar(50) = ''
	 ,@Team char(1) = ''
	 ,@LeagueID int = 0
	 )
as

set nocount on

select [Club Name],Team,[League Name], R.* 
	from ResultsUsers R
	cross apply (select ClubID, Team, SectionID from Teams where R.TeamID=ID) T
	cross apply (select [Club Name] from Clubs where T.ClubID=ID)C
	cross apply (select LeagueID from Sections where SectionID=ID) S
	cross apply (select [League Name] from Leagues where LeagueID=ID) L
    where (@ClubName='any' or [Club Name] like '%' + @Clubname + '%')
	  and (@Team='' or @Team=Team)
	  and (@LeagueID=0 or @LeagueID=LeagueID)
	order by LeagueID, [Club Name], Team
	   
GO

exec FindUserDetails 'Any','',0