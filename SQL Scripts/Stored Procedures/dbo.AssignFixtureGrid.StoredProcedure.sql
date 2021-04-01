use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AssignFixtureGrid')
	drop procedure AssignFixtureGrid
GO

create procedure AssignFixtureGrid
	(@SectionID int
	)
as

set nocount on
set xact_abort on
--given a section, assign a new fixtureGrid

begin tran

declare @ReversedMatrix tinyint
select @ReversedMatrix=ReversedMatrix
	from sections 
	where ID=@sectionID 

delete FixtureGrids
	where SectionID=@SectionID

--insert FixtureGrids
--	exec GetFixtureMatrix @SectionID

	declare @SectionSize int
	select @SectionSize=count(*) from Teams where SectionID=@SectionID

	declare @Matrix table
		(WeekNo int
		,h1 int, a1 int
		,h2 int, a2 int
		,h3 int, a3 int
		,h4 int, a4 int
		,h5 int, a5 int
		,h6 int, a6 int
		,h7 int, a7 int
		,h8 int, a8 int
		)
		
	insert @Matrix
		exec GenerateFixtureMatrix @SectionSize

insert FixtureGrids	
	select SectionID=@SectionID
	      ,SectionSize=@SectionSize
		  ,*
		from @Matrix
		order by WeekNo



if @ReversedMatrix = 1
	exec Reverse_a_Grid @SectionID

commit tran

GO
exec AssignFixtureGrid 9
--select * from FixtureGrids where SectionID=9 order by Weekno
--exec GetFixtureMatrix 9

