USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[TeamList2]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[TeamList2]
	(@SectionID int = 0
	)
as

set nocount on	

select T.ID, Team= [Club Name] + ' ' + Team, FixtureNo
	from    Teams T 
	join Clubs C on C.ID=T.ClubID

	where SectionID=@SectionID
	  --and [Club Name] <> 'Bye'

order by [Club Name],Team




GO
