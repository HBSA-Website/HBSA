USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Competitions_GetEntryForm')
	drop procedure Competitions_GetEntryForm
GO

CREATE procedure Competitions_GetEntryForm
	(@ClubID int
	)
as

set nocount on

select ClubID
	  ,WIP
      ,AmountPaid = ISNULL((select SUM(AmountPaid)
								from Payments
								where ClubID=Competitions_EntryFormsClubs.ClubID
								  and PaymentReason='Competition Entry Fee')
						   , 0)
      ,EntryFee   = isnull((select sum(EntryFee) 
								from Competitions_EntryForms 
								cross apply (Select EntryFee from Competitions where ID=CompetitionID) ef
								where ClubID=@ClubID) 
						   ,0)
	  ,ClubName
	  ,PrivacyAccepted
	from Competitions_EntryFormsClubs 
	cross apply (select ClubName=[Club Name] from Clubs where ID=ClubID) y
	where ClubID=@ClubID

select [Date]=CONVERT(varchar(17),DateTimePaid,113)
      ,PaymentMethod
	  ,PaymentReason
	  ,Amount = '&pound;' + CONVERT (varchar, AmountPaid)
	  ,Note
	  ,PaidBy=ISNULL(PaidBy,'')
	from Payments
	where ClubID=@ClubID
	  and AmountPaid <> 0
	  and PaymentReason = 'Competition Entry Fee'
GO

--exec Competitions_GetEntryForm 43
