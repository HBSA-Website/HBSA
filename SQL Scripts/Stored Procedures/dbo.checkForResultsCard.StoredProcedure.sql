USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='checkForResultsCard')
	drop procedure [dbo].[checkForResultsCard]
GO

create Procedure [dbo].[checkForResultsCard]
	(@HomeTeamID int
	,@AwayTeamID int
	,@FixtureDate date
	)
as

set nocount on


declare @MatchResultID int
Select @MatchResultID = ID 
	from MatchResultsDetails5
	where HomeTeamID=@HomeTeamID
	  and AwayTeamID=@AwayTeamID
	  and FixtureDate = @FixtureDate 

select R.ID
      ,[Match Date]=convert(varchar(11),R.MatchDate,113)
      ,League=[League Name],Section=[Section Name] 
	  ,[Home]=HC.[Club Name]+' '+H.Team
	  ,H_Pts= case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	               case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	               case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	               case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end
	  ,A_Pts= case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	               case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	               case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	               case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end
      ,[Away]=AC.[Club Name]+' '+A.Team
	  ,FixtureDate=CONVERT (varchar(11), @FixtureDate,113)
	  
	from MatchResults R
	left join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID
	
	where R.ID = @MatchResultID

select FN=4, [Home H'cap]=isnull(HomeHandicap4,0),HomeScore=HomePlayer4Score,HomePlayer=HomePlayer4ID,AwayPlayer=AwayPlayer4ID,AwayScore=AwayPlayer4Score,[Away H'cap]=isnull(AwayHandicap4,0) 
	into #tmpFrames
	from MatchResultsDetails 
	where ID = @MatchResultID


insert #tmpframes
select FN=3, HomeHandicap3,HomePlayer3Score,HomePlayer3ID,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
select FN=2, HomeHandicap2,HomePlayer2Score,HomePlayer2ID,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
select FN=1, HomeHandicap1,HomePlayer1Score,HomePlayer1ID,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1 from MatchResultsDetails where ID = @MatchResultID
select * from #tmpFrames
	order by FN

select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = HomePlayer1ID
	    or PlayerID = HomePlayer2ID
	    or PlayerID = HomePlayer3ID
	    or PlayerID = HomePlayer4ID) 
select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = AwayPlayer1ID
	    or PlayerID = AwayPlayer2ID
	    or PlayerID = AwayPlayer3ID
	    or PlayerID = AwayPlayer4ID)

drop table #tmpFrames


GO
select getdate()
exec checkForResultsCard 283,1370,'19 Oct 2021'
exec checkForResultsCard 283,1370,'15 Feb 2022'
select getdate()