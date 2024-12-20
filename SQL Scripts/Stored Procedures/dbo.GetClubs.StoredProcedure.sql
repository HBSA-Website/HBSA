USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetClubs]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetClubs')
	drop procedure [dbo].[GetClubs]
GO

CREATE procedure [dbo].[GetClubs]
	(@SectionID int
	,@IncludeBye bit = 0
	)

as

set nocount on

if @SectionID > 99 
	select distinct c.ID, c.[Club Name]
		from Clubs c
		left join Teams t on ClubID = c.ID
		where (@SectionID=100 or SectionID in (Select ID from Sections where LeagueID=@SectionID % 100))
		  and (@IncludeBye = 1 or c.[Club Name] <> 'Bye')
		order by c.[Club Name]
else
	select distinct c.ID, c.[Club Name]
		from Clubs c
		left join Teams t on ClubID = c.ID
		where (@SectionID=0 or sectionid=@SectionID)
		   and (@IncludeBye = 1 or c.[Club Name] <> 'Bye')
		order by c.[Club Name]




GO
