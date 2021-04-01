declare @LeagueID int
Set @LeagueID=1
declare @WeekNo int
select @WeekNo=WeekNo from FixtureDates 
	where LeagueID = @LeagueID
	  and FixtureDate=(select max(FixtureDate) from FixtureDates where LeagueID=@LeagueID and FixtureDate between dateadd(week,-1,getdate()) and getdate())
--select @WeekNo
set @WeekNo=1

select R.ID,
	result='<strong>' +
		HC.[Club Name]+' '+H.Team + ' ' + convert(varchar,
	              (case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	               case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	               case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	               case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end)) + ' ' +
        AC.[Club Name]+' '+A.Team + ' ' + convert(varchar,
	              (case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	               case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	               case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	               case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end)) + '</strong>' +
       '<br/><br/>' +
	  
	   HomePlayer1 + ' (' + convert(varchar,HomeHandicap1)+') ' + convert(varchar,HomePlayer1Score) + ' ' +
			AwayPlayer1 + ' (' + convert(varchar,AwayHandicap1)+') ' + convert(varchar,AwayPlayer1Score) + ', ' +
	   HomePlayer2 + ' (' + convert(varchar,HomeHandicap2)+') ' + convert(varchar,HomePlayer2Score) +  ' ' +
			AwayPlayer2 + ' (' + convert(varchar,AwayHandicap2)+') ' + convert(varchar,AwayPlayer2Score) + ', ' +
	   HomePlayer3 + ' (' + convert(varchar,HomeHandicap3)+') ' + convert(varchar,HomePlayer3Score) + ' ' +
			AwayPlayer3 + ' (' + convert(varchar,AwayHandicap3)+') ' + convert(varchar,AwayPlayer3Score) + ', ' +
	   HomePlayer4 + ' (' + convert(varchar,HomeHandicap4)+') ' + convert(varchar,HomePlayer4Score) +  ' ' +
			AwayPlayer4 + ' (' + convert(varchar,AwayHandicap4)+') ' + convert(varchar,AwayPlayer4Score) +
	   case when dbo.BreaksInMatch(R.ID) = '' then '' else '<br/><strong>Breaks:</strong> ' + dbo.BreaksInMatch(R.ID) end
	  	 
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	
	outer apply ( select D.FixtureDate, WeekNo
					from FixtureGrids F
					cross apply (select FixtureNo, SectionID from Teams where ID=(select HomeTeamID from MatchResultsDetails where ID=R.ID)) H
					cross apply	(select FixtureNo from Teams where ID=(select AwayTeamID from MatchResultsDetails where ID=R.ID)) A
					cross apply (Select FixtureDate from FixtureDates where SectionSize=F.SectionSize and WeekNo = F.WeekNo) D
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
				)FD

	where l.ID=@LeagueID
	  and WeekNo=@WeekNo 
	
	order by H.SectionID, H.FixtureNo