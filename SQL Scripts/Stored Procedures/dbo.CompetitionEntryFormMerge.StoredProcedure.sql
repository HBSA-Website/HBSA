USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionEntryFormMerge')
	drop procedure CompetitionEntryFormMerge
GO

CREATE procedure CompetitionEntryFormMerge
	(@ClubID int
	,@CompetitionID int
	,@EntrantID int
	,@Entrant2ID int = NULL
    )

as

set nocount on
set xact_abort on

merge
	Competitions_EntryForms as target
	using (select  ClubID        = @ClubID
			      ,CompetitionID = @CompetitionID
				  ,EntrantID     = @EntrantID 
				  ,Entrant2ID    = @Entrant2ID) as source
	 on target.ClubID=source.ClubID
	and target.CompetitionID=source.CompetitionID
	and target.EntrantID=source.EntrantID

	when matched and source.Entrant2ID = -1 then
		delete

	when matched then
		update
		set target.Entrant2ID=source.Entrant2ID

	when not matched then
		insert (ClubID
			   ,CompetitionID
			   ,EntrantID
			   ,Entrant2ID)
		values (source.ClubID
		       ,source.CompetitionID
			   ,source.EntrantID
			   ,source.Entrant2ID)

;
GO	
