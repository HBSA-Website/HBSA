USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetAdverts')
	drop procedure GetAdverts
GO

CREATE procedure GetAdverts

as

set nocount on

select Advertiser 
	from Adverts
	order by Advertiser

GO

exec GetAdverts
