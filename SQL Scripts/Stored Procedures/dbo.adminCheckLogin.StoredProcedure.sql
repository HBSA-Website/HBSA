USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[adminCheckLogin]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[adminCheckLogin]
	(@userName varchar(255)
	,@Password varchar(25)
	)
as

set noCount on	

select * from admin
	where username=@userName
	  and Password=@Password collate SQL_Latin1_General_CP1_CS_AS



GO
