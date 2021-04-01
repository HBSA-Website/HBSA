USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MergeAGM_Vote')
	drop procedure dbo.MergeAGM_Vote
GO

CREATE procedure dbo.MergeAGM_Vote
	(@ClubID int 
	,@ResolutionID int
	,@For bit
	,@Against bit
	,@Withheld bit
	)
as

set noCount on	
set xact_abort on

MERGE AGM_Votes_Cast AS target
    USING (SELECT @ClubID, @ResolutionID) AS source (ClubID, ResolutionID)
    
    ON (target.ClubID = source.ClubID and target.ResolutionID = source.ResolutionID)
    
    WHEN MATCHED THEN 
        UPDATE SET
			 [For]    = @For
			,Against  = @Against
			,Withheld = @Withheld
	
	WHEN NOT MATCHED THEN
		INSERT 
			( ClubID, ResolutionID, [For], Against, Withheld)
		values
			(@ClubID,@ResolutionID, @For, @Against,@Withheld)

	;

GO

exec MergeAGM_Vote 43,1,1,0,0