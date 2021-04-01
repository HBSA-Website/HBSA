USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CreateUser')
	drop procedure CreateUser
GO

create procedure dbo.CreateUser
	(@eMailAddress varchar(255)
	,@Password varchar(255)
    ,@TeamID Int
    ,@Confirmed varchar(10)
    ,@Firstname varchar(5000)
    ,@Surname varchar(50)
    ,@Telephone varchar(25)
	)
as

set noCount on	
set xact_abort on

begin tran

if (select COUNT(*) from Resultsusers
		where eMailAddress=@eMailAddress
		  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS) > 0
	raiserror('This email/password combination already exists',17,0)
else 
if (select COUNT(*) from Resultsusers
		where eMailAddress=@eMailAddress
		  and TeamID=@TeamID) > 0
	raiserror('This email address is already registered for this team',17,0)
else 
	begin
	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert user',null,@eMailAddress+'|'+@Password+'|'+@Confirmed)  

	insert ResultsUsers values
		(@eMailAddress,@Password, @Confirmed, @FirstName, @Surname, @Telephone, @TeamID)

	select top 1 ID 
		from ResultsUsers	
		where eMailAddress=@eMailAddress
		  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS
		  and TeamID=@TeamID
	end

commit tran

GO

exec CreateUser 'gilbertp@outlook.com','password2',28,'Confirmed','P','Gil',''
exec deleteLogin 'gilbertp@outlook.com','password2'