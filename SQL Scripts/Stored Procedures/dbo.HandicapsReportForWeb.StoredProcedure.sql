USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='HandicapsReportForWeb')
	drop procedure HandicapsReportForWeb

GO
create procedure [dbo].[HandicapsReportForWeb]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Player varchar(100)=''
	,@ChangesOnly bit = 0
	)

as

set nocount on

declare @Players table (Player varchar(100))
declare @word1 varchar(50)
declare @word2 varchar(50)
declare @word3 varchar(50)
select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

insert @Players exec SuggestPlayers @LeagueID,@SectionID,@ClubID,10000,@word1,@word2,@word3

select Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+ isnull(Teams.Team,'')
      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
      ,Tag=case when Players.Tagged = 3 then 'Unseasoned'
	            when Players.Tagged = 2 then '2 Seasons to go'
				when Players.Tagged = 1 then '1 Season to go'
				else ''
           end 
      ,[Over70(80 Vets)]=Players.Over70
	  ,[Last Season H'cap effective from]=convert(varchar(11),T.Effective,113)
      ,[Last Season H'cap]=T.Handicap
      ,T.Played
      ,T.Won
      ,T.Lost
      ,T.Delta
      ,[Current Handicap]=Players.Handicap
	from Players
	left join HandicapsReportTable T on Players.ID=PlayerID
	join Sections on Sections.ID=Players.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=Players.ClubID
	left join Teams on Teams.SectionID=Players.SectionID 
	               and Teams.ClubID=Players.ClubID 
		   	       and Teams.Team=Players.team
	join @Players sP on sP.Player=Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname

	where (@LeagueID = 0 or Sections.LeagueID=@LeagueID)
	  and (@SectionID = 0 or Players.SectionID=@SectionID)
	  and (@ClubID = 0 or Clubs.ID=@ClubID)
	  and (@ChangesOnly = 0 or T.Handicap <> Players.Handicap)
	
	order by Players.SectionID, [Club Name], isnull(Teams.Team,''), Player


GO
exec handicapsReportforweb 1,4,19,'Neil Armstrong',0
select * from clubs where [Club Name]like 'kirk%'