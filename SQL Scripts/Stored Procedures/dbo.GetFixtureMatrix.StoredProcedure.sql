use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetFixtureMatrix')
	drop procedure GetFixtureMatrix
GO

create procedure GetFixtureMatrix
	(@SectionID int
	)
as

set nocount on

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

	select SectionID=@SectionID
	      ,SectionSize=@SectionSize
		  ,*
		from @Matrix
		order by WeekNo

GO
 
 exec GetFixtureMatrix 9