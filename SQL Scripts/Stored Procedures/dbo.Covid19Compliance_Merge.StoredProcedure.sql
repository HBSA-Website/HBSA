USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Covid19Compliance_Merge')
	drop procedure dbo.Covid19Compliance_Merge
GO

create procedure  dbo.Covid19Compliance_Merge 
	(@ClubID int
	,@Check1 bit
	,@Check2 bit
	,@Check3 bit
	,@Check4 bit
	,@Text3 varchar(2000)
	,@Text4 varchar(2000)
	,@Text5 varchar(2000)
	)
as

set nocount on
set xact_abort on

MERGE Covid19Compliance AS target
    USING (SELECT @ClubID) AS source (ClubID)
    
    ON (target.ClubID = source.ClubID)
    
    WHEN MATCHED THEN 
        UPDATE SET
			 Check1 = @Check1
			,Check2 = @Check2
			,Check3 = @Check3 
			,Check4 = @Check4 
			,Text3  = @Text3
			,Text4  = @Text4
			,Text5  = @Text5
			,dtLodged = dbo.UKdateTime (getdate())
	
	WHEN NOT MATCHED THEN
		INSERT 
			( ClubID, Check1, Check2, Check3, Check4, Text3, Text4, Text5, dtLodged)
		values
			(@ClubID,@Check1,@Check2,@Check3,@Check4,@Text3,@Text4,@Text5,dbo.UKdateTime (getutcdate()))

	;
GO
