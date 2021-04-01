USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Fines_GetPayments')
	DROP procedure dbo.Fines_GetPayments
GO

create procedure dbo.Fines_GetPayments
	(@ClubID int = 0
	,@FineID int
	)
	
as

set nocount on

select [Date]=CONVERT(varchar(17),DateTimePaid,113)
      ,PaymentMethod
	  ,PaymentReason
	  ,AmountPaid 
	  ,PaymentFee
	  ,PaymentID
	  ,FineID
	  ,PaidBy=ISNULL(PaidBy,'')
	from Payments P
	left join Clubs C 
			on C.ID=P.ClubID
	
	where (ClubID=@ClubID OR @ClubID = 0)
	  and PaymentReason='Fine'
	  and FineID=@FineID
GO
exec Fines_GetPayments @FineID= 103
