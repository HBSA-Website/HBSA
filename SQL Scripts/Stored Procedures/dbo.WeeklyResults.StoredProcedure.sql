USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[listResults]    Script Date: 12/12/2014 17:46:00 ******/
If exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='WeeklyResults')
	drop procedure dbo.WeeklyResults
GO

CREATE procedure dbo.WeeklyResults
	(@LeagueID int = NULL
	,@SectionID int = NULL
	,@FixtureDate date
	)
as

set nocount on

If @LeagueID is null and @SectionID is null
	begin
	raiserror('Must have LeagueID or SectionID',16,1)
	return;
	end
If @LeagueID is not null and @SectionID is not null
	begin
	raiserror('Cannot have both LeagueID and SectionID',16,1)
	return;
	end

if @SectionID is null
	select [League Name]
		from Leagues
		where ID = @LeagueID
else
	 begin
     select @LeagueID = LeagueID from Sections where ID = @SectionID
	 select Section = [League Name] + ' ' + [Section Name]
		from Leagues
		join Sections on Sections.ID=@SectionID
		where Leagues.ID = @LeagueID
 	 end

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
	  ,Section=[Section Name]
	  ,HomePlayer1,HomeHandicap1,HomePlayer1Score,AwayPlayer1,AwayHandicap1,AwayPlayer1Score
      ,HomePlayer2,HomeHandicap2,HomePlayer2Score,AwayPlayer2,AwayHandicap2,AwayPlayer2Score
      ,HomePlayer3,HomeHandicap3,HomePlayer3Score,AwayPlayer3,AwayHandicap3,AwayPlayer3Score
      ,HomePlayer4,HomeHandicap4,HomePlayer4Score,AwayPlayer4,AwayHandicap4,AwayPlayer4Score
	  ,h.SectionID
into #tmp
	  
	from MatchResults R
	join Teams H on H.ID=HomeTeamID
	join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
	join Clubs AC on AC.ID = A.ClubID
	join Sections S on S.ID=h.SectionID
	join Leagues L on L.ID=S.LeagueID
	outer apply (select HomePlayer1=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=HomePlayer1ID) h1
	outer apply (select HomePlayer2=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=AwayPlayer4ID) a4
		cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionID = H.SectionID
														  and WeekNo = F.WeekNo + case when MatchDate > dbo.LastFixtureDateInMatrix(SectionID) then  dbo.GridMatrixSize(SectionID) else 0 end
						                                  ) D
						
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
			  ) FD			       
	where L.ID = @LeagueID 
	  and (S.ID = @SectionID or @SectionID is null)
	  and FixtureDate=@FixtureDate
	order by h.SectionID

select * from #tmp order by SectionID

select MatchResultID, Player=dbo.FullPlayerName(Forename, Initials, Surname), [Break]
	from Breaks
	join #tmp T on T.ID = Breaks.MatchResultID 
	join Players on Players.ID=PlayerID
	order by MatchResultID

drop table #tmp

GO

exec WeeklyResults @LeagueID=1,
                   --@SectionID=5,
				   @fixturedate='10 Feb 2022'
--select top 5 * from MatchResultsDetails