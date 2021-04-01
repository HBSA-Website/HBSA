USE [HBSA]
GO

if exists (select table_name from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Covid19Compliance')
	drop table dbo.Covid19Compliance
GO

create table  dbo.Covid19Compliance 
	(ClubID int
	,Check1 bit
	,Check2 bit
	,Check3 bit
	,Check4 bit
	,Text3 varchar(2000)
	,Text4 varchar(2000)
	,Text5 varchar(2000)
	,dtLodged datetime
	)
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Covid19Compliance_Report')
	drop procedure dbo.Covid19Compliance_Report
GO

create procedure  dbo.Covid19Compliance_Report 
	(@ClubID int = 0
	)
as

set nocount on

select C.[Club Name], Covid19Compliance.*
	From Covid19Compliance 
	cross apply (select [club name] from Clubs where ID = ClubID) C
	where @ClubID=0 or @ClubID = ClubID
	order by [Club Name]
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
			,dtLodged = dbo.UKdateTime (getutcdate())
	
	WHEN NOT MATCHED THEN
		INSERT 
			( ClubID, Check1, Check2, Check3, Check4, Text3, Text4, Text5, dtLodged)
		values
			(@ClubID,@Check1,@Check2,@Check3,@Check4,@Text3,@Text4,@Text5,dbo.UKdateTime (getutcdate()))

	;
GO
