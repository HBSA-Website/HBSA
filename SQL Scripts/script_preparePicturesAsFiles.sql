USE [HBSA]

EXEC sp_rename 'dbo.Pictures.PictureName', 'Filename', 'COLUMN'; 

alter table Pictures
	alter column [FileName] varchar(255) 
GO
ALTER table pictures
	drop column PictureBinary
GO
select top 1 * from Pictures

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergePictureCategory')
	drop procedure MergePictureCategory
GO

CREATE procedure MergePictureCategory
	(@Sequence int
	,@Category varchar(127)
	)
as

set nocount on
set xact_abort on

begin tran

If @Sequence = -1 
	delete Pictures 
		where Category=@Category

MERGE PictureCategories AS target
    USING (SELECT Category=@Category) AS source 
    
    ON target.Category=source.Category
    
    WHEN MATCHED and @Sequence = -1 THEN
		delete

	WHEN MATCHED THEN 
        UPDATE SET
			 Sequence=@Sequence
					
    WHEN NOT MATCHED THEN    
		INSERT (Sequence, Category)
		VALUES (@Sequence, @Category)
	;

declare @ContentName varchar(127)
set @ContentName='Gallery - ' + @Category

if not exists (select ContentName from ContentData where ContentName = @ContentName)
	insert ContentData select (@ContentName),'',getUTCdate()

if @Sequence = -1
	begin
	delete Pictures where Category=@Category
	delete ContentData where ContentName = @ContentName
	end

commit tran

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureBinary')
	drop procedure GetPictureBinary
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureDetails')
	drop procedure GetPictureDetails
GO

CREATE procedure GetPictureDetails
	(@Category varchar(127)
	,@Filename varchar(255)
	)
as

set nocount on

Select Extension, [Description]
	from Pictures
	where isnull(Category,'Gallery')=isnull(@Category,'Gallery')
	  and isnull([Filename],'None')=isnull(@Filename,'None') 

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPictureNames')
	drop procedure GetPictureNames
GO

CREATE procedure GetPictureNames
	(@category varchar(127)
	)
as

set nocount on

select [Filename], [Description] 
	from Pictures
	where Category=@category
	  and [Filename] is not null
	order by [Filename]

GO

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
exec GetPictureNames 'General'