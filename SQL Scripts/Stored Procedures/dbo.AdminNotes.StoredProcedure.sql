USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AdminNotes')
	drop procedure AdminNotes
GO

CREATE procedure dbo.AdminNotes
	(@user varchar(50)
	)
as

set nocount on

if exists (select [user] from NotePad where [user]=@user)
	select  Notes = isnull(Notes,'')
		   ,Administrator = isnull(Forename + ' ' + Surname,@user) 
		from NotePad
		left join [Admin] on [user]=username 
		where [user]=@user 
else
	select  Notes = isnull(Notes,'')
		   ,Administrator = Forename + ' ' + Surname 
		from [Admin]
		left join NotePad on [user]=username 
		where username=@user

GO

exec AdminNotes 'FAQ'
