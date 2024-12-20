USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerRecords]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select routine_name from information_schema.routines where routine_name='getPlayerRecords')
	drop procedure [dbo].[GetPlayerRecords]
GO

create procedure [dbo].[GetPlayerRecords]
	(@LeagueID int
	,@Season int = 0
	,@Player varchar(50) = ''
	)
as

set nocount on

if @Player <> ''
	begin
	declare @Players table (Player varchar(100))
	declare @word1 varchar(50)
	declare @word2 varchar(50)
	declare @word3 varchar(50)
	select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
	select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
	select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
	select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')
	insert @Players exec SuggestPlayerRecord @LeagueID,100,@word1,@word2,@word3

	select League=[League Name], PlayerRecords.Player,
		   Season=convert(varchar,Season-1) + '-' + convert(varchar,season),
		   Hcap,P,W,L,Team,Tag 
	from PlayerRecords
    join Leagues on PlayerRecords.LeagueID=Leagues.ID
	join @players P on P.Player=PlayerRecords.Player
	where (LeagueID=@LeagueID or @LeagueID=0)
	  and (Season=@Season or @Season = 0)
	order by PlayerRecords.Player, LeagueID, Season
	end

else

	select League=[League Name], PlayerRecords.Player,
		   Season=convert(varchar,Season-1) + '-' + convert(varchar,season),
          Hcap,P,W,L,Team,Tag 
     from PlayerRecords
     join Leagues
	   on PlayerRecords.LeagueID=Leagues.ID
	where (LeagueID=@LeagueID or @LeagueID=0)
	  and (Season=@Season or @Season = 0)
	order by PlayerRecords.Player, LeagueID, Season

GO
