use hbsa
go
alter table LeaguePointsAdjustment
	drop constraint PK_LeaguePointsAdjustment_1
go
alter table LeaguePointsAdjustment
	add ID int identity (1,1)
GO
CREATE NONCLUSTERED INDEX [IX_LeaguePointsAdjustment] ON [dbo].[LeaguePointsAdjustment]
(
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- Modify pointsadjust email template
update eMailTemplates set eMailTemplateHTML = 
'<div style="font-size: medium;">  <div>   <table border="0">    <tbody>     <tr>      <td class="header1" colspan="4">       <span style="color: rgb(0, 0, 0);">HBSA Web Administration.</span><br />       &nbsp;</td>     </tr>     <tr>      <td class="header2" colspan="4" style="font-weight: bold; font-family: Calibri; font-size: 14pt;">       <span style="color: rgb(0, 0, 0);">Notification of league points adjustment:</span></td>     </tr>     <tr class="header2" style="font-weight: bold; font-size: 14pt;">      <td>       <span style="font-size: small; color: rgb(0, 0, 0);">Team:</span></td>      <td>       <span style="font-size: small; color: rgb(0, 0, 0);">|Team| (|Section|)</span></td>      <td>       <span style="font-size: small; color: rgb(0, 0, 0);">Date:</span></td>      <td>       <span style="font-size: small; color: rgb(0, 0, 0);">|Date|</span></td>     </tr>     <tr>      <td class="header2" colspan="4" style="font-weight: bold; font-family: Calibri; font-size: 14pt;">       &nbsp;</td>     </tr>     <tr>      <td class="normal" colspan="4">       |DownUp| of |Adjustment| points has been applied to this team. The reason for this is:<br />       |Reason|       <hr />       <br />       You have 2 weeks to appeal. <a href="https://hudds-bsa.co.uk/contact.aspx" target="_blank">To contact us click here</a>: stating the reasons for the appeal:</td>     </tr>     <tr>      <td colspan="4">       &nbsp;</td>     </tr>     <tr>      <td class="normal" colspan="4">       <span style="color: rgb(0, 0, 0);">Yours Sincerely<br />       HBSA Hon. League Reporting Secretary</span></td>     </tr>    </tbody>   </table>  </div> </div> <p>  &nbsp;</p>'
where eMailTemplateName='PointsAdjustment' 

if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='insertLeaguePointsAdjustment')
	drop procedure dbo.insertLeaguePointsAdjustment
GO

create procedure [dbo].[insertLeaguePointsAdjustment]
	(@TeamID int
	,@Points dec(9,1)
	,@Comment varchar(255)
	,@CreatedBy varchar(50)
	)
as

set nocount on

	insert LeaguePointsAdjustment
		select @TeamID
		 	  ,@Points
			  ,@Comment
			  ,dbo.UKdateTime(getUTCdate())
			  ,@CreatedBy

GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='DeleteLeaguePointsAdjustment')
	drop procedure dbo.DeleteLeaguePointsAdjustment
GO

create procedure [dbo].[DeleteLeaguePointsAdjustment]
	(@AdjustmentID int
	)
as

set nocount on

	delete LeaguePointsAdjustment
		Where ID =  @AdjustmentID

GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='updateLeaguePointsAdjustment')
	drop procedure dbo.updateLeaguePointsAdjustment
GO

create procedure [dbo].[updateLeaguePointsAdjustment]
	(@AdjustmentID int
	,@Points dec(9,1)
	,@Comment varchar(255)
	,@CreatedBy varchar(50)
	)
as

set nocount on

	update LeaguePointsAdjustment
		set	Points=@Points
		   ,Comment=@Comment
		   ,CreatedDate=dbo.UKdateTime(getUTCdate())
		   ,CreatedBy=@CreatedBy
		where ID=@AdjustmentID

GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ListAdjustedPoints')
	drop procedure dbo.ListAdjustedPoints
GO

create procedure [dbo].[ListAdjustedPoints]

as

set nocount on

select SectionID
      ,TeamID
	  ,Section=[League Name]+' '+[Section Name] 
	  ,Team=[Club Name]+' '+Team
      ,Points
      ,Comment
	  ,CreatedDate
	  ,CreatedBy
	  ,LeaguePointsAdjustment.ID

	from LeaguePointsAdjustment 
	join Teams on Teams.ID=TeamID
	join Clubs on Clubs.ID=ClubID
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	
order by SectionID, Team

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Aggregate_Points')
	drop procedure dbo.Aggregate_Points
GO

CREATE procedure dbo.Aggregate_Points
	(@SectionID int
	)
as

set nocount on

declare @tempPts table
	(TeamID int
	,Points decimal(9,1)
	,Comment varchar(max)
	)
declare c cursor fast_forward for
	select TeamID,points,Comment 
		from LeaguePointsAdjustment 
		cross apply (select SectionID from Teams where ID = TeamID) x
		where SectionID=@SectionID
		order by teamID, CreatedDate
declare @TeamID int,
		@prevTeamID int,
		@pts dec(9,1)
       ,@comment varchar(255)
	   ,@gpts dec(9,1)
       ,@gcomment varchar(max)
