USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AllowCompetitionsEntryForms')
	drop procedure AllowCompetitionsEntryForms
GO

create procedure AllowCompetitionsEntryForms

as

set nocount on
--Allow/enable entry forms

begin tran

update configuration
	set value='1'
	where [key]='AllowCompetitionsEntryForms'

update Competitions_EntryFormsClubs
	set WIP = 2
	where WIP =3

commit tran

GO
