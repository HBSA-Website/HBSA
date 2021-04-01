USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ReportAGM_Vote')
	drop procedure dbo.ReportAGM_Vote
GO

CREATE procedure dbo.ReportAGM_Vote
	@ClubID int = 0

as

set nocount on

select Resolution, VotesFor=sum(convert(int,[For])), VotesAgainst=sum(convert(int,Against)), VotesWithheld=sum(convert(int,Withheld))
	from AGM_Votes_Cast V
	left join AGM_Votes_Resolutions R
	    on R.ID = ResolutionID
	where @ClubID = 0
	   or @ClubID = ClubID
	group by ResolutionID,Resolution
	order by ResolutionID
GO
exec ReportAGM_Vote 51
