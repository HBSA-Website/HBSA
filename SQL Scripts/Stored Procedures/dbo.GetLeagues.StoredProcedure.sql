USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetLeagues]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetLeagues]


as

select * from Leagues
	order by ID


GO
