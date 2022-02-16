USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SetUpFixtureLinks]    Script Date: 15/02/2022 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SetUpFixtureLinks')
	drop procedure [dbo].SetUpFixtureLinks
GO

CREATE procedure [dbo].SetUpFixtureLinks

as

set nocount on

if exists(select table_name from INFORMATION_SCHEMA.TABLES where TABLE_NAME='FixtureLinks')
	truncate table dbo.FixtureLinks
else
	create table FixtureLinks
		(FixtureDate date
		,HomeFixtureNo int
		,AwayFixtureNo int
		,SectionID int
		,HomeTeamID int
		,AwayTeamID int)

declare @sectionID int
declare SectionIDs cursor for
	select ID from Sections
open SectionIDs
fetch SectionIDs into @sectionID
while @@FETCH_STATUS=0
	begin
	insert FixtureLinks
		exec FixtureDatesBySection @SectionID
	fetch SectionIDs into @sectionID
	end
close SectionIDs
deallocate SectionIDs

GO

