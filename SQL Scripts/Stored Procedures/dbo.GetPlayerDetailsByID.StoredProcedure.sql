USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByID')
	drop procedure GetPlayerDetailsByID
GO

create procedure [dbo].[GetPlayerDetailsByID]
	(@PlayerID int
	)

as 

set nocount on

select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
       ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
	   ,fullName=dbo.FullPlayerName(Forename,Initials,Surname)
	from PlayerDetails P
	outer apply (select TeamEmail=eMail, TeamID=ID 
					from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
	outer apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
	where ID = @PlayerID
	
	order by LeagueID,SectionID,ClubID, Team


GO
exec GetPlayerDetailsByID 2429
