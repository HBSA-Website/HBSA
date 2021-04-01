USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergePicture')
	drop procedure MergePicture
GO

CREATE procedure MergePicture
	(@Category varchar(127)
	,@Filename varchar(31)
	,@Extension varchar(15) --null or empty = delete
	,@Description varchar(1023) 
	)
as

set nocount on

MERGE Pictures AS target
    USING (SELECT Category=@Category, [Filename]=@Filename) AS source 
    
    ON (isnull(target.Category,'Gallery') = isnull(source.Category,'Gallery')
	and target.[Filename] = source.[Filename])
    
    WHEN MATCHED and isnull(@Extension,'')='' THEN
		delete

	WHEN MATCHED THEN 
        UPDATE SET
			 Extension			= @Extension
			,[Description]		= @Description
					
    WHEN NOT MATCHED THEN    
		INSERT (Category, [Filename], Extension, [Description])
		VALUES (isnull(@Category,'Gallery'), @Filename, @Extension, @Description)
		
	;

GO


