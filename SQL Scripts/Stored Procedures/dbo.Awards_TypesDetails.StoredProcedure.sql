USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypesDetails')
	DROP procedure Awards_TypesDetails
GO

create procedure Awards_TypesDetails

as

set nocount on

select * from Awards_Types order by AwardType

go

exec Awards_TypesDetails