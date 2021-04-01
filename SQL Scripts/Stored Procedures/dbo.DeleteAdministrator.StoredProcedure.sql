USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='DeleteAdministrator')
	DROP procedure DeleteAdministrator
GO

create procedure DeleteAdministrator
	(@Username nvarchar(50)
	)
as

set nocount on

delete Admin 
	where Username=@Username
GO
exec DeleteAdministrator 'username'
select * from admin   