USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Money_SummaryReport')
	DROP procedure dbo.Money_SummaryReport
GO

create procedure dbo.Money_SummaryReport
    (	@Owing tinyint = 1 -- set non zero to only show outstanding debts
    ,   @PaymentReason varchar(255) = ''
	)
as

set nocount on

declare @Report table
	(ClubID int
	,[Club Name] varchar(50)
	,Reason varchar(255)
	,[State] varchar(255)
	,Amount decimal(9,2)
	,Paid decimal(9,2)
	,FineID int)
if @PaymentReason like '%league%' or @PaymentReason=''
	insert @Report
	select C.ClubID,[Club Name]=ISNULL(C.[Club Name],'')
		  ,Reason = 'League Entry Fee'
		  ,[State]=dbo.EntryForm_State(WIP)
		  ,Amount = dbo.EntryForm_Fee(C.ClubID)
		  ,Paid = ISNULL((select SUM(AmountPaid)
								from Payments
								where ClubID=C.ClubID
								and PaymentReason='League Entry Fee')
				         ,0)
		  ,0
		from EntryForm_Clubs C
		join EntryForm_Teams T on T.ClubID=C.ClubID 
		join Leagues on ID=LeagueID 

		where (@Owing = 0 or dbo.EntryForm_Fee(C.ClubID) > ISNULL((select SUM(AmountPaid)
																from Payments
																where ClubID=C.ClubID
																  and PaymentReason='League Entry Fee')
								                           ,0))
		  and WIP > 0 -- don't show when not started entering data

		group by C.ClubID,[Club Name],dbo.EntryForm_Fee(C.ClubID),FeePaid,WIP
		order by [Club Name]

if @PaymentReason like '%comp%' or @PaymentReason=''
	insert @Report
	select E.ClubID, [Club Name]=ISNULL(C.[Club Name],'')
	  ,Reason = 'Competition Entry Fee'
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Amount=sum(EntryFee)
	  ,Paid=isnull(AmountPaid,0)
	  ,FineID=0
     
	from Competitions_EntryForms E
	join Clubs C on ClubID=C.ID 
	join Competitions_EntryFormsClubs F on F.ClubID=E.ClubID
	join Competitions on Competitions.ID=CompetitionID
	outer apply (select AmountPaid = SUM(AmountPaid) from Payments where ClubID=E.ClubID and PaymentReason = 'Competition Entry Fee') ap

	group by E.ClubID, C.[Club Name], WIP, AmountPaid

	having (@Owing = 0 or sum(EntryFee) > isnull(AmountPaid,0))

if @PaymentReason like '%fine%' or @PaymentReason=''
	insert @Report
	select 
		 F.ClubID
		,[Club Name] = ISNULL([Club Name],'')
		,Reason = 'Fine'
		,[State]=case when Fine > isnull(AmountPaid,0) 
						then case when isnull(AmountPaid,0) = 0 
									then 'NOT paid'
									else 'Not fully paid'
							 end		 
						else 'Paid' 
				  end
		,Amount=Fine
		,Paid=isnull(AmountPaid,0)
		,FineID = F.ID
	from Fines F
	left join Clubs C 
			on C.ID=F.ClubID
	outer apply (select AmountPaid=sum(isnull(AmountPaid,0))
					from Payments
					where ClubID=F.ClubID
					  and FineID=F.ID) P
	
	where (@Owing = 0 or Fine > isnull(AmountPaid,0))
	
	order by dtlodged desc

select ClubID
      ,[Club Name]
	  ,Reason
	  ,[State]
	  ,Amount
	  ,Paid
	  ,FineID
	from @Report
	order by case when Reason like '%comp%' then 2
	              when Reason like '%league%' then 1
				                              else 3
			 end
			,[Club Name]

GO

exec Money_SummaryReport 0,'comp'
