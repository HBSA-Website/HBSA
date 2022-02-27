USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[WeeklyResultsForExaminer]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter procedure [dbo].[WeeklyResultsForExaminer]
	(@LeagueID int
	,@WeekNo int = 0
	)
as		

set nocount on

If @WeekNo = 0
	select @WeekNo=max(weekNo)
		from FixtureDates 
		where SectionID in (Select ID from Sections where LeagueID=@LeagueID) 
		  and FixtureDate between dateadd(week,-1,dbo.UKdateTime(getUTCdate())) and dbo.UKdateTime(getUTCdate())

select Section=0,Result=convert(varchar(4000),'<strong> ' + [League Name] + ' League Scores:<br/>')
	into #tempresults
	from Leagues 
	where ID=@LeagueID

insert #tempresults
select distinct 
	Section=H.SectionID,
	result='<strong>' +
		HC.[Club Name]+' '+H.Team + ' ' + convert(varchar(50),
	              (case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	               case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	               case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	               case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end)) + ' v ' +
        AC.[Club Name]+' '+A.Team + ' ' + convert(varchar(50),
	              (case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	               case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	               case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	               case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end)) + '</strong> ' +
	   
	   case when l.ID=3 then '' else '(' + replace(convert(varchar(50),[Section Name]),' ','') + ')' end +
	  
	   '<br/>' +
	  
	   HomePlayer1 + ' (' + convert(varchar(50),HomeHandicap1)+') ' + convert(varchar(50),HomePlayer1Score) + ' ' +
			AwayPlayer1 + ' (' + convert(varchar(50),AwayHandicap1)+') ' + convert(varchar(50),AwayPlayer1Score) + ', ' +
	   HomePlayer2 + ' (' + convert(varchar(50),HomeHandicap2)+') ' + convert(varchar(50),HomePlayer2Score) +  ' ' +
			AwayPlayer2 + ' (' + convert(varchar(50),AwayHandicap2)+') ' + convert(varchar(50),AwayPlayer2Score) + ', ' +
	   HomePlayer3 + ' (' + convert(varchar(50),HomeHandicap3)+') ' + convert(varchar(50),HomePlayer3Score) + ' ' +
			AwayPlayer3 + ' (' + convert(varchar(50),AwayHandicap3)+') ' + convert(varchar(50),AwayPlayer3Score) + 
	   case when leagueID <> 1 then '' else
		   ', ' + HomePlayer4 + ' (' + convert(varchar(50),HomeHandicap4)+') ' + convert(varchar(50),HomePlayer4Score) +  ' ' +
		  		AwayPlayer4 + ' (' + convert(varchar(50),AwayHandicap4)+') ' + convert(varchar(50),AwayPlayer4Score) end +
		   case when dbo.BreaksInMatch(R.ID) = '' then '' else '<br/><strong>Breaks:</strong> ' + dbo.BreaksInMatch(R.ID) 
	   end
	  	 
	from MatchResultsDetails2 R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=H.SectionID
	join Leagues l on l.ID = s.LeagueID	
	outer apply (select WeekNo from FixtureDates where FixtureDate=R.FixtureDate)FD

	where l.ID=@LeagueID
	  and WeekNo=@WeekNo 
	
	order by H.SectionID, result

if (select count(*) from #tempresults)=1
	select Section=0,Result='No results for ' + [League Name] + ' for the selected fixture date.'
		from Leagues 
		where ID=@LeagueID	
else
	select result from #tempresults order by Section, Result

drop table #tempresults

GO

exec WeeklyResultsForExaminer 3, 19