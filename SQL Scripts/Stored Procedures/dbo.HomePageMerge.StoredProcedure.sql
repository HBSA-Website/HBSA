USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageMerge')
	drop procedure dbo.HomePageMerge
GO

create procedure dbo.HomePageMerge
	(@ID as integer
	,@Title as varchar(64)
	,@ArticleHTML as varchar(max)
	)
as	

set nocount on
set xact_abort on

--If @ID < 0  --to be deleted
	--archive the article
--If @ID > 0 to be changed
	-- if Title or HTML differs
	--archive the article

MERGE HomeContent AS target
    USING (SELECT abs(@ID), @Title, @ArticleHTML) AS source (ID, Title, ArticleHTML)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @ID < 0 THEN
		DELETE

	WHEN MATCHED THEN 
        UPDATE SET
			 Title=@Title
			,ArticleHTML=@ArticleHTML
			,dtLodged=dbo.UKdateTime(getUTCdate())
             		
    WHEN NOT MATCHED AND @ID=0 THEN    
		INSERT	(Title, ArticleHTML, dtLodged)
		VALUES (@Title, @ArticleHTML, dbo.UKdateTime(getUTCdate()))
	;

GO

exec HomePageMerge -3, '3rd one','Another new one pleased'