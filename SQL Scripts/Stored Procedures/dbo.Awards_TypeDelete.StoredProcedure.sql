use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypeDelete')
	drop procedure dbo.Awards_TypeDelete
GO

create procedure dbo.Awards_TypeDelete
	(@AwardType int
	,@Override bit=0
	)
as

set nocount on

if exists (select * from Awards_Template 
					where @AwardType = AwardType)
and @Override <> 1
	raiserror('There is a linked award template',17,17)

else
         
	delete Awards_Types
		where @AwardType = AwardType

GO
exec Awards_TypeDelete 1,0
