USE [HBSA]

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
	insert ContentData select (@ContentName),'',dbo.UKdateTime(getUTCdate())

if @Sequence = -1
	begin
	delete Pictures where Category=@Category
	delete ContentData where ContentName = @ContentName
	end

commit tran

GO

