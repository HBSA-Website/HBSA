USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateEmailTemplate')
	drop procedure UpdateEmailTemplate
GO

CREATE procedure UpdateEmailTemplate
	(@EmailTemplatename varchar(128)
	,@EmailTemplateHTML varchar(max)
	)
as

set nocount on

update eMailTemplates
	set EmailTemplateHTML=@EmailTemplateHTML
	   ,dtLodged=dbo.UKdateTime(getUTCdate()) 
	where EmailTemplateName=@EmailTemplatename 

GO
exec UpdateEmailTemplate 'fineImposed','wehpewi'
select * from eMailTemplates where EmailTemplateName='fineImposed'
