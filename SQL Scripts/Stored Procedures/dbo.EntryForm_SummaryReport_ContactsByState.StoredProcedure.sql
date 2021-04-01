USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_SummaryReport_ContactsByState')
	DROP procedure EntryForm_SummaryReport_ContactsByState
GO

create procedure EntryForm_SummaryReport_ContactsByState

as

set nocount on

declare @tmpContacts table
	(WIP int
	,Contact varchar(400)
	)


declare ReportCursor cursor fast_forward for
	select Distinct WIP from EntryForm_Clubs where WIP is not null

declare @WIP int
declare @tmp varchar(4000)

open ReportCursor
fetch ReportCursor into @WIP
while @@fetch_status = 0
	begin

	declare Clubs_Cursor cursor fast_forward for
	select clubID, isnull(ContactName,''), isnull(ContactEMail,'')
		from EntryForm_ClubsDetails
		where WIP = @WIP
    declare @ClubID int, @ContactName varchar(104), @ClubLoginEmail varchar(250)
	open Clubs_Cursor
	Fetch Clubs_Cursor into @ClubID, @ContactName, @ClubLoginEmail
	while @@fetch_status=0
		begin
		set @tmp=case when @ClubLoginEmail <> '' then case when @ContactName<>'' then '('+@ContactName+')' else '' end + @ClubLoginEmail else '' end
		if @tmp <> '' and @WIP is not null
			insert @tmpContacts select @WIP, @tmp

		declare TeamsCursor cursor fast_forward for
			select Contact, eMail 
				from EntryForm_Teams  
				outer apply (select Contact = dbo.FullPlayerName(Forename, Initials, Surname), eMail 
								From EntryForm_Players
								where PlayerID = Captain) X
				where ClubID=@ClubID
	    declare @eMail varchar(250), @Contact varchar(104)
		open TeamsCursor
		fetch TeamsCursor into @Contact, @eMail
		while @@fetch_status=0
			begin
			set @tmp=case when @eMail <> '' then case when @Contact<>'' then '('+@Contact+')' else '' end + @eMail else '' end
			if @tmp <> ''and  @WIP is not null
				insert @tmpContacts select @WIP, @tmp
		
			fetch TeamsCursor into @Contact, @eMail
		
			end

			close TeamsCursor
			deallocate TeamsCursor

		Fetch Clubs_Cursor into @ClubID, @ContactName, @ClubLoginEmail
		end

		close Clubs_Cursor
		deallocate Clubs_Cursor

	fetch ReportCursor into @WIP

	end
	  					 
close ReportCursor
deallocate ReportCursor

select WIP
      ,[Contact List]=convert(varchar(8000),'')	
	into #tmpReport
	from EntryForm_Clubs
	where WIP is not null
	group by WIP
	order by WIP
	
declare WIPCursor cursor fast_forward for
	select distinct WIP, Contact from @tmpContacts where WIP is not null
open WIPCursor
declare @prevWIP int
set @prevWIP=-1
fetch WIPCursor into @WIP, @Contact
while @@fetch_status=0
	begin
	update #tmpReport 
		set [Contact List]=[Contact List]+';'+@Contact 
		where WIP=@WIP
	fetch WIPCursor into @WIP, @Contact
	end

close WIPCursor
deallocate WIPCursor

update #tmpReport
	set [Contact List]=right([Contact List],len([Contact List])-1)

select   WIP
		,State=dbo.EntryForm_State(WIP)
		,[Contact List] 
	from #tmpReport
	where WIP is not null
	order by WIP

drop table #tmpReport

GO

exec EntryForm_SummaryReport_ContactsByState
