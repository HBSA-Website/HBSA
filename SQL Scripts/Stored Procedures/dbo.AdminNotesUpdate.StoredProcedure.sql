USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AdminNotesUpdate')
	drop procedure AdminNotesUpdate
GO

CREATE procedure dbo.AdminNotesUpdate
	(@user varchar(50)
	,@notes varchar(max)
	)
as

set nocount on

if exists (select [user] from NotePad where [user]=@user)
	update NotePad
		set Notes = @Notes
		where [user] = @user
else
	insert NotePad
		select @user, @Notes

GO
exec AdminNotesUpdate 'dennis', 'test stuff'
exec AdminNotes 'dennis'
select * from NotePad
truncate table notepad