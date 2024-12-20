USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[checkLogin]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[checkLogin]
	(@eMailAddress varchar(255) = NULL
	,@Password varchar(255) = NULL
	,@ID int = NULL)
as

set noCount on	

select * 
	from Resultsusers
	where eMailAddress=case when @eMailAddress is null then emailaddress else @emailaddress end
	  and (Password=@Password collate SQL_Latin1_General_CP1_CS_AS 
	       or (@Password is null and ID=@ID)
	       )   
GO
