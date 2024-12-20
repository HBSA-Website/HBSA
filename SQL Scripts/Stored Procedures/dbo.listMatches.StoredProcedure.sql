USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'listMatches')
	drop procedure listMatches
GO

CREATE procedure [dbo].[listMatches]
	(@TeamID int
	)
as

set nocount on

declare @SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID

select distinct
       R.ID
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
	  
into #temp1
	
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	--join Leagues l on l.ID = s.LeagueID	
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionSize=F.SectionSize
						                                  and WeekNo = F.WeekNo
						                                  and SectionID = @SectionID) D
						
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

	where (s.ID=@SectionID)
	  and ((H.ID=@TeamID or A.ID=@TeamID))
	
	--order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team

select 
	   ID, [Match Date]=convert(varchar(11),Matchdate,113)
      ,[Home],[hFrames]=H_Pts,[aFrames]=A_Pts,Away
      ,FixtureDate=CONVERT(varchar(11),FixtureDate,113)
	from #temp1 
	order by convert(date,FixtureDate), Home


GO
exec listMatches 27