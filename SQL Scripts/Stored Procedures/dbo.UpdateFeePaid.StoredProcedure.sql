use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdatePayment')
	drop procedure UpdatePayment
GO

create procedure dbo.UpdatePayment
	(@PaymentID int
	,@ClubID int
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

merge Payments as target
    using (select PaymentID=@PaymentID) as source
    on (target.PaymentID = source.PaymentID)
    
    when matched then
		update
		set  ClubID=@ClubID
		    ,FineID=@FineID
		    ,DateTimePaid=@DateTimePaid
			,PaymentMethod=@PaymentMethod
			,PaymentReason=@PaymentReason
			,PaymentFee=@PaymentFee
			,AmountPaid=@amount
			,Note=@Note
			,TransactionID=@TransactionID
			,PaidBy=@PaidBy

	when not matched then
		insert
			(DateTimePaid
			,ClubID
			,FineID
			,PaymentMethod
			,PaymentReason
			,AmountPaid
			,PaymentFee
			,PaymentID
			,Note
			,TransactionID
			,PaidBy)
		values
			(@DateTimePaid
			,@ClubID
			,@FineID
			,@PaymentMethod
			,@PaymentReason
			,@Amount
			,@PaymentFee
			,@PaymentID
			,@Note
			,@TransactionID
			,@PaidBy)
		;



insert ActivityLog
	select dbo.UKdateTime(getUTCdate()),'Amount paid merged(ID=' + convert(varchar,@PaymentID) + ')',@ClubID,@user

commit tran
GO

