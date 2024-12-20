USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[otherTeams]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[otherTeams]
	@TeamID as integer
as

select otherTeam=rtrim([Club Name] + ' ' + Team), T.ID
	from    Teams T 
	join Clubs on ClubID = Clubs.ID 
	where SectionID=(select SectionID from teams where ID=@TeamID) 
	  and T.ID <> @TeamID
	  and [Club Name] <> 'Bye'
	order by [Club Name]


GO
