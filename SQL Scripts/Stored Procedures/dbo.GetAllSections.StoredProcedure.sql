USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetAllSections]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllSections]

as

set nocount on

select
	 Sections.ID	
	,[Section Name]	= isnull([Section Name],'')
	,League	= isnull([League Name],0)
	,ReversedMatrix	= isnull(ReversedMatrix,0)
	
	from Sections 
	join Leagues on LeagueID=Leagues.ID
	
	ORDER BY ID



GO
