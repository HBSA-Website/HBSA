USE [HBSA]
GO
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetAllTeams')
	drop procedure dbo.GetAllTeams
GO

create procedure [dbo].[GetAllTeams]
	(@LeagueID int = 0
	,@SectionID int = 0
	)

as

set nocount on

select
	 TeamsDetails.ID
	,[Club Name]=isnull([Club Name],'')
	,ClubID
	,Team
	,League=isnull([League Name],'')+' '+isnull([Section Name],'')
	,FixtureNo
	,[Captain/Contact]=isnull(Contact,'')
	,eMail=isnull(eMail,'')
	,TelNo=isnull(TelNo,'')
	,Captain

	from TeamsDetails 
	left join Sections on Sections.ID=SectionID
	left join Leagues on Leagues.ID=LeagueID
	join Clubs on Clubs.ID=ClubID
	
	where (@LeagueID=0 or LeagueID=@LeagueID)
	  and (@SectionID=0 or SectionID=@SectionID)
	  --and [Club Name] <> 'Bye'
	
	order by LeagueID,SectionID,FixtureNo

GO
exec GetAllTeams 
