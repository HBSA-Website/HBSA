USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetBreaksCategory')
	drop procedure GetBreaksCategory
GO

create procedure dbo.GetBreaksCategory
	(@BreakID int
	)
as	

set nocount on

select * 
	from BreaksCategories where ID = @BreakID

GO
exec GetBreaksCategory 3