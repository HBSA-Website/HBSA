USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixturesByLeague')
	drop procedure dbo.FixturesByLeague
GO

create procedure dbo.FixturesByLeague
	(@LeagueID int 
	,@FixtureDate date = NULL
	,@TeamName varchar(100) = NULL
	)
as

set nocount on	

declare @sT table (Fixture_Date varchar(11),HomeTeam varchar(100),AwayTeam varchar(100))
declare @lT table (Fixture_Date varchar(11),HomeTeam varchar(100),AwayTeam varchar(100),Section varchar(100))

declare SectionIDsCursor cursor for
	select ID from Sections where LeagueID=@LeagueID
	order by ID
declare @SectionID int
open SectionIDsCursor
fetch SectionIDsCursor into @SectionID
while @@fetch_status=0
	begin	
	delete from @sT
	insert @sT
		exec FixturesBySection @SectionID,@FixtureDate,@TeamName,1  
	insert @lT 
	    select Fixture_Date, HomeTeam,AwayTeam ,Section 
			from @sT
			cross apply (select Section= [League Name] + ' ' + [Section Name]
				             from Leagues 
					         cross apply (select [Section Name] from Sections where ID=@SectionID) S
						     where ID=@LeagueID
				        ) L
		                 
	fetch SectionIDsCursor into @SectionID
	end

close SectionIDsCursor
deallocate SectionIDsCursor	

select [Fixture Date]=case when Fixture_Date='' then '' else convert(varchar(11),convert(date,Fixture_Date),113) end,HomeTeam,AwayTeam,Section
	 from @lT	
	
select [Fixture Date]=Convert(varchar(11),FixtureDate,113) 
	from FixtureDates 
	where sectionID=(select top 1 ID from Sections where LeagueID=@LeagueID)
	order by FixtureDate

select Distinct Team=HomeTeam 
	from @lT 
	where Fixture_Date <> '' 
	  and HomeTeam <> '' 
	  and Hometeam <> 'Bye'
	order by HomeTeam


GO
exec FixturesByLeague 3,null,'Meltham Lib A'

