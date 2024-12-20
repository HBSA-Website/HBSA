USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetTeamsByClubs]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetTeamsByClubs] 
	 @SectionID int = 0
	,@ClubId int = 0

as
	
set nocount on
	
select  Distinct Team
	from Teams 
	where (@SectionID=SectionID or @SectionID=0)
	  and (@ClubId=ClubId or @ClubId=0)
	order by Team


GO
