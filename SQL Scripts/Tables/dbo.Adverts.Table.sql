USE [HBSA]

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Adverts')
	drop table Adverts
GO

create table Adverts
	(Advertiser varchar(255)
	,Extension varchar(15)
	,WebURL varchar(1023) 
	,AdvertBinary varbinary(max)
	)
GO
