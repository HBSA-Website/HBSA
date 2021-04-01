USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionEntryForm_ClearAll')
	drop procedure CompetitionEntryForm_ClearAll
GO
create procedure CompetitionEntryForm_ClearAll

as

set nocount on
set xact_abort on

begin tran

declare @SQL varchar(4000)
declare @now varchar(19)
set @now=convert(varchar(19),dbo.UKdateTime(getUTCdate()),121)
set @SQL = 'select * into [Competitions_EntryForms ' + @now + '] from Competitions_EntryForms ' +
           'select * into [Competitions_EntryFormsClubs ' + @now + '] from Competitions_EntryFormsClubs '
exec (@SQL)

truncate table Competitions_EntryForms
truncate table Competitions_EntryFormsClubs

delete Payments
	where PaymentReason = 'Request PaymentID' 

insert PaymentsHistory 
	select P.* 
		from Payments P
		left join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'Competition Entry Fee' 
		  and H.DateTimePaid is null

delete Payments
		from Payments P
		join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'Competition Entry Fee' 

commit tran

GO

exec CompetitionEntryForm_ClearAll