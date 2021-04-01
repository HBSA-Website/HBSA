USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Competitions_ReportAll')
	drop procedure Competitions_ReportAll
GO

CREATE procedure Competitions_ReportAll

as

set nocount on

declare @FullReport table
	([ ] varchar(256)
	,[Entrant(s)] varchar(256)
	,TelNo varchar(20)
	,eMail varchar(256)
	,EntryFee varchar(10)
	)
declare ClubsCursor cursor fast_forward for
	select distinct ClubID, [Club Name]
		from Competitions_EntryForms
		cross apply (select [Club Name] from Clubs where ID=ClubID) x
		order by [Club Name]
declare @ClubID int, @ClubName varchar(50)
open ClubsCursor
fetch ClubsCursor into @ClubID, @ClubName
while @@fetch_status=0
	begin
	insert @FullReport 
		select '<b>' + @ClubName + '</b>',NULL,NULL,NULL,NULL
	insert @FullReport
		exec Competitions_Report @ClubID
	insert @FullReport 
		select NULL,NULL,NULL,NULL,NULL
	fetch ClubsCursor into @ClubID, @ClubName
	end
close ClubsCursor
deallocate ClubsCursor

select * from @Fullreport

GO

--exec Competitions_ReportAll
