USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionEntryForm_GetPayments')
	drop procedure CompetitionEntryForm_GetPayments
GO

CREATE procedure CompetitionEntryForm_GetPayments
	(@ClubID int
	)
as

set nocount on

select [Date]=CONVERT(varchar(17),DateTimePaid,113)
      ,PaymentMethod
	  ,PaymentReason
	  ,AmountPaid 
	  ,PaymentFee
	  ,PaymentID
	  ,TransactionID
	  ,PaidBy=ISNULL(PaidBy,'')

	  --, * 

	from Payments
	where ClubID=@ClubID
	  and AmountPaid <> 0
	  and PaymentReason = 'Competition Entry Fee'

GO
