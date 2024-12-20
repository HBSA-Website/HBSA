USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MergeHomepages]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter Procedure [dbo].[MergeHomepages]
	(@Pagename varchar(255)
	,@HitCounter int
	)
as

set nocount on
set xact_abort on

begin tran

MERGE Homepages AS target
    USING (SELECT @Pagename) AS source (Pagename)
    
    ON (target.Pagename = source.Pagename)
    
    WHEN MATCHED AND @Pagename='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            HitCounter = @HitCounter
					
    WHEN NOT MATCHED AND @Pagename <> '' THEN    
		INSERT ( Pagename, HitCounter)
			values(	 @Pagename, @HitCounter);

commit tran

GO
