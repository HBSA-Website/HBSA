USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where routine_name = 'PlayingRecords')
	drop procedure PlayingRecords
GO

CREATE procedure [dbo].[PlayingRecords]
	(@SectionID int = 0
	,@ClubID int = 0
	,@Team char(1) = ''
	,@PlayerID int = 0
	,@Tagged bit = 0
	,@Over70 bit = 0
	,@Player varchar(150) = ''
	,@ForMobile bit = 0
	,@Handicap int = null
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

declare @LeagueID int
set @LeagueID = 0

if @Player <> ''
	begin
	If @SectionID > 99 
		begin
		set @LeagueID = @SectionID % 100
		set @SectionID = 0
		end

	insert @Players exec SuggestPlayers @LeagueID,0,0,10000,@word1,@word2,@word3
	end
	
declare @WinLosses table 
	(DateSubmitted date
	,PlayerID int
	,Player varchar(106)
	,Handicap int
	,WinLose tinyint
	)
		 	
insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer1ID
		,HomePlayer1
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails6
	where HomePlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer2ID
		,HomePlayer2
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails6
	where HomePlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer3ID
		,HomePlayer3
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails6
	where HomePlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,HomePlayer4ID
		,HomePlayer4
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails6
	where HomePlayer4ID <> 0 and AwayPlayer4ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer1ID
		,AwayPlayer1
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails6
	where AwayPlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer2ID
		,AwayPlayer2
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails6
	where AwayPlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer3ID
		,AwayPlayer3
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails6
	where AwayPlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 FirstDateLodged
		,AwayPlayer4ID
		,AwayPlayer4
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails6
	where AwayPlayer4ID <> 0 and AwayPlayer4ID <> 0

if @ForMobile = 0
    select [Handicap Effective From]=convert(varchar(11),min(DateSubmitted),113)
      ,Section=max([League Name] + ' ' + [Section Name])
      ,Team=[Club Name] + ' ' + Team
      ,Player
      ,Handicap
      ,Tag=case when max(Tagged)=3 then 'Unseasoned' 
	            when max(Tagged)=2 then '2 Seasons to go'
				when max(Tagged)=1 then '1 Season to go'
				else '' 
			end
      ,[Over70(80 Vets)]=case when max(convert(tinyint,Over70))=1 then 'Yes' else '' end
      ,Played=count(WinLose)
      ,Won=sum(WinLose)
      ,Lost=count(WinLose)-sum(WinLose)
	  ,PlayerID
      
	from @WinLosses
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team, Forename, Initials, Surname from Players where ID=PlayerID) p
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c

	where [League Name] + ' ' + [Section Name] is not null 
	  and [Club Name] + ' ' + Team is not null
	  and (@LeagueID = 0  or @LeagueID = LeagueID)
	  and (@SectionID = 0 or @SectionID = SectionID)
	  and (@ClubID = 0    or @ClubID = ClubID)
	  and (@Team = ''     or @Team = Team)
	  and (@PlayerID = 0  or @PlayerID = PlayerID)
	  and (@Tagged = 0    or Tagged > 0)
	  and (@Over70 = 0    or @Over70 = Over70)
	  and (@Player =  ''  or dbo.FullPlayerName(p.Forename,p.Initials,p.Surname) in (select Player from @Players))

	group by SectionID, [Club Name] + ' ' + Team, Player, Handicap, PlayerID

	order by SectionID, [Club Name] + ' ' + Team, Player, min(DateSubmitted)
	
else
    select ID=Convert(varchar,SectionID) + '|' + Player + '|' + convert(varchar,handicap) +'|' + convert(varchar,ClubID)
      ,Tag=case when max(Tagged)=3 then 'Unseasoned' 
	            when max(Tagged)=2 then '2 Seasons to go'
				when max(Tagged)=1 then '1 Season to go'
				else '' 
			end
      ,Section=max([League Name] + ' ' + [Section Name])
      ,Team=[Club Name] + ' ' + Team
      ,Player
      ,Handicap
	  ,Effective=convert(varchar(11),min(DateSubmitted),113)
      ,P=count(WinLose)
      ,W=sum(WinLose)
      ,L=count(WinLose)-sum(WinLose)
      
	from @WinLosses
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team, Forename, Initials, Surname from Players where ID=PlayerID) p
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c

	where [League Name] + ' ' + [Section Name] is not null 
	  and [Club Name] + ' ' + Team is not null
	  and (@LeagueID = 0  or @LeagueID = LeagueID)
	  and (@SectionID = 0 or @SectionID = SectionID)
	  and (@ClubID = 0    or @ClubID = ClubID)
	  and (@Team = ''     or @Team = Team)
	  and (@PlayerID = 0  or @PlayerID = PlayerID)
	  and (@Tagged = 0    or Tagged > 0)
	  and (@Over70 = 0    or @Over70 = Over70)
	  and (@Player =  ''  or dbo.FullPlayerName(p.Forename,p.Initials,p.Surname) in (select Player from @Players))
 	  and (@Handicap is null or @handicap = Handicap)

	group by SectionID, ClubID, [Club Name] + ' ' + Team, Player, Handicap, PlayerID

	order by SectionID, [Club Name] + ' ' + Team, Player, min(DateSubmitted)
	

GO
exec PlayingRecords @player='e z'