set @prevTeamID=0
open c
fetch c into @TeamID, @pts, @comment
while @@FETCH_STATUS=0
	begin
	if @TeamID <> @prevTeamID
		begin
		if @prevTeamID <> 0
			insert @tempPts
				select @prevTeamID, @gPts, right(@gcomment,len(@gcomment)-5)
		set @prevTeamID = @TeamID
		set @gpts=0
		set @gcomment=''
		end
	set @gpts = @gpts + @pts
	set @gcomment = @gcomment + '<br/>' + 
						case when @pts < 0 then convert(varchar(5),abs(@pts)) +  ' points deducted: ' + @Comment 
						                   else convert(varchar(5),abs(@pts)) + ' points added: ' + @Comment end
	fetch c into @teamID, @pts, @comment
	end

if @TeamID is not null
	insert @tempPts
		select @TeamID, @gPts, right(@gcomment,len(@gcomment)-5)
close c
deallocate c
select * from @tempPts order by teamID
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LeagueTable')
	drop procedure LeagueTable
GO

CREATE procedure LeagueTable
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

	if @WinFrames=3
		select   [Team] = TeamName
			,Played = convert(varchar, Played)
			,Won = convert(varchar, Won)
			,Drawn = convert(varchar, Drawn)
			,Lost = convert(varchar, Lost)
			,Pts = convert(varchar,  Pts + isnull(adj.Points,0))
			,[4-0 Wins] = convert(varchar, [x-0 Wins])
			,[3-1 Wins] = convert(varchar, [x-1 Wins])
			,[Comment] = case when adj.Points is null then ''
		                 else Comment
					 end                                     
		from #tmp t
		outer apply (select Points, Comment 
						from @aggPts
						where TeamID=t.TeamID) adj
		outer apply (select TeamName = [Club Name] + rtrim(' ' + Team) 
						from Teams 
						join Clubs on Clubs.ID = ClubID
						Where Teams.ID = TeamID) TN
		order by  Pts Desc
		        ,Won desc
				,[4-0 Wins] Desc
				,[3-1 Wins] Desc
	else
		select   [Team] = TeamName
			,Played
			,Won
			,Drawn
			,Lost
			,Pts  = Pts + isnull(adj.Points,0)
			,[3-0 Wins] = [x-0 Wins]
			,[2-1 Wins] = [x-1 Wins]
			,[Comment] = case when adj.Points is null then null
				                 else Comment
					end                                     
		from #tmp t
		outer apply (select Points, Comment 
						from @aggPts
						where TeamID=t.TeamID) adj
		outer apply (select TeamName = [Club Name] + rtrim(' ' + Team) 
						from Teams 
						join Clubs on Clubs.ID = ClubID
						Where Teams.ID = TeamID) TN
		order by  Pts + isnull(adj.Points,0) Desc
				,Won Desc
				,[3-0 Wins] Desc
				,[2-1 Wins] Desc

	drop table #tmp
	end

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

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LeagueTablesByLeague')
	drop procedure dbo.LeagueTablesByLeague
GO

CREATE procedure dbo.LeagueTablesByLeague
	(@LeagueID int
	)
as

set nocount on

	begin

	declare @tmpLeagues table
		(Team varchar (256)
		,Played int
		,Won int
		,Drawn int
		,Lost int
		,Pts decimal(9,1)
		,Win0 INT
		,Win1 int
		,Adjustment varchar(max)
		,SectionID decimal(9,1))

	declare sectionCursor cursor fast_forward for
	select ID from sections where LeagueID=@LeagueID
	Declare @SectionID int
	open sectionCursor
	fetch sectionCursor into @SectionID
	while @@FETCH_STATUS=0
		begin
		insert @tmpLeagues
			select case when @LeagueID=3 then 'Billiards' else [Section Name] end
			      ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, @SectionID 
			   from Sections 
			   join Leagues on LeagueID=Leagues.ID
			   where Sections.ID= @SectionID

		---------------get table for this section and put it into @tmpLeagues
		exec LeagueTable_ForByLeague @SectionID	-- create LeagueTableForLeagueTablesByLeague	
		insert @tmpLeagues 
			select * 
				from LeagueTableForLeagueTablesByLeague
				order by Pts Desc
				        ,Won desc
						,Win0 Desc
						,Win1 Desc

		insert @tmpLeagues
			select NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@SectionID+0.5 

		fetch sectionCursor into @SectionID
		end
	close sectionCursor
	deallocate sectionCursor

	if @LeagueID=1
		select [ ]=Team,Played,Won,Drawn,Lost,Pts
		          ,[4-0 Wins]=Win0
			      ,[3-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
			order by SectionID
			        ,isnull(Pts,999) Desc
			        ,Won desc
					,Win0 Desc
					,Win1 Desc
	else
		select [ ]=Team,Played,Won,Lost,Pts
		          ,[3-0 Wins]=Win0
			      ,[2-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
			order by SectionID
			        ,isnull(Pts,999) Desc
			        ,Won desc
					,Win0 Desc
					,Win1 Desc
	end

drop table LeagueTableForLeagueTablesByLeague

GO
drop procedure [dbo].[AddPointsAdjustmentsForNonAttendance]
GO