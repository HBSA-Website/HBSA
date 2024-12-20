USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CompetitionEntryForm_MergeClubData')
	drop procedure CompetitionEntryForm_MergeClubData
GO

create procedure CompetitionEntryForm_MergeClubData
	(@ClubID int       
	,@WIP int 
	,@PrivacyAccepted bit
	)

as
set nocount on     

MERGE Competitions_EntryFormsClubs AS target
    USING (SELECT @ClubID) AS source (ClubID)
    
    ON (target.ClubID = source.ClubID)
    
    
    WHEN MATCHED THEN 
        UPDATE SET
             WIP = @WIP
            ,PrivacyAccepted = @PrivacyAccepted

					
    WHEN NOT MATCHED THEN    
		INSERT  (ClubID
				,WIP
				,PrivacyAccepted
                )
		values  (	 @ClubID
					,1
					,0)
			;

GO