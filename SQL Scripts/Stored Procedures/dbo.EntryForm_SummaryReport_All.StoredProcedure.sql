USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_SummaryReport_All')
	DROP procedure EntryForm_SummaryReport_All
GO

create procedure EntryForm_SummaryReport_All

as

set nocount on

	select
	   ClubID,[Club Name]
      ,NoOpenTeams
      ,NoVetsTeams
	  ,NoBilliardsTeams
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Fee='£' + convert(varchar (8),dbo.EntryForm_Fee(c.ClubID))
	  ,[Contact List]=convert(varchar(2000),case when isnull(ContactEMail,'') <> '' 
	                                             then case when isnull(ContactName,'') <> '' 
												           then '(' + ContactName + ')'
	                                                       else ''
                                                      end + ContactEMail
	                                              else ''
											end)
	into #tmpReport
	       
	from EntryForm_ClubsDetails c
	outer apply (select NoOpenTeams=sum(case when LeagueID=1 then 1 else 0 end)
                       ,NoVetsTeams=sum(case when LeagueID=2 then 1 else 0 end)
	                   ,NoBilliardsTeams=sum(case when LeagueID=3 then 1 else 0 end) 
					   ,OpenEMail=max(case when LeagueID=1 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					   ,VetsEMail=max(case when LeagueID=2 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					   ,BilliardsEMail=max(case when LeagueID=3 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					
					from EntryForm_TeamDetail 
					where ClubID=c.ClubID
					group by ClubID) T
	

	where WIP >= 0
	  and [Club Name]<> 'Bye'

	order by WIP, [Club Name]

declare ReportCursor cursor fast_forward for
	select ClubID, isnull([Contact List],'') from #tmpReport
declare @ClubID int, @ContactList varchar(2000)
open ReportCursor
fetch ReportCursor into @ClubID, @ContactList
while @@fetch_status = 0
	begin
	declare TeamsCursor cursor fast_forward for
		select Contact, eMail from EntryForm_TeamDetail  where ClubID=@ClubID
    declare @eMail varchar(250), @Contact varchar(104)
	open TeamsCursor
	fetch TeamsCursor into @Contact, @eMail
	while @@fetch_status=0
		begin
		if isnull(@eMail,'') <> ''
			begin

			if @ContactList <> '' 
				set @ContactList=@ContactList + ';'

			if isnull(@Contact,'') <> ''
				set @ContactList=@ContactList + '(' + @Contact + ')'

			set @ContactList=@ContactList+@eMail

			end
		
		fetch TeamsCursor into @Contact, @eMail
		
		end

		close TeamsCursor
		deallocate TeamsCursor

		update #tmpReport	
			set [Contact List]=@ContactList
			where ClubID=@ClubID

	fetch ReportCursor into @ClubID, @ContactList
	end

close ReportCursor
deallocate ReportCursor

select ClubID,[Club Name],NoOpenTeams,NoVetsTeams,NoBilliardsTeams,[State],[Contact List]  
	from #tmpReport
	order by [Club Name] 

drop table #tmpReport

GO

exec EntryForm_SummaryReport_All
