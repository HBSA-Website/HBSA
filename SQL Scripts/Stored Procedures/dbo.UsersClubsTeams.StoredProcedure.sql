use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='UsersClubsTeams')
	drop procedure dbo.UsersClubsTeams
GO


create procedure dbo.UsersClubsTeams
	(@userType char(4)
	,@LeagueID int = 0
	)
as

set nocount on

if @UserType='Club'
	select ID
	      ,Name=[Club Name] 
		from Clubs 
		where [Club Name] <> 'Bye'
		order by [Club Name]
else 
	select ID=Teams.ID
	      ,[Name] = [Club Name] + ' ' + Team + ' (' + [League Name] + ')' 
		from Teams 
		join clubs on Clubs.ID = ClubID  
		join Sections on Sections.ID = SectionID
		join Leagues on Leagues.ID = LeagueID
		where [Club Name] <> 'Bye'
		order by [Name]


GO

