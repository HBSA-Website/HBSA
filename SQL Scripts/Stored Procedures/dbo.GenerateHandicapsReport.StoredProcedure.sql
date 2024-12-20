USE [HBSA]
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GenerateHandicapsReport')
	drop procedure dbo.GenerateHandicapsReport
GO

CREATE procedure [dbo].[GenerateHandicapsReport]

as

set nocount on
set xact_abort on

declare @WinLosses table 
	(EffectiveDate date
	,PlayerID int
	,Handicap int
	,WinLose tinyint
	)
		 	
insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,HomePlayer1ID
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,HomePlayer2ID
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,HomePlayer3ID
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,HomePlayer4ID
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer4ID <> 0 and AwayPlayer4ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,AwayPlayer1ID
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,AwayPlayer2ID
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,AwayPlayer3ID
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 EffectiveDate=DateTimeLodged
		,AwayPlayer4ID
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer4ID <> 0 and AwayPlayer4ID <> 0

--select * from @WinLosses where Playerid=1880 order by EffectiveDate

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HandicapsReportTable]') AND type in (N'U'))
DROP TABLE [dbo].HandicapsReportTable

select Effective=min(EffectiveDate)
      ,SectionID
      ,ClubID
	  ,PlayerID
      ,W.Handicap
	  ,lastHandicapChange=max(lastHandicapChange)
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
	outer apply (select lastHandicapChange=max(dateChanged) from PlayersHandicapChanges where PlayerID=W.PlayerID) hc
	
	where PlayerID > 0
	  and (    (tagged <> 0 and EffectiveDate >= isnull(lastHandicapChange,EffectiveDate)) --only include unseasoned players records since their last handicap change
	        or (tagged=0)                                           -- include full seasons records for seasoned players
		   )
	
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



GO
exec [GenerateHandicapsReport]
select * from HandicapsReportTable