USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetAdvert')
	drop procedure GetAdvert
GO

CREATE procedure GetAdvert
	(@Advertiser varchar(255)
	)
as

set nocount on

	Select Advertiser
		  ,Extension 
		  ,WebURL 
		  ,AdvertBinary
		from adverts
		where Advertiser=@Advertiser

GO

exec GetAdvert 'Barden Print'
