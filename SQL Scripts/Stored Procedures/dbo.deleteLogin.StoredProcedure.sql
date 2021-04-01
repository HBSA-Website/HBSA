USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[deleteLogin]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[deleteLogin]
	(@eMailAddress varchar(255)
	,@Password     varchar(255) = ''
	)
as

set noCount on	

delete Resultsusers
	where eMailAddress=@eMailAddress
	  and [Password] = @Password
insert ActivityLog values
	(dbo.UKdateTime(getUTCdate()),'DeleteUser',null,@eMailAddress+'|'+@Password)  


GO
