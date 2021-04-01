USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CreateContent')
	drop procedure CreateContent
GO

CREATE procedure CreateContent
	(@Contentname varchar(128)
	,@ContentHTML varchar(max)
	)
as

set nocount on

if exists (select ContentName from ContentData where ContentName=@Contentname )
	begin
	declare @msg varchar(500)
	select @msg='Cannot create content as content name "' + @Contentname + '" already exists'
	raiserror(@msg,17,1)
	end
else
insert ContentData
	select @Contentname, @ContentHTML,dbo.UKdateTime(getUTCdate()) 

GO
exec CreateContent 'pete','<div>Petes test</div>'

select * from ContentData where ContentName='pete'

delete ContentData where ContentName='pete'
