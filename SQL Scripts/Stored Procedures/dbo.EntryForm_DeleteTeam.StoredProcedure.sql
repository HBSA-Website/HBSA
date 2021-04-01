USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[EntryForm_DeleteTeam]    Script Date: 29/12/2014 17:17:00 ******/
DROP PROCEDURE [dbo].[EntryForm_DeleteTeam]
GO

/****** Object:  StoredProcedure [dbo].[EntryForm_DeleteTeam]    Script Date: 29/12/2014 17:17:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--EntryID	TeamID	SectionID	FixtureNo	ClubID	Team	TelNo	Contact	eMail

CREATE procedure [dbo].[EntryForm_DeleteTeam]
	(@ClubID int
	,@LeagueID int
	,@Team char(1)
	)
as
set nocount on     
set xact_abort on

if exists (select ClubID 
				from EntryForm_Players
				where ClubID=@ClubID
				  and LeagueID=@LeagueID
				  and Team=@Team
				  and ReRegister=1)
	raiserror('Cannot delete - Players are registered to this team. Reassign or delete them first.',17,1)
else
	delete EntryForm_Teams
		where ClubID=@ClubID
		  and LeagueID=@LeagueID
		  and Team=@Team

GO


