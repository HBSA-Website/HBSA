USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CreateEmailTemplate')
	drop procedure CreateEmailTemplate
GO

CREATE procedure CreateEmailTemplate
	(@EmailTemplatename varchar(128)
	,@EmailTemplateHTML varchar(max)
	)
as

set nocount on

if exists (select EmailTemplateName from EmailTemplates where EmailTemplateName=@EmailTemplatename )
	begin
	declare @msg varchar(500)
	select @msg='Cannot create EmailTemplate as EmailTemplate name "' + @EmailTemplatename + '" already exists'
	raiserror(@msg,17,1)
	end
else
insert EmailTemplates
	select @EmailTemplatename, @EmailTemplateHTML,dbo.UKdateTime(getUTCdate()) 

GO
exec CreateEmailTemplate 'pete','<div>Petes test</div>'
select * from EmailTemplates
delete EmailTemplates where EmailTemplateName='pete'
select * from EmailTemplates