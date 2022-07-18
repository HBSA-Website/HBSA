USE [HBSA]
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
		select [ ]=Team,Played,Won,Drawn, Lost,Pts
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
exec LeagueTablesByLeague 2
