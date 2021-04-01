create table ContentData
	(ID int identity(1,1)
	,ContentName varchar(128)
	,ContentHTML varchar(max)
	,dtLodged datetime
	)
insert ContentData
	(ContentName, ContentHTML, dtLodged)	 
	select ContentName, ContentHTML, getDate() from Content
select * from ContentData