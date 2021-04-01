use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AddPayment')
	drop procedure AddPayment
GO

create procedure dbo.AddPayment
	(@ClubID int
	,@FineID int
	,@PaymentMethod varchar(255)
	,@PaymentReason varchar(255)
	,@amount decimal(9,2)
	,@PaymentFee decimal(9,2)
    ,@Note varchar(255)
	,@TransactionID varchar(17)
	,@user varchar(1024)
	,@PaidBy varchar(1000)
	,@DateTimePaid datetime
	)
as

set nocount on
set xact_abort on

begin tran

if @DateTimePaid is null
	set @DateTimePaid=dbo.UKdateTime(getUTCdate())

--get the next PaymentID
Declare @PaymentID int
exec NextPaymentID @ClubID, @PaymentID OUTPUT

--merge the new payment data
exec UpdatePayment
	 @PaymentID 
	,@ClubID 
	,@FineID
	,@PaymentMethod
	,@PaymentReason
	,@amount 
	,@PaymentFee
    ,@Note 
	,@TransactionID
	,@user 
	,@PaidBy
	,@DateTimePaid

insert ActivityLog
	select dbo.UKdateTime(getUTCdate()),'Payment added(ID=' + convert(varchar,@PaymentID) + ')',@ClubID,@user

commit tran
GO

