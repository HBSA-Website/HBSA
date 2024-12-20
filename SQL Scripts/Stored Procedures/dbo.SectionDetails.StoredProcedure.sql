USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SectionDetails]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[SectionDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID
	,LeagueID 
	,[Section Name]	= isnull([Section Name],'')
	,ReversedMatrix
	
	from Sections 
	
	where ID = @ID

select Team,[Section Name],[Section Name], [Club Name]
	from Teams 
	join Clubs on Clubs.ID=Clubid
	join Sections on Sections.ID=SectionID
	WHERE SectionID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where SectionID=@ID
	order by Team, Forename,surname



GO
