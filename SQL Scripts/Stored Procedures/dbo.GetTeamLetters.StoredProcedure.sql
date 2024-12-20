USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetTeamLetters]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetTeamLetters')
	DROP procedure [dbo].[GetTeamLetters] 
GO

CREATE procedure [dbo].[GetTeamLetters] 
	 @SectionID int = 0
	,@ClubId int
	,@LeagueID int = 0	

as
	
set nocount on
	
if @LeagueID=0
	select ID,Team
		from Teams 
		where SectionID=@SectionID
		  and ClubId = @ClubId
		order by Team
else
	select T.ID,Team, SectionID, Section=[Section Name]
		from Teams T
		join Sections S on S.ID=SectionID
		where SectionID in (select ID from Sections where LeagueID = @LeagueID)
		  and ClubId = @ClubId
		order by SectionID
GO
exec GetTeamLetters 0,31,1
exec GetTeamLetters 2,31