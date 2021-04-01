USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureCategory')
	drop procedure GetPictureCategory
GO

CREATE procedure GetPictureCategory
	(@category varchar(127)
	)
as

set nocount on

if exists(select Sequence from PictureCategories where Category=@category )
	select Sequence,Category from PictureCategories where Category=@category 
else
		select -1,''

GO

exec GetPictureCategory 'General'

