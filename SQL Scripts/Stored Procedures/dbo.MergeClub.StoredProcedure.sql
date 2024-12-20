USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select Routine_name from information_schema.routines where ROUTINE_NAME = 'MergeClub')
	drop procedure [dbo].[MergeClub]
GO

create procedure [dbo].[MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	,@MatchTables int = 0
	)

as
set nocount on    
set xact_abort on

begin tran

MERGE Clubs AS target
    USING (SELECT @ClubID) AS source (ID)
    
    ON (target.ID = source.ID)
    
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
					
    WHEN NOT MATCHED AND @ClubName <> '' AND @ClubID=-1 THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables)
		
		OUTPUT $action;

if @ClubID = -1
	begin
	declare @val varchar(1000)
	Select @val = [value] from [Configuration] where [key]='AllowLeaguesEntryForms'
	if @val = '1' or @val = 'true'
		insert EntryForm_Clubs
			    (ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				,WIP
				,PrivacyAccepted
				)
		select top 1 
			*, 0, 0 
			from Clubs
			order by ID desc
	end

commit tran

GO

--exec MergeClub 
--	@ClubID = -1
--	,@ClubName = 'try a new omne'
--	,@Address1 = 'address1'
--	,@Address2 = 'addre2'
--	,@PostCode = 'pcode'
--	,@ContactName = 'name'
--	,@ContactEMail = 'emasil'
--	,@ContactTelNo = 'telno'
--	,@ContactMobNo  = ''
--	,@MatchTables = 1

--select top 1 * from Clubs order by ID desc
--select top 1 * from Entryform_Clubs order by ClubID desc