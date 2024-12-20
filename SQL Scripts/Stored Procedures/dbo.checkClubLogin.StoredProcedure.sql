USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='checkClubLogin')
	drop procedure checkClubLogin
GO

CREATE procedure dbo.checkClubLogin
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
EXEC checkClubLogin @eMailAddress='gilbertp@outlook.com',@ClubID=43
EXEC checkClubLogin @eMailAddress='gilbertp@outlook.com', @Password='KIpfsWwEBJ6SWf6SS3csvlIdxaR2N8tppEFPuRP1ZYU='
--EXEC checkClubLogin @eMailAddress='gilbertp@outlook.com', @Password='', @ClubID=-9
--EXEC checkClubLogin @eMailAddress='gilbertp@outlook.com', @Password='Al1stairA',@ClubID=43
--EXEC checkClubLogin @ClubID=43

