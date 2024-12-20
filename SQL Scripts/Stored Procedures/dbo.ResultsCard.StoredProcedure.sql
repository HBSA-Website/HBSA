USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[ResultsCard]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[ResultsCard]
	(@MatchResultID int
	)
as

set nocount on

declare @FixtureDate date
select @FixtureDate=D.FixtureDate
	from FixtureGrids F
	cross apply (select FixtureNo, SectionID from Teams where ID=(select HomeTeamID from MatchResultsDetails where ID=@MatchResultID)) H
	cross apply	(select FixtureNo from Teams where ID=(select AwayTeamID from MatchResultsDetails where ID=@MatchResultID)) A
	cross apply (Select FixtureDate from FixtureDates where SectionID=H.SectionID and SectionSize=F.SectionSize and WeekNo = F.WeekNo) D
	where F.SectionID=H.SectionID
	  and ((h1=H.FixtureNo and a1=A.FixtureNo)
 	    or (h2=H.FixtureNo and a2=A.FixtureNo)
	    or (h3=H.FixtureNo and a3=A.FixtureNo)
	    or (h4=H.FixtureNo and a4=A.FixtureNo)
	    or (h5=H.FixtureNo and a5=A.FixtureNo)
	    or (h6=H.FixtureNo and a6=A.FixtureNo)
	    or (h7=H.FixtureNo and a7=A.FixtureNo)
	    or (h8=H.FixtureNo and a8=A.FixtureNo)
	       )

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
	  ,FixtureDate=CONVERT(varchar(11),@FixtureDate,113)
	  	 
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	
	
	where R.ID = @MatchResultID

select FN=4, [Home H'cap]=HomeHandicap4,HomeScore=HomePlayer4Score,HomePlayer=isnull(HomePlayer4,'Unspecified'),AwayPlayer=isnull(AwayPlayer4,'Unspecified'),AwayScore=AwayPlayer4Score,[Away H'cap]=AwayHandicap4 
	into #tmpFrames
	from MatchResultsDetails 
	where ID = @MatchResultID
insert #tmpframes
	select FN=3, HomeHandicap3,HomePlayer3Score,isnull(HomePlayer3,'Unspecified'),isnull(AwayPlayer3,'Unspecified'),AwayPlayer3Score,AwayHandicap3 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
	select FN=2, HomeHandicap2,HomePlayer2Score,isnull(HomePlayer2,'Unspecified'),isnull(AwayPlayer2,'Unspecified'),AwayPlayer2Score,AwayHandicap2 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
	select FN=1, HomeHandicap1,HomePlayer1Score,isnull(HomePlayer1,'Unspecified'),isnull(AwayPlayer1,'Unspecified'),AwayPlayer1Score,AwayHandicap1 from MatchResultsDetails where ID = @MatchResultID

select * from #tmpFrames
	where isnull(homescore,0) > -100 or isnull(awayscore,0) > -100
	order by FN

select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.[Break] 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = HomePlayer1ID
	    or PlayerID = HomePlayer2ID
	    or PlayerID = HomePlayer3ID
	    or PlayerID = HomePlayer4ID) 

select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.[Break] 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = AwayPlayer1ID
	    or PlayerID = AwayPlayer2ID
	    or PlayerID = AwayPlayer3ID
	    or PlayerID = AwayPlayer4ID)



GO
exec ResultsCard 2487