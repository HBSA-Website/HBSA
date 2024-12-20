USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[getTeams]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[getTeams]
	@SectionID int

as

set nocount on

select TeamID=Teams.ID
      ,SectionID
	  ,Team=[Club Name] + ' ' + Team
from Teams
join Clubs on Clubs.ID=ClubID


where SectionID = @SectionID	
  and [Club Name] <> 'Bye'

order by [Club Name], Team



GO
