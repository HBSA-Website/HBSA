USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetEmailTemplateNames')
	drop procedure GetEmailTemplateNames
GO

CREATE procedure GetEmailTemplateNames
	
as

set nocount on

select EmailTemplateName 
	from eMailTemplates
	order by EmailTemplateName

GO

exec GetEmailTemplateNames

