USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_FullReport')
	DROP procedure EntryForm_FullReport
GO

create procedure EntryForm_FullReport
	@WIP int = 0

as

set nocount on

declare @Report table
	(Seq int identity(1,1)
	,Col1 varchar(1000)
	,Col2 varchar(1000)
	,Col3 varchar(1000)
	,Col4 varchar(1000)
	,Col5 varchar(1000)
	,Col6 varchar(1000)
	,Col7 varchar(1000)
	,Col8 varchar(1000)
	)

if @WIP = -1 
	declare ClubsCursor cursor fast_forward for
		select EntryForm_Clubs.ClubID
			from EntryForm_Clubs
			join EntryForm_Teams T on T.ClubID=EntryForm_Clubs.ClubID 
			join Leagues on ID=LeagueID
			where WIP = 0
			order by EntryForm_Clubs.ClubID
else
	declare ClubsCursor cursor fast_forward for
		select distinct EntryForm_Clubs.ClubID
			from EntryForm_Clubs
			where WIP >= @WIP
			  and WIP = case when @WIP = -2 then 1 else WIP end
			order by EntryForm_Clubs.ClubID

declare @ClubID int

open ClubsCursor
fetch ClubsCursor into @ClubID
while @@fetch_status = 0
	begin
	insert @Report
		exec EntryForm_FullReportForClub @ClubID
	insert @Report 
		select '','','','','','','',''
	fetch ClubsCursor into @ClubID
	end
close ClubsCursor
deallocate ClubsCursor

delete @Report where seq = (select max(seq) from @Report)

select col1,col2,col3,col4,col5,col6,col7,col8 
	From @Report
	order by seq

GO
exec EntryForm_FullReport 0