USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPayments')
	drop procedure dbo.GetPayments
GO

CREATE procedure dbo.GetPayments
	(@ClubID int = 0
	,@PaymentReason varchar(255) = ''
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
	where (ClubID=@ClubID or @ClubID = 0)
	  and AmountPaid <> 0
	  and (PaymentReason = @PaymentReason or
	       @PaymentReason = '') 

GO

