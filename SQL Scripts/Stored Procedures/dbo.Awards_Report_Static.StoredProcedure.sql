USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_Report_Static')
	drop procedure dbo.Awards_Report_Static
GO

create procedure dbo.Awards_Report_Static
	@AwardType int = 0
as

set nocount ON

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Awards_Report_Table')
select *
	from Awards_Report_Table
	where AwardType = @AwardType or @AwardType = 0

	order by LeagueID, AwardType, AwardID, SubID


GO

exec Awards_Report_Static