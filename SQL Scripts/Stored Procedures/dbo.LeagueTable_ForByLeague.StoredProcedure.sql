USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LeagueTable_ForByLeague')
	drop procedure LeagueTable_ForByLeague
GO

CREATE procedure LeagueTable_ForByLeague
	(@SectionID int
	)
as

set nocount on

	begin
	declare @WinFrames int

	select @WinFrames = case when L.ID = 1 then 3 else 2 end 
		from Sections S
		join Leagues L on L.ID=S.LeagueID
		where S.ID=@SectionID

	declare @temp table
		(TeamID int
		,PointsFor int
		,PointsAgainst int
		)
	declare @TeamID int
	declare TeamIDcursor cursor fast_forward for
		select ID From Teams
	          where SectionID=@SectionID
	open TeamIDcursor
	fetch TeamIDcursor into @TeamID
	while @@FETCH_STATUS = 0
		begin
		insert @temp
			select TeamID=@TeamID
			  ,PointsFor
				= case when HomeTeamID=@TeamID
					   then HomePoints
	                   else AwayPoints
		          end
			  ,PointsAgainst
				= case when AwayTeamID=@TeamID
					   then HomePoints
			           else AwayPoints
				  end

			from MatchResultsDetails3 R 
			outer apply (Select SectionID from Teams where ID=HomeTeamID) S
			where SectionID=@SectionID
			  and (HomeTeamID=@TeamID or AwayTeamID=@TeamID)
			order by MatchDate
		fetch TeamIDcursor into @TeamID
		end

	close TeamIDcursor
	deallocate TeamIDcursor

	declare @tmp table
		(TeamID int
		,PointsFor int
		,PointsAgainst int
		,Won int
		,Drawn int
		,Lost int
		)
	insert @tmp
		select TeamID, PointsFor, PointsAgainst
			  ,Won		= case when PointsFor > PointsAgainst then 1 else 0 end
			  ,Drawn	= case when PointsFor = PointsAgainst then 1 else 0 end
			  ,Lost		= case when PointsFor < PointsAgainst then 1 else 0 end
		from @temp
		order by TeamID

	select	 TeamID
			,Played=COUNT(*)
			,Won=SUM(Won)
			,Drawn=SUM(drawn)
			,Lost=Sum(Lost)
			,Pts=sum(PointsFor)
			,[x-0 Wins] = SUM(case when pointsFor = @WinFrames+1 then 1 else 0 end)
			,[x-1 Wins] = SUM(case when pointsFor = @WinFrames then 1 else 0 end) 
	into #tmp
		from @tmp
		group by TeamID

	declare @aggPts table
		(TeamID int
		,Points decimal(9,1)
		,Comment varchar(max)
		)
	insert @aggPts
		exec Aggregate_Points @SectionID

	if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LeagueTableForLeagueTablesByLeague')
		drop table LeagueTableForLeagueTablesByLeague
	select   [Team] = TeamName
			,Played = convert(varchar, Played)
			,Won = convert(varchar, Won)
			,Drawn = convert(varchar, Drawn)
			,Lost = convert(varchar, Lost)
			,Pts = convert(varchar,  Pts + isnull(adj.Points,0))
			,Win0 = convert(varchar, [x-0 Wins])
			,Win1 = convert(varchar, [x-1 Wins])
			,[Comment] = case when adj.Points is null then ''
		                 else Comment
					 end
			,SectionID = @SectionID
		into LeagueTableForLeagueTablesByLeague
		from #tmp t
		outer apply (select Points, Comment 
						from @aggPts
						where TeamID=t.TeamID) adj
		outer apply (select TeamName = [Club Name] + rtrim(' ' + Team) 
						from Teams 
						join Clubs on Clubs.ID = ClubID
						Where Teams.ID = TeamID) TN

	drop table #tmp

	end

GO
Exec LeagueTable_ForByLeague 8
select * from LeagueTableForLeagueTablesByLeague
		 order by  Pts Desc
		        ,Won desc
				,Win0 Desc
				,Win1 Desc
