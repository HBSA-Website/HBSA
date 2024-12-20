USE [HBSA]
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='UpdateHandicaps')
	drop procedure UpdateHandicaps
GO

create procedure [dbo].[UpdateHandicaps]
	(@LeagueID int = 0
	,@SectionID int = 0
	)
as

set nocount on

Update Players
	set Handicap=[New Handicap]
	from Players P
	cross apply (select [New Handicap]
					from HandicapsReportTable H
					where PlayerID=P.ID
					  and Effective = (select Max(Effective) from HandicapsReportTable where PlayerID=H.PlayerID)) Handicap
	where (P.SectionID = @SectionID or @SectionID = 0)  
	  and (LeagueID    = @LeagueID  or @LeagueID  = 0)


GO
