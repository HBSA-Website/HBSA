USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='AmendAdministrator')
	DROP procedure AmendAdministrator
GO

create procedure AmendAdministrator
	(@Username nvarchar(50)
	,@Password varchar(255)
	,@ForeName varchar(50)
	,@Surname varchar(50)
	,@Email varchar(255)
	,@Function varchar(255)
	)
as

set nocount on

update Admin 
	set    [password] = @Password
		  ,Forename   = @ForeName
		  ,Surname    = @Surname
		  ,Email      = @Email
		  ,[Function] = @Function
	where username=@Username
GO
exec AmendAdministrator 'username','password','fname','lname','email','users'
select * from admin   