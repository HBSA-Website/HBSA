USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteContent')
	drop procedure DeleteContent
GO

CREATE procedure DeleteContent
	(@Contentname varchar(128)
	)
as

set nocount on

if not exists (select ContentName from ContentData where ContentName=@Contentname )
	begin
	declare @msg varchar(500)
	select @msg='Cannot delete content as content name "' + @Contentname + '" does not exist'
	raiserror(@msg,17,1)
	end
else
delete ContentData
	where ContentName=@Contentname

GO
exec CreateContent 'pete','<div> Pete test </div>'
select * from ContentData where ContentName='pete'
exec DeleteContent 'pete'

select * from ContentData where ContentName='pete'

