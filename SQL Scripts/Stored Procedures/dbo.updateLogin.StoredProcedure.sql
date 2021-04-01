USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[updateLogin]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[updateLogin]
	(@eMailAddress		varchar(255)
	,@OriginalPassword	varchar(255)
	,@Password			varchar(255)
	,@TeamID			int
	,@FirstName			varchar(50)
	,@Surname			varchar(50)
	,@Telephone			varchar(25)
	,@ConfirmCode       varchar(10) = ''
	)
as


set noCount on	
set xact_abort on

begin tran

if @Password <> ''
	if (select count(*) from Resultsusers
			where eMailAddress=@eMailAddress
			  and [Password] = @Password) > 0
			  raiserror('Cannot change the password as this email password combination already exists',17,0)
	else
		begin
		
		update ResultsUsers 
			set  [Password] = @Password
			    ,TeamID = @TeamID
				,FirstName = @FirstName
				,Surname = @Surname
				,Telephone = @Telephone
				,Confirmed = case when @ConfirmCode='' then Confirmed else @ConfirmCode end
		where eMailAddress=@eMailAddress
		  and [Password] = @OriginalPassword

		insert ActivityLog values
			(dbo.UKdateTime(getUTCdate()),'Update user with password',null,@eMailAddress+'|'+@OriginalPassword+'>'+@Password )
	
		end
else
	begin
	
	update ResultsUsers 
		set  TeamID = @TeamID
			,FirstName = @FirstName
			,Surname = @Surname
			,Telephone = @Telephone
			,Confirmed = case when @ConfirmCode='' then Confirmed else @ConfirmCode end
	where eMailAddress=@eMailAddress
	  and [Password] = @OriginalPassword

	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'Update user',null,@eMailAddress+'|'+@OriginalPassword)

	end

commit tran
GO
