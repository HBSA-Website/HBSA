USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[adminEmailAddresses]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='adminEmailAddresses')
	drop procedure [dbo].[adminEmailAddresses]
GO

create procedure [dbo].[adminEmailAddresses]

as

set noCount on	

declare @eMailAddressList varchar(4000)
declare @email varchar(50)
declare emailCursor cursor fast_forward for
	select email from admin
open emailCursor
fetch emailCursor into @emailAddressList
while @@fetch_status=0
	begin
	fetch emailCursor into @email
	if @@fetch_status = 0
		set @eMailAddressList=@eMailAddressList + ';' + @email
	end
close 	emailCursor
deallocate emailCursor

select @eMailAddressList

GO
exec [adminEmailAddresses]