USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'TaggedPlayersReport')
	drop procedure TaggedPlayersReport
GO

create procedure [dbo].[TaggedPlayersReport]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@ActionNeeded bit = 0
	,@fromApplyHCaps bit = 0
	,@Player varchar(100) = '')
as

set nocount on

	declare @Players table (Player varchar(100))

if @fromApplyHCaps = 0 
	begin
	declare @word1 varchar(50)
	declare @word2 varchar(50)
	declare @word3 varchar(50)
	select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
	select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
	select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
	select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

	insert @Players exec SuggestPlayers @LeagueID,@SectionID,@ClubID,10000,@word1,@word2,@word3

	end
		
declare @WinLosses table 
	(MatchDate date
	,PlayerID int
	,Player varchar(106)
	,Handicap int
	,WinLose tinyint
	)
		 	
insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,HomePlayer1ID
		,HomePlayer1
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,HomePlayer2ID
		,HomePlayer2
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,HomePlayer3ID
		,HomePlayer3
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,HomePlayer4ID
		,HomePlayer4
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer4ID > 0 and AwayPlayer4ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,AwayPlayer1ID
		,AwayPlayer1
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,AwayPlayer2ID
		,AwayPlayer2
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,AwayPlayer3ID
		,AwayPlayer3
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 MatchDate -- =DateTimeLodged
		,AwayPlayer4ID
		,AwayPlayer4
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer4ID > 0 and AwayPlayer4ID > 0

declare @Matches6 table 
	(ID int identity (1,1)
	,mDate date
	,PlayerID int
	,Handicap int
	,Played int
	,Won int
	,Lost int
	)  

declare @lastHcap int
       ,@lastPlayerID int
       ,@lastmDate date
	   ,@mDate date
	   ,@PlayerID int
	   ,@Handicap int
	   ,@WinLose tinyint
	   ,@Played int
	   ,@Won int

declare c 
	cursor fast_forward for
	select MatchDate, PlayerID, Handicap, WinLose
		from @WinLosses
		outer apply (select Forename,Initials,Surname, Tagged,Over70, LeagueID, SectionID, ClubID from Players where ID=PlayerID) p

		where Tagged>0
		  --and Over70=0
		  and PlayerID > 0
		  and (@LeagueID = 0 or @LeagueID = LeagueID)
		  and (@SectionID = 0 or @SectionID = SectionID)
		  and (@ClubID = 0 or @ClubID = ClubID)
		  and (@Player='' or dbo.FullPlayerName(Forename, Initials, Surname) in (select Player from @Players))

		order by PlayerID, MatchDate

set @lastHcap=99
set @lastPlayerID=-1
select @Played=0, @Won=0

open c
fetch c into @mDate, @PlayerID, @Handicap, @WinLose
while @@fetch_status=0
	begin
	
	if @PlayerID <> @lastPlayerID
	or @Played > 5
		begin
		insert @Matches6 values (@lastmDate,@lastPlayerID,@lastHcap,@Played, @Won, @Played-@Won)
		select @Played=0, @Won=0
		end

	set @Played=@Played+1
	set @Won=@Won+case when @WinLose > 0 then 1 else 0 end			
	set @lastHcap=@Handicap
	set @lastPlayerID=@PlayerID
	set @lastmDate=@mdate
	
	fetch c into @mDate, @PlayerID, @Handicap, @WinLose

	end  	

insert @Matches6 values (@lastmDate,@lastPlayerID,@lastHcap,@Played, @Won, @Played-@Won)

close c
deallocate c

--select * from @Matches6 where playerid=2000

select [Last Date]=convert(varchar(11),M6.mDate,113)
	  ,M6.PlayerID
      ,Player = Forename + case when Initials <> '' then ' ' + Initials + '.' else ' ' end + Surname 
      ,M6.Handicap
	  ,M6.Played
	  ,M6.Won
	  ,M6.Lost      
      ,ActionNeeded=case when nxt.ID is null then case when M6.Won > 4 and M6.Played > 5 
	                                                    and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) < P.Handicap 
															then 'Reduce'
						                                when M6.Won < 2 and M6.Played > 5 
														 and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) > P.Handicap 
														    then 'Raise'
						                                else ''
				                                   end
					    else case when nxt.Handicap <> dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) 
						                     then  case when M6.Won > 4 and M6.Played > 5 
	                                                    and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) < P.Handicap 
															then 'Reduce'
						                                when M6.Won < 2 and M6.Played > 5 
														 and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) > P.Handicap 
														    then 'Raise'
						                                else ''
				                                   end
						                     else ''
                              end     
					end						  	        
      ,NewHandicap=dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) 
	  ,Section=[League Name] + ' ' + [Section Name]
      ,Team=[Club Name] + ' ' + Team
	  ,ClubID
	  ,TeamID
	  ,p.SectionID

	into #tmp

	from @Matches6 M6
	cross apply (select LeagueID, SectionID, ClubID, Forename, Initials, Surname, Team, Handicap from Players where ID=PlayerID) p
	cross apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	cross apply (Select [Section Name] from Sections where ID=p.SectionID) s
	cross apply (Select [Club Name] from Clubs where ID=p.ClubID) c
	cross apply (Select TeamID=ID from Teams where ClubID=p.ClubID and SectionID=p.SectionID and Team=p.Team) t
	outer apply (select * from @Matches6 where ID = M6.ID+1 and PlayerID=M6.PlayerID) nxt
	
	where (@ActionNeeded=0 or 
				case when nxt.ID is null then case when M6.Won > 4 and M6.Played > 5 
	                                                    and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) < P.Handicap 
															then 1
						                           when M6.Won < 2 and M6.Played > 5  
														 and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) > P.Handicap 
														    then 1
						                           else 0
				                              end
					 else case when nxt.Handicap <> dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) 
						                   then case when M6.Won > 4 and M6.Played > 5 
	                                                    and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) < P.Handicap 
															then 1
						                           when M6.Won < 2 and M6.Played > 5  
														 and dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID) > P.Handicap 
														    then 1
						                           else 0
				                                   end
						                    else 0
                          end
				 end  = 1 
					)
	order by SectionID, [Club Name] + ' ' + Team, Player, M6.mDate

if @fromApplyHCaps=1
	select [Last Date]
	  ,PlayerID
      ,Player 
      ,T.Handicap
	  ,Played
	  ,Won
	  ,Lost      
      ,ActionNeeded	= case when NewHandicap = x.Handicap then 'None(Changed)' else ActionNeeded end					  	        
      ,NewHandicap
	  ,Section
	  ,Team
	  ,ClubID
	  ,TeamID

	from #tmp T
	outer apply (Select Handicap from Players where ID=PlayerID) x
	order by SectionID,Section,Team,Player,convert(datetime,[Last Date])

else
	select [Last Date]
	  ,PlayerID
      ,Player 
      ,T.Handicap
	  ,Played
	  ,Won
	  ,Lost      
      ,ActionNeeded	= case when NewHandicap = x.Handicap then 'None(Changed)' else ActionNeeded end					  	        
      ,NewHandicap
	  ,Section
      ,Team

	from #tmp T
	outer apply (Select Handicap from Players where ID=PlayerID) x
	order by SectionID,Section,Team,Player,convert(datetime,[Last Date])

drop table #tmp


GO
