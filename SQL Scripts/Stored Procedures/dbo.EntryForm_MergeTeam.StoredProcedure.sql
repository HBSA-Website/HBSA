USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_MergeTeam')
	drop procedure dbo.EntryForm_MergeTeam
GO

create procedure dbo.EntryForm_MergeTeam
	(@ClubID int
	,@LeagueID	int		--if = -1 delete record
	,@Team char(1)
	,@Captain int
	)
as
set nocount on     
set xact_abort on

MERGE EntryForm_Teams AS target
    USING (SELECT @ClubID,@LeagueID,@Team) AS source (ClubID, LeagueID,Team)
    
    ON (    target.ClubID   = source.ClubID 
	    AND target.LeagueID  = source.LeagueID
		AND target.Team      = source.team          )
    
    WHEN MATCHED and @LeagueID < 0 THEN
		DELETE
	 
	WHEN MATCHED THEN 
        UPDATE SET
             Team=@Team
			,Captain=@Captain
					
    WHEN NOT MATCHED THEN    
		INSERT	(ClubID
			    ,LeagueID
				,Team
				,Captain
				)
		values	(@ClubID
				,@LeagueID
				,@Team
				,@Captain
				)
		
		OUTPUT $action;
GO
select * from EntryForm_Teams