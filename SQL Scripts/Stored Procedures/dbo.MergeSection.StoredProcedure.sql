USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MergeSection]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MergeSection]
	(@SectionID int           --if = -1 insert new record
	,@SectionName varchar(50) --if = remove delete record with this ID
	,@LeagueID	int = 0
	,@ReversedMatrix	tinyint = 0
	)
as
set nocount on     
set xact_abort on

begin tran

MERGE Sections AS target
    USING (SELECT @SectionID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @SectionName='remove' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Section Name]		= @SectionName
           ,LeagueID	= @LeagueID
		   ,ReversedMatrix	= @ReversedMatrix
					
    WHEN NOT MATCHED AND @SectionID=-1 THEN    
		INSERT ( LeagueID
				,[Section Name]
				,ReversedMatrix
				)
			values(@LeagueID
				  ,@SectionName
				  ,@ReversedMatrix
			      )
		
		OUTPUT $action;

--resequence the table
select * into #tmpSections from Sections
truncate table sections
insert Sections
	select LeagueID,[Section Name],ReversedMatrix 
		from #tmpSections
		order by ID
drop table #tmpSections	

commit tran
	


GO
