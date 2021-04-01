USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Fines_RescindFine')
	drop procedure Fines_RescindFine
GO

create procedure dbo.Fines_RescindFine
	(@FineID int
	,@Override bit = 0
	)
as

set nocount on
set xact_abort on


if exists (select top 1 FineID 
				from Payments where PaymentReason='Fine' and FineID = @FineID)
	If @Override = 0
		begin
		raiserror ('This fine has at least one associated payment against it', 17,0)
		return
		end

begin tran

delete Payments where PaymentReason='Fine' and FineID = @FineID
delete Fines where ID = @FineID	

commit tran

GO