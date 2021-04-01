USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureBinary')
	drop procedure GetPictureBinary
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureDetails')
	drop procedure GetPictureDetails
GO

CREATE procedure GetPictureDetails
	(@Category varchar(127)
	,@Filename varchar(255)
	)
as

set nocount on

Select Extension, [Description]
	from Pictures
	where isnull(Category,'Gallery')=isnull(@Category,'Gallery')
	  and isnull([Filename],'None')=isnull(@Filename,'None') 

GO

exec GetPictureDetails 'General','Canalside A Team'

