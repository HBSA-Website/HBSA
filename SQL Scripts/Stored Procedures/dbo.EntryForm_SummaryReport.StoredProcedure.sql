USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_SummaryReport')
	DROP procedure EntryForm_SummaryReport
GO

create procedure EntryForm_SummaryReport
	@WIP int = 0 -- only report entries that have at least reached this stage
	             -- -1 = show all those who have done nothing
				 -- -2 = show those who have started but not yet submitted
as

set nocount on

if @WIP = -1 
	select C.ClubID,[Club Name]
	from EntryForm_Clubs C
	left join EntryForm_Teams T on T.ClubID=C.ClubID 
	left join Leagues on ID=LeagueID 

	where WIP =0
	  and [Club Name]<> 'Bye'

	group by C.ClubID,[Club Name],dbo.EntryForm_Fee(C.ClubID),FeePaid,WIP
	order by [Club Name]

else
	select C.ClubID,[Club Name]
      ,NoOpenTeams=sum(case when LeagueID=1 then 1 else 0 end)
      ,NoVetsTeams=sum(case when LeagueID=2 then 1 else 0 end)
	  ,NoBilliardsTeams=sum(case when LeagueID=3 then 1 else 0 end)
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Fee = '£' + convert(varchar (8),dbo.EntryForm_Fee(C.ClubID))
	  ,AmountPaid = '£' + convert(varchar (8),ISNULL((select SUM(AmountPaid)
															from Payments
															where ClubID=C.ClubID
															  and PaymentReason='League Entry Fee')
							                           ,0)
                                 )
       
	from EntryForm_Clubs C
	left join EntryForm_Teams T on T.ClubID=C.ClubID 
	left join Leagues on ID=LeagueID 

	where WIP >= @WIP
	  and WIP = case when @WIP = -5 then 1 else WIP end
	  and [Club Name]<> 'Bye'

	group by C.ClubID,[Club Name],dbo.EntryForm_Fee(C.ClubID),FeePaid,WIP
	order by [Club Name]

GO

exec EntryForm_SummaryReport -1
     