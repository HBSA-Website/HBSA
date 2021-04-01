USE HBSA_20141116
GO

alter table Homepages
	drop column Welcome2
GO
EXEC sys.sp_rename 
    @objname = N'dbo.Homepages.Welcome', 
    @newname = 'PageName', 
    @objtype = 'COLUMN'
GO
alter table HomePages
	alter column PageName varchar(255)
GO
delete Homepages where ID=0
GO
update HomePages set Pagename='Global'
GO
alter table Homepages
	drop column ID
GO
select * from Homepages

