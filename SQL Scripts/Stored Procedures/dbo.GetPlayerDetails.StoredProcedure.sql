USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetails')
	drop procedure GetPlayerDetails
GO
CREATE procedure [dbo].[GetPlayerDetails]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Team char(1) = ''
	)

as 

set nocount on

select  Forename, Initials, Surname, Handicap, [Club Name],Team,Played,Tagged,[Over70(80 Vets)]=Over70,email,TelNo
      ,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID 
	from PlayerDetails
	where (@LeagueID=0 or @LeagueID=LeagueID)
	  and (@SectionID=0 or @SectionID=SectionID)
	  and (@ClubID=0 or @ClubID=ClubID)
	  and (@Team='' or @Team=Team)
	order by LeagueID,SectionID,[Club Name], Team


GO
