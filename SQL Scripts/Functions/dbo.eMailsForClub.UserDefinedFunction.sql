USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[eMailsForClub]    Script Date: 16/06/2020 14:02:17 ******/
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where routine_name='eMailsForClub')
	drop function [dbo].[eMailsForClub]
GO

create FUNCTION [dbo].[eMailsForClub]
	(@ClubID int
	)

RETURNS varchar(4000)

AS

BEGIN

declare @eMails table (eMail varchar(255))

--insert @emails select isnull(ContactEMail,'') from Clubs where ID=@ClubID
insert @emails select isnull(eMailAddress,'') from ClubUsers where ClubID=@clubID
insert @emails select isnull(eMailAddress,'') from resultsUsers join teams on teams.ID=TeamID where ClubID=@clubID
--insert @emails select isnull(email,'') from teams where ClubID=@clubID

declare eMailAdressesCursor cursor fast_forward for 
	select distinct * from @eMails where eMail <> ''
declare @eMailAddressList varchar(max)
	   ,@eMailAddress varchar(255)
set @eMailAddressList=''
open eMailAdressesCursor
fetch eMailAdressesCursor into @eMailAddress
while @@FETCH_STATUS=0
	begin
	set @eMailAddressList = @eMailAddressList+@eMailAddress + ';'
	fetch eMailAdressesCursor into @eMailAddress
	end

close eMailAdressesCursor
deallocate eMailAdressesCursor

 return left(@eMailAddressList,len(@eMailAddressList)-1)
 
END
GO
select dbo.eMailsForClub(51)

