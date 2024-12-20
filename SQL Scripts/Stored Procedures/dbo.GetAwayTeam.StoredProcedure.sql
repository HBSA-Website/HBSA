USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetAwayTeam')
	drop procedure GetAwayTeam
GO

CREATE procedure [dbo].[GetAwayTeam]
	(@Weekno int
	,@SectionID int
	,@HomeTeamID int
	)
as

set nocount on

declare @HomeFixtureNo int
	select @HomeFixtureNo = FixtureNo from Teams where ID=@HomeTeamID
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID
declare @AwayFixtureNo int
	select @AwayFixtureNo =
	case when h1 = @HomeFixtureNo then a1
	     when h2 = @HomeFixtureNo then a2
	     when h3 = @HomeFixtureNo then a3
	     when h4 = @HomeFixtureNo then a4
	     when h5 = @HomeFixtureNo then a5
	     when h6 = @HomeFixtureNo then a6
	     when h7 = @HomeFixtureNo then a7
	     when h8 = @HomeFixtureNo then a8
	end     
	     
	from FixtureGrids
	where SectionID=@SectionID
	  and WeekNo=case when @Weekno % @MatrixSize = 0 then @MatrixSize else @Weekno % @MatrixSize end

declare @AwayTeamID int
select @AwayTeamID = ID from Teams where SectionID = @SectionID and FixtureNo=@AwayFixtureNo 

exec TeamDetails @AwayTeamID

GO
exec GetAwayTeam 22,10,139