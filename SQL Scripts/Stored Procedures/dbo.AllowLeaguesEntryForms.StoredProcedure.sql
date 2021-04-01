USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AllowLeaguesEntryForms')
	drop procedure AllowLeaguesEntryForms
GO

create procedure AllowLeaguesEntryForms

as

set nocount on
--Allow/enable entry forms

begin tran

update configuration
	set value='1'
	where [key]='AllowLeaguesEntryForms'

update EntryForm_Clubs
	set WIP = 2
	where WIP =3

commit tran

GO
