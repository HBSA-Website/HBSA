USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[adminCCAddresses]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[adminCCAddresses]
	@userName varchar(50)
as

set noCount on	

declare @eMailAddressList varchar(4000)
declare @email varchar(50)
declare emailCursor cursor fast_forward for
	select email from admin where Username <> @userName
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
