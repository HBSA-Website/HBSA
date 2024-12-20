USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GenerateHandicapsReport')
	drop procedure GenerateHandicapsReport
GO

CREATE procedure GenerateHandicapsReport

as

set nocount on
set xact_abort on

declare @WinLosses table 
	(MatchDate date
	,PlayerID int
	,Handicap int
	,WinLose tinyint
	)
		 	
insert @WinLosses
	select
		 MatchDate
		,HomePlayer1ID
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer2ID
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer3ID
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer4ID
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer4ID > 0 and AwayPlayer4ID > 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer1ID
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer1ID > 0 and AwayPlayer1ID > 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer2ID
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer2ID > 0 and AwayPlayer2ID > 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer3ID
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer3ID > 0 and AwayPlayer3ID > 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer4ID
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer4ID > 0 and AwayPlayer4ID > 0


--set up table with non tagged players
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HandicapsReportTable]') AND type in (N'U'))
DROP TABLE [dbo].HandicapsReportTable

select Effective=min(Matchdate)
      ,SectionID
      ,ClubID
	  ,PlayerID
      ,W.Handicap
      ,Tagged
      ,Over70
      ,Played=count(WinLose)
      ,Won=sum(WinLose)
      ,Lost=count(WinLose)-sum(WinLose)
      ,Delta=sum(WinLose)-(count(WinLose)-sum(WinLose))
      ,[New Handicap]=dbo.newHandicap(W.Handicap,count(WinLose),sum(WinLose),LeagueID, Tagged, Over70)
      
	into HandicapsReportTable
	
	from @WinLosses W
	left join Players on ID=PlayerID
	
	where Tagged=0
	
	group by  LeagueID,SectionID
      ,ClubID
	  ,PlayerID
      ,W.Handicap
      ,Tagged
      ,Over70
	order by  SectionID
      ,ClubID
	  ,PlayerID
	  ,Effective
      ,W.Handicap
      ,Tagged
      ,Over70

--now get tagged players' details and insert them
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

insert HandicapsReportTable
	select M6.mDate
	  ,p.SectionID
	  ,ClubID
	  ,M6.PlayerID
      ,M6.Handicap
      ,Tagged
	  ,Over70
	  ,M6.Played
	  ,M6.Won
	  ,M6.Lost      
	  ,Delta=M6.Won - M6.Lost	
      ,NewHandicap= isnull(dbo.newTaggedHandicap(M6.Played,M6.Won,M6.Handicap,LeagueID), M6.Handicap)

	from @Matches6 M6
	cross apply (select LeagueID, SectionID, ClubID, Tagged, Over70 from Players where ID=PlayerID) p
	
	where M6.PlayerID>0
	  and Tagged > 0

	order by  SectionID
      ,ClubID
	  ,PlayerID
	  ,M6.mDate
      ,M6.Handicap
      ,Tagged
      ,Over70


GO

exec GenerateHandicapsReport
select * 
	from HandicapsReportTable
	order by  SectionID
      ,ClubID
	  ,PlayerID
	  ,Effective
