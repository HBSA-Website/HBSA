USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where routine_name = 'PlayingRecordsDetail')
	drop procedure PlayingRecordsDetail
GO

CREATE procedure PlayingRecordsDetail
	(@SectionID int = 0
	,@ClubID int = 0
	,@Team char(1) = ''
	,@PlayerID int = 0
	,@Tagged bit = 0
	,@Over70 bit = 0
	,@Player varchar(150) = ''
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

if @Player <> ''
	begin
	If @SectionID > 99 
		begin
		set @LeagueID = @SectionID % 100
		set @SectionID = 0
		end
	Else
		set @LeagueID = 0
	insert @Players exec SuggestPlayers @LeagueID,0,0,10000,@word1,@word2,@word3
	end

declare @MatchSummaries table 
	(MatchDate date
	,PlayerID int
	,OpponentPlayerID int
	,Handicap int
	,ScoreFor int
	,ScoreAgainst int
	,MatchID int
	)

if @SectionID > 100
	begin
	set @LeagueID=@SectionID % 100
	set @SectionID=0
	end
else
	set @LeagueID=0
		 	
insert @MatchSummaries
	select
		 MatchDate
		,HomePlayer1ID
        ,AwayPlayer1ID
		,HomeHandicap1
        ,HomePlayer1Score
		,AwayPlayer1Score
		,ID
	from MatchResultsDetails
	where HomePlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,HomePlayer2ID
        ,AwayPlayer2ID
		,HomeHandicap2
        ,HomePlayer2Score
		,AwayPlayer2Score
		,ID
	from MatchResultsDetails
	where HomePlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,HomePlayer3ID
        ,AwayPlayer3ID
		,HomeHandicap3
        ,HomePlayer3Score
		,AwayPlayer3Score
		,ID
	from MatchResultsDetails
	where HomePlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,HomePlayer4ID
        ,AwayPlayer4ID
		,HomeHandicap4
        ,HomePlayer4Score
		,AwayPlayer4Score
		,ID
	from MatchResultsDetails
	where HomePlayer4ID <> 0 and AwayPlayer4ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,AwayPlayer1ID
        ,HomePlayer1ID
		,AwayHandicap1
        ,AwayPlayer1Score
		,HomePlayer1Score
		,ID
	from MatchResultsDetails
	where AwayPlayer1ID <> 0 and HomePlayer1ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,AwayPlayer2ID
        ,HomePlayer2ID
		,AwayHandicap2
        ,AwayPlayer2Score
		,HomePlayer2Score
		,ID
	from MatchResultsDetails
	where AwayPlayer2ID <> 0 and HomePlayer2ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,AwayPlayer3ID
        ,HomePlayer3ID
		,AwayHandicap3
        ,AwayPlayer3Score
		,HomePlayer3Score
		,ID
	from MatchResultsDetails
	where AwayPlayer3ID <> 0 and HomePlayer3ID <> 0

insert @MatchSummaries
	select
		 MatchDate
		,AwayPlayer4ID
        ,HomePlayer4ID
		,AwayHandicap4
        ,AwayPlayer4Score
		,HomePlayer4Score
		,ID
	from MatchResultsDetails
	where AwayPlayer4ID <> 0 and HomePlayer4ID <> 0

select Section=[League Name] + ' ' + [Section Name]
      ,Team=c.[Club Name] + ' ' + p.Team
      ,Player=dbo.FullPlayerName(p.Forename,p.Initials,p.Surname)
      ,Handicap
      ,Tag=dbo.TagDescription (p.Tagged)
      ,[Match Date]=convert(varchar(11),Matchdate,113)
      ,OpponentTeam=oc.[Club Name] + ' ' + op.Team
	  ,Opponent=dbo.FullPlayerName(op.Forename,op.Initials,op.Surname)
	  ,ScoreFor 
	  ,ScoreAgainst 
	  ,WinLose=case when ScoreFor>ScoreAgainst then 'Won' else 'Lost' end
	  ,BreaksFor=dbo.BreaksInMatchForPlayer(MatchID,PlayerID)
	  ,BreaksAgainst=dbo.BreaksInMatchForPlayer(MatchID,OpponentPlayerID)
      
	from @MatchSummaries
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team, Forename, Initials, Surname from Players where ID=PlayerID) p
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team, Forename, Initials, Surname from Players where ID=OpponentPlayerID) op
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c
	outer apply (Select [Club Name] from Clubs where ID=op.ClubID) oc


	where [League Name] + ' ' + [Section Name] is not null 
	  and c.[Club Name] + ' ' + p.Team is not null
	  and (@LeagueID = 0  or @LeagueID = p.LeagueID)
	  and (@SectionID = 0 or @SectionID = p.SectionID)
	  and (@ClubID = 0    or @ClubID = p.ClubID)
	  and (@Team = ''     or @Team = p.Team)
	  and (@PlayerID = 0  or @PlayerID = PlayerID)
	  and (@Tagged = 0    or @Tagged = p.Tagged)
	  and (@Over70 = 0    or @Over70 = p.Over70)
	  and (@Player =  ''  or dbo.FullPlayerName(p.Forename,p.Initials,p.Surname) in (select Player from @Players))
	  and (@Handicap is null or @handicap = Handicap)
	order by p.SectionID, c.[Club Name] + ' ' + p.Team, Player, Matchdate
	 
GO

