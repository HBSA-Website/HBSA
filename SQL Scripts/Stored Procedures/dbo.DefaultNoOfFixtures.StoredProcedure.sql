USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[DefaultNoOfFixtures]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[DefaultNoOfFixtures]
	@SectionID int

as

set nocount on

select count(*)*2-2 
	from Teams 
	where sectionid=@SectionID



GO
