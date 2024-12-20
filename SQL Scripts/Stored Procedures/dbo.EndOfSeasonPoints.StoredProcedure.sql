use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EndOfSeasonPoints')
	drop procedure EndOfSeasonPoints
GO

CREATE procedure [dbo].[EndOfSeasonPoints]
	(@LeagueID int
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
	  
into #temp2
	
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionID=h.SectionID
						                                  and WeekNo = F.WeekNo
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

	where (l.ID=@LeagueID)
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team
--select * from #temp2

select ID, Matchdate, TeamID=HomeTeamID, Team=Home, Points=H_Pts 
	into  #temp22
	from #temp2
insert into #temp22
	select ID, Matchdate, TeamID=AwayTeamID, Team=Away, Points=A_Pts 
	from #temp2

--select * from #temp22
--		order by TeamID, MatchDate Desc

create table #temp23
	(teamID int
	,Team varchar(50)
	,Points int
	)
declare c cursor fast_forward for
	select * from #temp22
		order by TeamID, MatchDate Desc
declare @prevID int
       ,@prevTeam varchar(50)
       ,@teamID int
	   ,@Team varchar(50)
	   ,@Points int
	   ,@accumPoints int
	   ,@counter int
	   ,@mDate date

select @prevID=-1
	  ,@accumPoints=0
	  ,@counter=0

open c
fetch c into @teamID, @mDate, @teamID, @Team, @Points
while @@fetch_status = 0
	begin
	if @teamID <> @previd
		begin
		if @previd>-1
			insert #temp23
				select @prevID, @prevTeam, @accumPoints
		select @prevID=@teamID
		      ,@prevTeam=@Team
			  ,@accumPoints=0
			  ,@counter=0
		end
	
	if @counter < 6 
		select @accumPoints = @accumPoints + @Points
		      ,@counter = @counter + 1		

	fetch c into @teamID, @mDate, @teamID, @Team, @Points
	end

insert #temp23
	select @prevID, @prevTeam, @accumPoints

declare @LeagueName varchar(50)
select @LeagueName= [League Name] 
	from Leagues
	where ID=@LeagueID

select League=@LeagueName, Team, Points from #temp23 order by Team

close c
deallocate c

drop table #temp2
DROP TABLE #temp22
drop table #temp23

GO

exec EndOfSeasonPoints 1