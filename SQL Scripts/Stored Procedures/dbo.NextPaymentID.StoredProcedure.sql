USE [HBSA]
GO
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='NextPaymentID')
	drop procedure NextPaymentID  
GO

create procedure dbo.NextPaymentID
	(@ClubID as int, @PaymentID int = 0 OUTPUT
	)
as

/*  Why maintain a separate value for the next payment ID when it is implied from the payments table?
    ------------------------------------------------------------------------------------------------

		When using PayPal the system needs a payment ID at the start of the PayPal IPN process. This process
		initiates a payment request and then returns so that the payment can be confirmed by the user.
		Then a second call is made to PayPal to complete the payment process.  It is also possible that
		this second step is not completed either at the behest of the user or some other break in the
		process. The Payment ID is used to match calls back and forth as there may welll be multiple users
		paying at the same time.  At the same time non PayPal payments could be underway for multiple other users.
		Therefore there is a danger that they could get the same "next ID" if only using the MAX(ID)+1 
		even with transaction bounding. So this method ensures unique IDs.
*/

set noCount on	
set xact_abort on

begin tran

declare @ID varchar(15)
declare @cfgPaymentID int
declare @pmtPaymentID int
select @ID = [value] from Configuration where [key]='LastPaymentID'
if @ID is null
	begin
	insert Configuration select 'LastPaymentID','1' 
	set @cfgPaymentID = 1
	end
else
	set @cfgPaymentID = convert(int,@ID)

select @pmtPaymentID = MAX(PaymentID) from Payments
if @pmtPaymentID > @cfgPaymentID
	set @cfgPaymentID = @pmtPaymentID
	
if @cfgPaymentID > 2147483646
	set @cfgPaymentID = 1
else
	set @cfgPaymentID = @cfgPaymentID + 1

insert Payments  --Record paymentID against Club
	select dbo.UKdateTime(getUTCdate()), @ClubID, 0, '','Request PaymentID', 0,0, @cfgPaymentID, '','',''

update Configuration 
	set [value]=convert(varchar,@cfgPaymentID) 
	where [key]='LastPaymentID'

select @cfgPaymentID
set @PaymentID = @cfgPaymentID

commit tran
GO
--select [value] from Configuration where [key]='LastPaymentID'
--Declare @PaymentID int
--exec NextPaymentID 7--, @PaymentID OUTPUT
--select @PaymentID  --outout version
--select [value] from Configuration where [key]='LastPaymentID'  -- scalar result
 
