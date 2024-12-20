USE [HBSA]

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'eMailTemplates')
	drop table dbo.eMailTemplates
GO

create table dbo.eMailTemplates
	(ID int identity (1,1)
	,eMailTemplateName varchar(128)
	,eMailTemplateHTML varchar(max)
	,dtLodged datetime)
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].eMailTemplates	(eMailTemplateName,eMailTemplateHTML,dtLodged) select 'fineImposed','',getUTCdate()
INSERT [dbo].eMailTemplates	(eMailTemplateName,eMailTemplateHTML,dtLodged) select 'handicapChange','',getUTCdate()