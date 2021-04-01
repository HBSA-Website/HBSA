USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetEmailTemplateHTML')
	drop procedure GetEmailTemplateHTML
GO

CREATE procedure GetEmailTemplateHTML
	(@EmailTemplatename varchar(128)
	)
as

set nocount on

Select EmailTemplateHTML, dtLodged
	from eMailTemplates
	where EmailTemplateName=@EmailTemplatename 

GO

exec GetEmailTemplateHTML 'fineImposed'

