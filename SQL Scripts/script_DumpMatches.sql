USE HBSA
GO

--create trable of breaks by frame
create table #BreaksByFrame
	(MatchResultID int
	,PlayerID int
	,Break1 varchar(6)
	,Break2 varchar(6)
	,Break3 varchar(6)
	,Break4 varchar(6)
	,Break5 varchar(6)
	,Break6 varchar(6)
	,Break7 varchar(6)
	,Break8 varchar(6)
	)
insert #BreaksByFrame
	select distinct MatchResultID, PlayerID, '', '', '', '', '', '', '', ''
	 from Breaks
	 order by MatchresultID, PlayerID
declare @MatchResultID int
	   ,@PlayerID int
	   ,@prevMatchResultID int
	   ,@prevPlayerID int
	   ,@Break int
	   ,@Count int
	   ,@SQL varchar(max)

declare BreaksCursor cursor fast_forward for
	select MatchResultID, PlayerID, [Break]
		 from Breaks
		order by MatchresultID, PlayerID

set @prevMatchResultID=0
set @prevPlayerID=0

open BreaksCursor

fetch BreaksCursor into  @MatchResultID, @PlayerID, @Break
while @@fetch_status = 0
	begin
	if @MatchResultID <> @prevMatchResultID
	or @PlayerID <> @prevPlayerID
		begin
		set @Count=1
		set @prevMatchResultID = @MatchResultID
		set @prevPlayerID = @PlayerID
		end
	else
		set @Count = @Count + 1

	set @SQL = 
		'update #BreaksByFrame ' +
		 	'set Break' + convert(varchar,@count) + ' = ''' + convert(varchar,@Break) + '''' +
		 ' where PlayerID = ' + convert(varchar,@PlayerID) +
		 '  and MatchResultID = ' + convert(varchar,@MatchResultID) 

	exec(@SQL)		

	fetch BreaksCursor into  @MatchResultID, @PlayerID, @Break
	end

close BreaksCursor
deallocate BreaksCursor

--select * from #BreaksByFrame
--	 order by MatchresultID, PlayerID

--calculate this season
declare @ThisSeason int
       ,@Season char(7)
select @ThisSeason=Datepart(year,convert(date,[value]))
   from Configuration where [key] = 'CloseSeasonEndDate'
select @Season=Convert(char(4),@ThisSeason) + '/' + Convert(char(2),(@ThisSeason+1) % 100)

--get the remaining data by frames

select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer1ID,HomePlayer=HomePlayer1
      ,AwayPlayerID=AwayPlayer1ID,AwayPlayer=AwayPlayer1
	  ,HomeScore=HomePlayer1Score
	  ,AwayScore=AwayPlayer1Score
	  ,HomePlayerHcap=HomeHandicap1
	  ,AwayPlayerHCap=AwayHandicap1
	  ,HomeBreak1 = isnull(HB.Break1,'')
	  ,AwayBreak1 = isnull(AB.Break1,'')
	  ,HomeBreak2 = isnull(HB.Break2,'')
	  ,AwayBreak2 = isnull(AB.Break2,'')
	  ,HomeBreak3 = isnull(HB.Break3,'')
	  ,AwayBreak3 = isnull(AB.Break3,'')
	  ,HomeBreak4 = isnull(HB.Break4,'')
	  ,AwayBreak4 = isnull(AB.Break4,'')
	  ,HomeBreak5 = isnull(HB.Break5,'')
	  ,AwayBreak5 = isnull(AB.Break5,'')
	  ,HomeBreak6 = isnull(HB.Break6,'')
	  ,AwayBreak6 = isnull(AB.Break6,'')
	  ,HomeBreak7 = isnull(HB.Break7,'')
	  ,AwayBreak7 = isnull(AB.Break7,'')
	  ,HomeBreak8 = isnull(HB.Break8,'')
	  ,AwayBreak8 = isnull(AB.Break8,'')

	into #TempReport
    
	from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join #BreaksByFrame HB on HB.MatchResultID = M.ID and HB.PlayerID = M.HomePlayer1ID
	left join #BreaksByFrame AB on HB.MatchResultID = M.ID and HB.PlayerID = M.AwayPlayer1ID

insert into #TempReport

select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer2ID,HomePlayer=HomePlayer2
      ,AwayPlayerID=AwayPlayer2ID,AwayPlayer=AwayPlayer2
	  ,HomeScore=HomePlayer2Score
	  ,AwayScore=AwayPlayer2Score
	  ,HomePlayerHcap=HomeHandicap2
	  ,AwayPlayerHCap=AwayHandicap2
	  ,HomeBreak1 = isnull(HB.Break1,'')
	  ,AwayBreak1 = isnull(AB.Break1,'')
	  ,HomeBreak2 = isnull(HB.Break2,'')
	  ,AwayBreak2 = isnull(AB.Break2,'')
	  ,HomeBreak3 = isnull(HB.Break3,'')
	  ,AwayBreak3 = isnull(AB.Break3,'')
	  ,HomeBreak4 = isnull(HB.Break4,'')
	  ,AwayBreak4 = isnull(AB.Break4,'')
	  ,HomeBreak5 = isnull(HB.Break5,'')
	  ,AwayBreak5 = isnull(AB.Break5,'')
	  ,HomeBreak6 = isnull(HB.Break6,'')
	  ,AwayBreak6 = isnull(AB.Break6,'')
	  ,HomeBreak7 = isnull(HB.Break7,'')
	  ,AwayBreak7 = isnull(AB.Break7,'')
	  ,HomeBreak8 = isnull(HB.Break8,'')
	  ,AwayBreak8 = isnull(AB.Break8,'')
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join #BreaksByFrame HB on HB.MatchResultID = M.ID and HB.PlayerID = M.HomePlayer2ID
	left join #BreaksByFrame AB on HB.MatchResultID = M.ID and HB.PlayerID = M.AwayPlayer2ID

insert into #TempReport

select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer3ID,HomePlayer=HomePlayer3
      ,AwayPlayerID=AwayPlayer3ID,AwayPlayer=AwayPlayer3
	  ,HomeScore=HomePlayer3Score
	  ,AwayScore=AwayPlayer3Score
	  ,HomePlayerHcap=HomeHandicap3
	  ,AwayPlayerHCap=AwayHandicap3
	  ,HomeBreak1 = isnull(HB.Break1,'')
	  ,AwayBreak1 = isnull(AB.Break1,'')
	  ,HomeBreak2 = isnull(HB.Break2,'')
	  ,AwayBreak2 = isnull(AB.Break2,'')
	  ,HomeBreak3 = isnull(HB.Break3,'')
	  ,AwayBreak3 = isnull(AB.Break3,'')
	  ,HomeBreak4 = isnull(HB.Break4,'')
	  ,AwayBreak4 = isnull(AB.Break4,'')
	  ,HomeBreak5 = isnull(HB.Break5,'')
	  ,AwayBreak5 = isnull(AB.Break5,'')
	  ,HomeBreak6 = isnull(HB.Break6,'')
	  ,AwayBreak6 = isnull(AB.Break6,'')
	  ,HomeBreak7 = isnull(HB.Break7,'')
	  ,AwayBreak7 = isnull(AB.Break7,'')
	  ,HomeBreak8 = isnull(HB.Break8,'')
	  ,AwayBreak8 = isnull(AB.Break8,'')
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join #BreaksByFrame HB on HB.MatchResultID = M.ID and HB.PlayerID = M.HomePlayer3ID
	left join #BreaksByFrame AB on HB.MatchResultID = M.ID and HB.PlayerID = M.AwayPlayer3ID

insert into #TempReport

select FixtureID=M.ID, Season=@Season, LeagueID=L.ID, League = L.[League Name],SectionID=S.ID, Section=replace([Section Name],'League','Billiards')
      ,FixtureDate=convert(varchar(11),FixtureDate,13),MatchDate=convert(varchar(11),MatchDate,13)
	  ,HomeTeamID=H.ID,HomeTeam=HC.[Club Name]+' '+ H.Team
	  ,AwayTeamID=A.ID,AwayTeam=AC.[Club Name]+' '+ A.Team
      ,HomePlayerID=HomePlayer4ID,HomePlayer=HomePlayer4
      ,AwayPlayerID=AwayPlayer4ID,AwayPlayer=AwayPlayer4
	  ,HomeScore=HomePlayer4Score
	  ,AwayScore=AwayPlayer4Score
	  ,HomePlayerHcap=HomeHandicap4
	  ,AwayPlayerHCap=AwayHandicap4
	  ,HomeBreak1 = isnull(HB.Break1,'')
	  ,AwayBreak1 = isnull(AB.Break1,'')
	  ,HomeBreak2 = isnull(HB.Break2,'')
	  ,AwayBreak2 = isnull(AB.Break2,'')
	  ,HomeBreak3 = isnull(HB.Break3,'')
	  ,AwayBreak3 = isnull(AB.Break3,'')
	  ,HomeBreak4 = isnull(HB.Break4,'')
	  ,AwayBreak4 = isnull(AB.Break4,'')
	  ,HomeBreak5 = isnull(HB.Break5,'')
	  ,AwayBreak5 = isnull(AB.Break5,'')
	  ,HomeBreak6 = isnull(HB.Break6,'')
	  ,AwayBreak6 = isnull(AB.Break6,'')
	  ,HomeBreak7 = isnull(HB.Break7,'')
	  ,AwayBreak7 = isnull(AB.Break7,'')
	  ,HomeBreak8 = isnull(HB.Break8,'')
	  ,AwayBreak8 = isnull(AB.Break8,'')
    from MatchResultsDetails2 M
    join Teams H on H.ID = HomeTeamID
    join Teams A on A.ID = AwayTeamID
	join Sections S on S.ID = H.sectionID
	join Leagues L on L.ID = LeagueID
	join Clubs HC on HC.ID=H.ClubID
	join Clubs AC on AC.ID=A.ClubID
	left join #BreaksByFrame HB on HB.MatchResultID = M.ID and HB.PlayerID = M.HomePlayer4ID
	left join #BreaksByFrame AB on HB.MatchResultID = M.ID and HB.PlayerID = M.AwayPlayer4ID

	where LeagueID < 3 

select * from #TempReport
	order by SectionID, convert(date,MatchDate), FixtureID

drop table #BreaksByFrame
drop table #TempReport

GO

