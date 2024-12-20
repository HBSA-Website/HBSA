USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[LeagueDetails]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter procedure [dbo].[LeagueDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID
	,[League Name]	= isnull([League Name],'')
	,MaxHandicap
	,MinHandicap
	from Leagues 

	where ID = @ID

select * 
	From Sections 
	where LeagueID=@ID

select Team,[League Name],[Section Name], [Club Name]
	from Teams 
	join Clubs on Clubs.ID=Clubid
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE LeagueID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where LeagueID=@ID
	order by Team, Forename,surname



GO
exec LeagueDetails 3