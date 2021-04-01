USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetAdministrators')
	DROP procedure GetAdministrators
GO

create procedure GetAdministrators

as

select * from [admin] order by username
GO
exec GetAdministrators
