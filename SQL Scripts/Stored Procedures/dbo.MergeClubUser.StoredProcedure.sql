USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MergeClubUser')
	drop procedure MergeClubUser
GO

CREATE procedure MergeClubUser
	(@eMailAddress varchar(255)
	,@Password varchar(255) = NULL
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

MERGE ClubUsers AS target
    USING (SELECT @ClubID) AS source (ID)
    
    ON (target.ClubID = source.ID)
    
    WHEN MATCHED AND @eMailAddress='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
			 ClubID				= @ClubID
            ,eMailaddress		= @eMailaddress
			,[Password]			= case when @Password is null then [Password] else @Password end 
			,Confirmed			= @Confirmed
			,FirstName			= @FirstName
			,Surname			= @Surname
			,Telephone			= @Telephone
	
	WHEN NOT MATCHED THEN
		INSERT 
			( eMailaddress ,[Password],Confirmed,  FirstName,  Surname,  Telephone,  ClubID)
		values
			(@eMailAddress,@Password, @Confirmed, @FirstName, @Surname, @Telephone, @ClubID)

	;

	insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'Merge Club user',null,@eMailAddress+'|'+@Password+'|'+@Confirmed)  

commit tran

GO
