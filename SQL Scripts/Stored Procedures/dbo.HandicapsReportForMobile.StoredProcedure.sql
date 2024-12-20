USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='HandicapsReportForMobile')
	drop procedure HandicapsReportForMobile

GO
create procedure [dbo].[HandicapsReportForMobile]
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

select ID=dbo.FullPlayerName(Forename, Initials, Surname) + '|' + Convert(varchar,Sections.LeagueID) + '|' + Convert(varchar,Players.SectionID) + '|' + Convert(varchar,Players.ClubID) + '|' + Convert(varchar,@ChangesOnly) 
      ,Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+ isnull(Players.Team,'')
      ,Player=dbo.FullPlayerName(Forename, Initials, Surname)
      ,Tag=case when Players.Tagged = 3 then 'Unseasoned'
	            when Players.Tagged = 2 then '2 Seasons to go'
				when Players.Tagged = 1 then '1 Season to go'
				else ''
           end 
      ,[Over 80]=case when Players.Over70=1 then 'Y' else 'N' end
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
exec handicapsReportForMobile 