USE HBSA
GO

if exists (select table_name from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Covid19Compliance')
	drop table dbo.Covid19Compliance
GO

create table  dbo.Covid19Compliance 
	(ClubID int
	,Check1 bit
	,Check2 bit
	,Check3 bit
	,Check4 bit
	,Text3 varchar(2000)
	,Text4 varchar(2000)
	,Text5 varchar(2000)
	,dtLodged datetime
	)
GO

