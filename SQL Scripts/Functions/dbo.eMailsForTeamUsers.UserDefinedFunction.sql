USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'eMailsForTeamUsers')
	drop FUNCTION eMailsForTeamUsers
GO

CREATE FUNCTION eMailsForTeamUsers
	(@TeamID int
	)

RETURNS varchar(4000)

AS

BEGIN

declare ResultsUsersCursor cursor fast_forward for
	select eMailAddress
		from ResultsUsers
		where teamID=@TeamID
		  and Confirmed='Confirmed'
declare @eMailAddressList varchar(250)
declare @eMails varchar(4000)
open ResultsUsersCursor
fetch ResultsUsersCursor into @eMailAddressList
set @eMails = @eMailAddressList
while @@fetch_status = 0
	begin
	fetch ResultsUsersCursor into @eMailAddressList
	if @@fetch_status = 0
		set @emails = @eMails + ';' + @eMailAddressList
	end
close ResultsUsersCursor
deallocate ResultsUsersCursor
return @eMails
   
END



GO


