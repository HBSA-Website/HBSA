USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureNames')
	drop procedure GetPictureNames
GO

CREATE procedure GetPictureNames
	(@category varchar(127)
	)
as

set nocount on

select [Filename], [Description] 
	from Pictures
	where Category=@category
	  and [Filename] is not null
	order by [Filename]

GO

exec GetPictureNames 'General'


