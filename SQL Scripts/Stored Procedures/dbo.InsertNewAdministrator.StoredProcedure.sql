USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='InsertNewAdministrator')
	DROP procedure InsertNewAdministrator
GO

create procedure InsertNewAdministrator
	(@Username nvarchar(50)
	,@Password varchar(255)
	,@ForeName varchar(50)
	,@Surname varchar(50)
	,@Email varchar(255)
	,@Function varchar(255)
	)
as

set nocount on

insert Admin 
	select @Username
		  ,@Password
		  ,@ForeName
		  ,@Surname
		  ,@Email
		  ,@Function
GO
exec InsertNewAdministrator 'username','password2','fname2','lname2','email2','users2'
select * from admin
   