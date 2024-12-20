USE [HBSA]
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='HandicapsReport')
	drop procedure dbo.HandicapsReport
GO

create procedure [dbo].[HandicapsReport] 
	(@LeagueID int = 0
	,@SectionID int = 0
	,@TeamID int = 0
	,@Forename varchar(50)=''
	,@Surname varchar(50)=''
	)

as

set nocount on
set xact_abort on

select Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+Teams.Team
      ,PlayerID
      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
      ,Tag=case when T.Tagged = 3 then 'Unseasoned'
	            when T.Tagged = 2 then '2 Seasons to go'
				when T.Tagged = 1 then '1 Season to go'
				else ''
           end 
      ,lastHandicapChange=convert(varchar(11),T.lastHandicapChange,113)
      ,[Over70(80 Vets)]=T.Over70
      ,T.Played
      ,T.Won
      ,T.Lost
      ,T.Delta
      ,T.Handicap
      ,[New Handicap]=case when T.Handicap <> T.[New Handicap] then T.[New Handicap] else NULL end
	from HandicapsReportTable T
	join Players on Players.ID=PlayerID
	join Sections on Sections.ID=T.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=Players.ClubID
	join Teams on teams.SectionID=T.SectionID and  Teams.ClubID=Players.ClubID and Teams.Team=Players.team

	where T.Effective=(select max(effective) from HandicapsReportTable where PlayerID=T.PlayerID)  --This shows only latest batch of records for tagged players (all seasons records for seasoned players)
	  and (@LeagueID = 0 or Sections.LeagueID=@LeagueID)
	  and (@SectionID = 0 or T.SectionID=@SectionID)
	  and (@TeamID = 0 or teams.ID=@TeamID)
	  and (Surname like '%' + @Surname + '%')
	  and (Forename like '%' + @Forename + '%')
	
	order by T.SectionID, [Club Name], Player


GO
exec [HandicapsReport] 