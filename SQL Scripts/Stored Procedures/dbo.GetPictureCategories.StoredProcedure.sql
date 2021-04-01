USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureCategories')
	drop procedure GetPictureCategories
GO

CREATE procedure GetPictureCategories

as

set nocount on

select * 
	from PictureCategories 
	order by Sequence

GO

exec GetPictureCategories 

