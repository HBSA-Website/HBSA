USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CompetitionEntryForm_SummaryReport')
	DROP procedure CompetitionEntryForm_SummaryReport
GO

create procedure CompetitionEntryForm_SummaryReport
	@WIP int = 0 -- only report entries that have at least reached this stage
	             -- -1 = only those that have not entered
as

set nocount on
if @WIP = -1 
	select E.ClubID, C.[Club Name]
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Fee='£' + convert(varchar (8),sum(EntryFee))
	  ,AmountPaid='£' + convert(varchar (8),isnull(AmountPaid,0))
      ,privacyAccepted
	from Competitions_EntryForms E
	join Clubs C on ClubID=C.ID 
	join Competitions_EntryFormsClubs F on F.ClubID=E.ClubID
	join Competitions on Competitions.ID=CompetitionID
	outer apply (select AmountPaid = SUM(AmountPaid) from Payments where ClubID=E.ClubID and PaymentReason = 'Competition Entry Fee') ap

	where WIP = 0

	group by E.ClubID, C.[Club Name], WIP, AmountPaid, privacyAccepted
	order by [Club Name], WIP

else
	select E.ClubID, C.[Club Name]
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Fee='£' + convert(varchar (8),sum(EntryFee))
	  ,AmountPaid='£' + convert(varchar (8),isnull(AmountPaid,0))
      ,PrivacyAccepted
	from Competitions_EntryForms E
	join Clubs C on ClubID=C.ID 
	join Competitions_EntryFormsClubs F on F.ClubID=E.ClubID
	join Competitions on Competitions.ID=CompetitionID
	outer apply (select AmountPaid = SUM(AmountPaid) from Payments where ClubID=E.ClubID and PaymentReason = 'Competition Entry Fee') ap

	where WIP >= @WIP

	group by E.ClubID, C.[Club Name], WIP, AmountPaid, PrivacyAccepted
	order by [Club Name], WIP

GO
--exec CompetitionEntryForm_SummaryReport 1
