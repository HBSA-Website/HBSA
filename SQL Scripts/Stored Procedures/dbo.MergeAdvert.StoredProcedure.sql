USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergeAdvert')
	drop procedure MergeAdvert
GO

CREATE procedure MergeAdvert
	(@Advertiser varchar(255) = ''
	,@Extension varchar(15) --null or empty = delete
	,@WebURL varchar(1023) = ''
	,@AdvertBinary varbinary(max)=null
	)
as

set nocount on

MERGE Adverts AS target
    USING (SELECT Advertiser=@Advertiser) AS source 
    
    ON (target.Advertiser = source.Advertiser)
    
    WHEN MATCHED and isnull(@Extension,'')='' THEN
		delete

	WHEN MATCHED THEN 
        UPDATE SET
			 Extension			= @Extension
			,Advertiser			= case when isnull(@Advertiser,'')='' then target.Advertiser else source.Advertiser end
			,WebURL				= @WebURL 
            ,AdvertBinary		= case when (@AdvertBinary is null or len(@AdvertBinary)=0 or @AdvertBinary=0x00) then AdvertBinary else @AdvertBinary end
					
    WHEN NOT MATCHED THEN    
		INSERT ( Advertiser,  Extension,  WebURL,  AdvertBinary)
		VALUES (@Advertiser, @Extension, @WebURL, @AdvertBinary)
		
	;

GO

select * from Adverts