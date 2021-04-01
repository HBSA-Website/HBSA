USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[loginDetails]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[loginDetails]
GO

/****** Object:  StoredProcedure [dbo].[LoginPasswordReset]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[LoginPasswordReset]
GO

/****** Object:  StoredProcedure [dbo].[MergeClubUser]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[MergeClubUser]
GO

/****** Object:  StoredProcedure [dbo].[confirmClubLogin]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[confirmClubLogin]
GO

/****** Object:  StoredProcedure [dbo].[confirmLogin]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[confirmLogin]
GO

/****** Object:  StoredProcedure [dbo].[checkClubLogin]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[checkClubLogin]
GO

/****** Object:  StoredProcedure [dbo].[ClubLoginDetails]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[ClubLoginDetails]
GO

/****** Object:  StoredProcedure [dbo].[ClubLoginPasswordReset]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[ClubLoginPasswordReset]
GO

/****** Object:  StoredProcedure [dbo].[deleteLogin]    Script Date: 18/02/2017 13:52:57 ******/
DROP PROCEDURE [dbo].[deleteLogin]
GO

/****** Object:  StoredProcedure [dbo].[deleteLogin]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[deleteLogin]
	(@eMailAddress varchar(255)
	,@Password     varchar(255) = ''
	)
as

set noCount on	

delete Resultsusers
	where eMailAddress=@eMailAddress
	  and [Password] = @Password
insert ActivityLog values
	(getdate(),'DeleteUser',null,@eMailAddress+'|'+@Password)  



GO

/****** Object:  StoredProcedure [dbo].[ClubLoginPasswordReset]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ClubLoginPasswordReset]
	(@ClubID           int
	,@Password     varchar(255)
	)
as

set noCount on	

update ClubUsers 
	set Password=@Password
	where ClubID=@ClubID


GO

/****** Object:  StoredProcedure [dbo].[ClubLoginDetails]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ClubLoginDetails]
	(@eMailAddress varchar(255) = NULL
	,@ClubID       int = NULL
	)
as

set noCount on	

select eMailAddress
      ,[Password]
      ,Club=C.[Club Name]
      ,Confirmed=Confirmed  
      ,FirstName = ISNULL(Firstname,'')
      ,Surname=  ISNULL(Surname,'')
      ,Telephone = ISNULL(Telephone,'')
	  ,U.ClubID
	from Clubusers U
	join Clubs C on C.ID=U.ClubID
	
	where (eMailAddress=@eMailAddress)
	   or U.ClubID=@ClubID
	order by case when Confirmed <> 'Confirmed' then Confirmed else '' end


GO

/****** Object:  StoredProcedure [dbo].[checkClubLogin]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[checkClubLogin]
	(@eMailAddress varchar(255) = null
	,@Password varchar(255) = null
	,@ClubID int = 0
	)
as

set noCount on	

if @ClubID > 0
	if @EmailAddress is not null and @Password is not null 
		raiserror('Cannot use ClubID and Credentials',15,1)
    else
		select * from ClubUsers
		         outer apply (select [Club Name] from Clubs where ID=ClubID) C
			where ClubID=@ClubID
			  and (@eMailAddress is null or eMailAddress=@eMailAddress) 
else
	if @EmailAddress is not null    -- else return nothing = login failure (ClubID = 0)
		select * from ClubUsers
		         outer apply (select [Club Name] from Clubs where ID=ClubID) C
			where eMailAddress=@eMailAddress
			  and (@ClubID=-9 or Password=@Password collate SQL_Latin1_General_CP1_CS_AS)


GO

/****** Object:  StoredProcedure [dbo].[confirmLogin]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[confirmLogin]
	(@eMailAddress varchar(255)
	,@Password varchar(255)
	,@ConfirmCode varchar(10)
	)
as

set noCount on	

update Resultsusers
	set Confirmed = 'Confirmed'
where eMailAddress=@eMailAddress
  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS
  and Confirmed = @ConfirmCode

insert ActivityLog values
	(getdate(),'ConfirmUser',null,@eMailAddress+'|'+@Password+'|'+@ConfirmCode)  



GO

/****** Object:  StoredProcedure [dbo].[confirmClubLogin]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[confirmClubLogin]
	(@eMailAddress varchar(255)
	,@Password varchar(255)
	,@ConfirmCode varchar(10)
	)
as

set noCount on	

update ClubUsers
	set Confirmed = 'Confirmed'
where eMailAddress=@eMailAddress
  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS
  and Confirmed = @ConfirmCode collate SQL_Latin1_General_CP1_CS_AS

if @@ROWCOUNT > 0
	insert ActivityLog values
		(getdate(),'ConfirmClubUser',null,@eMailAddress+'|'+@Password+'|'+@ConfirmCode)  
else
	raiserror('Confirmation failed',15,1)


GO

/****** Object:  StoredProcedure [dbo].[MergeClubUser]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[MergeClubUser]
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
		(getdate(),'Merge Club user',null,@eMailAddress+'|'+@Password+'|'+@Confirmed)  

commit tran


GO

/****** Object:  StoredProcedure [dbo].[LoginPasswordReset]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[LoginPasswordReset]
	(@UserID           int
	,@Password     varchar(255)
	)
as

set noCount on	

update Resultsusers 
	set Password=@Password
		
	where ID=@UserID


GO

/****** Object:  StoredProcedure [dbo].[loginDetails]    Script Date: 18/02/2017 13:52:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[loginDetails]
	(@eMailAddress varchar(255) = NULL
	,@TeamID       int = NULL
	,@ID           int = NULL
	)
as

set noCount on	

select eMailAddress
      ,[Password]
      ,Club=C.[Club Name]
      ,Team = T.Team
      ,Section = S.[Section Name]
      ,Confirmed=Confirmed
      ,League=L.[League Name]
      ,FirstName = ISNULL(Firstname,'')
      ,Surname=  ISNULL(Surname,'')
      ,Telephone = ISNULL(Telephone,'')
	  ,U.ID
	from Resultsusers U
	join Teams T on U.TeamID=T.ID
	join Clubs C on C.ID=T.ClubID
	join Sections S on S.ID=T.SectionID
	join Leagues L on L.ID=S.LeagueID
	
	where (eMailAddress=@eMailAddress and TeamID = @TeamID)
	   or U.ID=@ID
	order by case when Confirmed <> 'Confirmed' then Confirmed else '' end


GO


/****** Object:  StoredProcedure [dbo].[FullTeamList]    Script Date: 18/02/2017 14:07:05 ******/
DROP PROCEDURE [dbo].[FullTeamList]
GO

/****** Object:  StoredProcedure [dbo].[FullTeamList]    Script Date: 18/02/2017 14:07:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[FullTeamList]

as

set nocount on	

select T.ID, Team= [Club Name] + ' ' + Team + ' - ' + [League Name] + case when [Section Name] = '' then '' else ' (' + rtrim([Section Name]) + ')' end
	from    Teams T 
	join Clubs C on C.ID=T.ClubID
	join Sections S on S.ID = SectionID
	join Leagues L on L.ID=LeagueID
	where [Club Name] <> 'Bye'

order by Team


GO


