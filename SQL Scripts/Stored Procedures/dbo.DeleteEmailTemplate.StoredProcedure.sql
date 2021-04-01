USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteEmailTemplate')
	drop procedure DeleteEmailTemplate
GO

CREATE procedure DeleteEmailTemplate
	(@EmailTemplatename varchar(128)
	)
as

set nocount on

if not exists (select EmailTemplateName from EmailTemplates where EmailTemplateName=@EmailTemplatename )
	begin
	declare @msg varchar(500)
	select @msg='Cannot delete EmailTemplate as EmailTemplate name "' + @EmailTemplatename + '" does not exist'
	raiserror(@msg,17,1)
	end
else
delete EmailTemplates
	where EmailTemplateName=@EmailTemplatename

GO
exec CreateEmailTemplate 'pete','<div> Pete test </div>'
select * from EmailTemplates where EmailTemplateName='pete'
exec DeleteEmailTemplate 'pete'

select * from EmailTemplates where EmailTemplateName='pete'

