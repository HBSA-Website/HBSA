USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetAllLeagues]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllLeagues]

as

set nocount on

select
	 ID	= isnull(ID,'')
	,[League Name]	= isnull([League Name],'')

	from Leagues 
	ORDER BY ID



GO
