USE [HBSA]

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Pictures')
	drop table Pictures
GO

create table Pictures
	(Category varchar(127)
	,[Filename] varchar(255)
	,Extension varchar(15)
	,[Description] varchar(1023) 
	)
GO
insert Pictures
	select Category 
	,PictureName 
	,Extension 
	,[Description]
	from godaddy.hbsa.dbo.pictures
select * from Pictures where category='General'