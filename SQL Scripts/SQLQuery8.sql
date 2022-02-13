USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[listResults]    Script Date: 12/12/2014 17:46:00 ******/
If exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='listResults')
	drop procedure [dbo].[listResults]
GO

CREATE procedure [dbo].[listResults]
	(@SectionID int
	,@MatchDate date = NULL
	,@TeamID int = 0
	)
as

set nocount on

select R.ID
      ,MatchDate
	  ,HomeTeamID=H.ID, [Home]=HC.[Club Name]+' '+H.Team
	  ,H_Pts= case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	          case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	          case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	          case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end
	  ,A_Pts= case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	          case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	          case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	          case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end
      ,AwayTeamID=A.ID ,[Away]=AC.[Club Name]+' '+A.Team
	  ,FixtureDate
	  
into #temp
	
	from MatchResultsDetails2 R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID

	where (s.ID=@SectionID or @SectionID=0)
	  and (r.MatchDate=@MatchDate or @MatchDate is null)
	  and (@TeamID = 0 or (H.ID=@TeamID or A.ID=@TeamID))
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team
--select * from #temp
select ID, [Match Date]=convert(varchar(11),Matchdate,113)
      ,[Home],[hFrames]=H_Pts,[aFrames]=A_Pts,Away
      ,FixtureDate=CONVERT(varchar(11),FixtureDate,113)
	from #temp order by convert(date,FixtureDate), Home

select distinct MatchDate into #tmpD from #temp order by MatchDate
select [Match Date] = CONVERT(varchar(11),Matchdate,113) from #tmpD

select Distinct TeamID=HomeTeamID,Team=[Home] from #temp 
union
select distinct AwayTeamID,[Away] from #temp
order by Team

GO

exec ListResults 10,null