USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetAdministrator')
	DROP procedure GetAdministrator
GO

create procedure GetAdministrator
	@username varchar(50)
as

select * from [admin] where Username = @Username
GO
exec GetAdministrator 'Peter'
