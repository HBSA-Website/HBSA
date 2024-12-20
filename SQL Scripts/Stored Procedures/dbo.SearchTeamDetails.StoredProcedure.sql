USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SearchTeamDetails]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SearchTeamDetails]
	@ClubName varchar (255)
as
set nocount on
	
select LeagueID, [League Name], SectionID, [Section Name], ClubID, [Club Name], TeamID=T.ID, Team
from    Teams T 
join Clubs C on C.ID=T.ClubID
join Sections S on S.ID=T.SectionID
join Leagues L on L.ID=S.LeagueID
where [Club Name] like '%' + @ClubName + '%'
order by [Club Name], LeagueID, SectionID, Team


GO
