USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CreateClubUser')
	drop procedure CreateClubUser
GO

CREATE procedure CreateClubUser
	(@eMailAddress varchar(255)
	,@Password varchar(25)
    ,@ClubID Int
    ,@Confirmed varchar(10)
    ,@Firstname varchar(5000)
    ,@Surname varchar(50)
    ,@Telephone varchar(25)
	)
as

set noCount on	
set xact_abort on

begin tran

	insert ClubUsers values
		(@eMailAddress,@Password, @Confirmed, @FirstName, @Surname, @Telephone, @ClubID)

	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert Club user',null,@eMailAddress+'|'+@Password+'|'+@Confirmed)  

commit tran

GO
