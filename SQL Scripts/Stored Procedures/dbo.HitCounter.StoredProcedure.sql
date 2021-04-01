USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='HitCounter')
	DROP procedure HitCounter
GO

create procedure HitCounter
	@PageName varchar (255)
as

set nocount on

SELECT HitCounter 
	FROM Homepages 
	where Pagename=@PageName
GO

exec HitCounter 'Home'