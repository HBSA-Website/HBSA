USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_MergeClub')
	drop procedure dbo.EntryForm_MergeClub
GO

USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 05/09/2020 17:35:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[EntryForm_MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	,@MatchTables int = 0
	,@PrivacyAccepted bit = 0
	)

as
set nocount on     
set xact_abort on

begin tran

declare @NewClub bit
set @NewClub = 0

if @ClubName='' 
	begin
	
	update EntryForm_Players 
		set ClubID = 0
		where ClubID=@ClubID
	
	delete EntryForm_Teams   
		where ClubID=@ClubID
	
	end

else
	
	if @ClubID <= 0 --will insert a new club
		begin
		select @ClubID=dbo.InlineMax((select max(ClubID)+1 from EntryForm_Clubs)
			                        ,(select max(ID)+1 from Clubs))
		set @NewClub = 1
		end

MERGE EntryForm_Clubs AS target
    USING (SELECT @ClubID) AS source (ClubID)
    
    ON (target.ClubID = source.ClubID)
    
    WHEN MATCHED AND @ClubName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= @ClubName
			,Address1		= @Address1
			,Address2		= @Address2
			,PostCode		= @PostCode
			,ContactName	= @ContactName
			,ContactTelNo	= @ContactTelNo
			,ContactMobNo	= @ContactMobNo
			,MatchTables    = @MatchTables
			,PrivacyAccepted = @PrivacyAccepted
					
    WHEN NOT MATCHED AND @ClubName <> '' THEN    
		INSERT ( ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				,WIP
				,PrivacyAccepted)
			values(	 @ClubID
					,@ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables
					,1
					,0)
			;

if @NewClub = 1
	begin
	set identity_insert Clubs on
	insert Clubs
				( ID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
		select   ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
			from EntryForm_Clubs
			where @ClubID=ClubID


	set identity_insert Clubs on
	end
--return the (new) clubID
	select @ClubID
	
commit tran

GO

